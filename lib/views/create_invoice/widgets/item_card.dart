import 'package:cloud_billr/controllers/create_invoice_provider.dart';
import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatefulWidget {
  final int index;
  final VoidCallback? onRemove;

  const ItemCard({
    super.key,
    required this.index,
    this.onRemove,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<CreateInvoiceProvider>(context, listen: false);

    // Sync controllers from provider state (handles re-render)
    final items = provider.items;
    if (widget.index < items.length) {
      final item = items[widget.index];
      _descController.text = item.description;
      _qtyController.text =
          item.quantity > 0 ? item.quantity.toStringAsFixed(0) : '';
      _rateController.text =
          item.rate > 0 ? item.rate.toStringAsFixed(2) : '';
    }

    _descController.addListener(_onDescChanged);
    _qtyController.addListener(_onNumericChanged);
    _rateController.addListener(_onNumericChanged);
  }

  void _onDescChanged() {
    Provider.of<CreateInvoiceProvider>(context, listen: false)
        .updateItem(widget.index, description: _descController.text);
  }

  void _onNumericChanged() {
    final qty = double.tryParse(_qtyController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;
    Provider.of<CreateInvoiceProvider>(context, listen: false)
        .updateItem(widget.index, quantity: qty, rate: rate);
  }

  @override
  void dispose() {
    _descController.removeListener(_onDescChanged);
    _qtyController.removeListener(_onNumericChanged);
    _rateController.removeListener(_onNumericChanged);
    _descController.dispose();
    _qtyController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateInvoiceProvider>(
      builder: (context, provider, _) {
        final items = provider.items;
        final lineTotal = widget.index < items.length
            ? items[widget.index].lineTotal
            : 0.0;
        final symbol = provider.currencySymbol;

        return Container(
          padding: EdgeInsets.all(AppSpacing.paddingMedium),
          margin: EdgeInsets.only(bottom: AppSpacing.marginMedium),
          decoration: BoxDecoration(
            color: appColors.backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(color: appColors.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Item ${widget.index + 1}',
                    style: TextStyle(
                      color: appColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      if (lineTotal > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: appColors.primaryColor.withValues(alpha: 0.1),
                            borderRadius: AppRadius.circle,
                          ),
                          child: Text(
                            '$symbol${lineTotal.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: appColors.primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      if (widget.onRemove != null) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: widget.onRemove,
                          icon: Icon(
                            Icons.delete_outline,
                            color: appColors.textSecondaryColor
                                .withValues(alpha: 0.8),
                          ),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.spacingM),
              _buildField(
                controller: _descController,
                hint: 'Item description',
              ),
              SizedBox(height: AppSpacing.spacingM),
              Row(
                children: [
                  Expanded(
                    child: _buildField(
                      controller: _qtyController,
                      hint: 'Quantity',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*')),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSpacing.spacingM),
                  Expanded(
                    child: _buildField(
                      controller: _rateController,
                      hint: 'Rate ($symbol)',
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*')),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: appColors.borderColor),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: TextStyle(color: appColors.textColor, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: appColors.textSecondaryColor.withValues(alpha: 0.5),
            fontSize: 14,
          ),
          contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.paddingMedium, vertical: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
