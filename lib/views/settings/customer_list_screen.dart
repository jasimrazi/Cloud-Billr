import 'package:cloud_billr/controllers/customer_provider.dart';
import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/models/customer_model.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/settings/add_edit_customer_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: appColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appColors.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Customer Profiles',
          style: TextStyle(
            color: appColors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: appColors.primaryColor),
            onPressed: () async {
              final result = await Navigator.push<CustomerModel>(
                context,
                MaterialPageRoute(builder: (_) => const AddEditCustomerScreen()),
              );

              if (result != null && context.mounted) {
                Provider.of<CustomerProvider>(context, listen: false).addCustomer(result);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Customer "${result.name}" added successfully.')),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<CustomerProvider>(
          builder: (context, provider, child) {
            final list = provider.customers;

            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 64,
                      color: appColors.textSecondaryColor.withValues(alpha: 0.4),
                    ),
                    SizedBox(height: AppSpacing.spacingM),
                    Text(
                      'No customer profiles saved yet',
                      style: TextStyle(
                        color: appColors.textSecondaryColor,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: AppSpacing.spacingM),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: appColors.borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                        ),
                      ),
                      onPressed: () async {
                        final result = await Navigator.push<CustomerModel>(
                          context,
                          MaterialPageRoute(builder: (_) => const AddEditCustomerScreen()),
                        );

                        if (result != null && context.mounted) {
                          provider.addCustomer(result);
                        }
                      },
                      icon: Icon(Icons.add, color: appColors.primaryColor),
                      label: Text(
                        'Add Profile',
                        style: TextStyle(color: appColors.textColor),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(AppSpacing.mainPadding),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final customer = list[index];
                final initials = customer.name.trim().isNotEmpty
                    ? customer.name.trim().substring(0, 1).toUpperCase()
                    : '?';

                return Container(
                  margin: EdgeInsets.only(bottom: AppSpacing.marginMedium),
                  padding: EdgeInsets.all(AppSpacing.paddingMedium),
                  decoration: BoxDecoration(
                    color: appColors.surfaceColor,
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    border: Border.all(color: appColors.borderColor),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: appColors.secondaryColor,
                        child: Text(
                          initials,
                          style: TextStyle(
                            color: appColors.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.name,
                              style: TextStyle(
                                color: appColors.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (customer.email.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                customer.email,
                                style: TextStyle(
                                  color: appColors.textSecondaryColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                            if (customer.phone.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                customer.phone,
                                style: TextStyle(
                                  color: appColors.textSecondaryColor.withValues(alpha: 0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            if (customer.address.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                customer.address,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: appColors.textSecondaryColor.withValues(alpha: 0.6),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(width: AppSpacing.spacingS),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            color: appColors.textSecondaryColor,
                            onPressed: () async {
                              final result = await Navigator.push<CustomerModel>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddEditCustomerScreen(customer: customer),
                                ),
                              );

                              if (result != null && context.mounted) {
                                provider.updateCustomer(result);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20),
                            color: appColors.redColor,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: appColors.backgroundColor,
                                  title: Text(
                                    'Delete Profile?',
                                    style: TextStyle(color: appColors.textColor),
                                  ),
                                  content: Text(
                                    'Are you sure you want to delete the customer profile for "${customer.name}"?',
                                    style: TextStyle(color: appColors.textSecondaryColor),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: appColors.textColor),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        provider.removeCustomer(customer.id);
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(color: appColors.redColor),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
