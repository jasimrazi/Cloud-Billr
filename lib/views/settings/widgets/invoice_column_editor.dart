import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/models/invoice_template_config_model.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:flutter/material.dart';

class InvoiceColumnEditor extends StatelessWidget {
  final List<InvoiceColumnConfig> columns;
  final ValueChanged<List<InvoiceColumnConfig>> onChanged;

  const InvoiceColumnEditor({
    super.key,
    required this.columns,
    required this.onChanged,
  });

  static const Map<String, String> _typeLabels = {
    'text': 'Text',
    'number': 'Number',
    'calculated': 'Auto-calc',
  };

  static const Map<String, IconData> _typeIcons = {
    'text': Icons.text_fields,
    'number': Icons.pin_outlined,
    'calculated': Icons.calculate_outlined,
  };

  void _onReorder(int oldIndex, int newIndex) {
    final updated = List<InvoiceColumnConfig>.from(columns);
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    final reindexed = updated
        .asMap()
        .entries
        .map((e) => e.value.copyWith(sortOrder: e.key))
        .toList();
    onChanged(reindexed);
  }

  void _toggleVisibility(int index) {
    final col = columns[index];
    if (col.isRequired) return;
    final updated = List<InvoiceColumnConfig>.from(columns);
    updated[index] = col.copyWith(isVisible: !col.isVisible);
    onChanged(updated);
  }

  void _deleteColumn(int index) {
    final updated = List<InvoiceColumnConfig>.from(columns);
    updated.removeAt(index);
    final reindexed = updated
        .asMap()
        .entries
        .map((e) => e.value.copyWith(sortOrder: e.key))
        .toList();
    onChanged(reindexed);
  }

  void _addColumn(BuildContext context) {
    final labelController = TextEditingController();
    String selectedType = 'text';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setModalState) {
          return Container(
            decoration: BoxDecoration(
              color: appColors.backgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            padding: EdgeInsets.only(
              left: AppSpacing.mainPadding,
              right: AppSpacing.mainPadding,
              top: AppSpacing.paddingLarge,
              bottom: MediaQuery.of(ctx).viewInsets.bottom +
                  AppSpacing.paddingLarge,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: appColors.borderColor,
                      borderRadius: AppRadius.circle,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.spacingL),
                Text(
                  'Add Column',
                  style: TextStyle(
                    color: appColors.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.spacingM),
                TextField(
                  controller: labelController,
                  autofocus: true,
                  style: TextStyle(color: appColors.textColor),
                  decoration: InputDecoration(
                    labelText: 'Column Name',
                    labelStyle:
                        TextStyle(color: appColors.textSecondaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.medium,
                      borderSide: BorderSide(color: appColors.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppRadius.medium,
                      borderSide:
                          BorderSide(color: appColors.primaryColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.spacingM),
                Text(
                  'Field Type',
                  style: TextStyle(
                    color: appColors.textSecondaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.spacingS),
                Row(
                  children: _typeLabels.entries.map((entry) {
                    final isSelected = selectedType == entry.key;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () =>
                            setModalState(() => selectedType = entry.key),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? appColors.primaryColor
                                : appColors.borderColor.withValues(alpha: 0.3),
                            borderRadius: AppRadius.medium,
                            border: Border.all(
                              color: isSelected
                                  ? appColors.primaryColor
                                  : appColors.borderColor,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _typeIcons[entry.key],
                                size: 15,
                                color: isSelected
                                    ? Colors.white
                                    : appColors.textSecondaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                entry.value,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : appColors.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.spacingL),
                SizedBox(
                  width: double.infinity,
                  height: AppSpacing.buttonHeight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColors.primaryColor,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.medium),
                    ),
                    onPressed: () {
                      final label = labelController.text.trim();
                      if (label.isEmpty) return;
                      final newCol = InvoiceColumnConfig(
                        id:
                            'custom_${DateTime.now().millisecondsSinceEpoch}',
                        label: label,
                        fieldType: selectedType,
                        isRequired: false,
                        isVisible: true,
                        sortOrder: columns.length,
                      );
                      onChanged([...columns, newCol]);
                      Navigator.pop(ctx);
                    },
                    child: const Text('Add Column',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorderItem: (oldIndex, newIndex) => _onReorder(oldIndex, newIndex),
          proxyDecorator: (child, index, animation) {
            return Material(
              color: Colors.transparent,
              child: child,
            );
          },
          itemCount: columns.length,
          itemBuilder: (context, index) {
            final col = columns[index];
            return _ColumnRow(
              key: ValueKey(col.id),
              column: col,
              onToggleVisibility: () => _toggleVisibility(index),
              onDelete: col.isRequired ? null : () => _deleteColumn(index),
            );
          },
        ),
        const SizedBox(height: AppSpacing.spacingM),
        GestureDetector(
          onTap: () => _addColumn(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: AppRadius.medium,
              border: Border.all(
                color: appColors.primaryColor.withValues(alpha: 0.5),
                style: BorderStyle.solid,
              ),
              color: appColors.primaryColor.withValues(alpha: 0.06),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: appColors.primaryColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Add Custom Column',
                  style: TextStyle(
                    color: appColors.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ColumnRow extends StatelessWidget {
  final InvoiceColumnConfig column;
  final VoidCallback onToggleVisibility;
  final VoidCallback? onDelete;

  const _ColumnRow({
    super.key,
    required this.column,
    required this.onToggleVisibility,
    this.onDelete,
  });

  static const Map<String, Color> _typeColors = {
    'text': Color(0xFF6C63FF),
    'number': Color(0xFF00A86B),
    'calculated': Color(0xFFFF9500),
  };

  static const Map<String, String> _typeLabels = {
    'text': 'Text',
    'number': 'Number',
    'calculated': 'Auto-calc',
  };

  @override
  Widget build(BuildContext context) {
    final chipColor = _typeColors[column.fieldType] ?? appColors.primaryColor;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: appColors.backgroundColor,
        borderRadius: AppRadius.medium,
        border: Border.all(color: appColors.borderColor),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: Icon(Icons.drag_handle,
            color: appColors.textSecondaryColor, size: 20),
        title: Row(
          children: [
            Expanded(
              child: Text(
                column.label,
                style: TextStyle(
                  color: appColors.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: chipColor.withValues(alpha: 0.12),
                borderRadius: AppRadius.circle,
              ),
              child: Text(
                _typeLabels[column.fieldType] ?? column.fieldType,
                style: TextStyle(
                  color: chipColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (column.isRequired)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: appColors.borderColor.withValues(alpha: 0.5),
                    borderRadius: AppRadius.circle,
                  ),
                  child: Text(
                    'Required',
                    style: TextStyle(
                      color: appColors.textSecondaryColor,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: column.isRequired ? null : onToggleVisibility,
              child: Icon(
                column.isVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
                color: column.isRequired
                    ? appColors.borderColor
                    : column.isVisible
                        ? appColors.primaryColor
                        : appColors.textSecondaryColor,
              ),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onDelete,
                child: Icon(Icons.delete_outline,
                    size: 20, color: appColors.redColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
