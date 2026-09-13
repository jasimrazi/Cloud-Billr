import 'package:cloud_billr/controllers/company_provider.dart';
import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/models/company_model.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/settings/add_edit_company_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompanyListScreen extends StatelessWidget {
  const CompanyListScreen({super.key});

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
          'Company Profiles',
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
              final result = await Navigator.push<CompanyModel>(
                context,
                MaterialPageRoute(builder: (_) => const AddEditCompanyScreen()),
              );

              if (result != null && context.mounted) {
                Provider.of<CompanyProvider>(context, listen: false).addCompany(result);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Company "${result.name}" added successfully.')),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<CompanyProvider>(
          builder: (context, provider, child) {
            final list = provider.companies;

            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.business,
                      size: 64,
                      color: appColors.textSecondaryColor.withValues(alpha: 0.4),
                    ),
                    SizedBox(height: AppSpacing.spacingM),
                    Text(
                      'No company profiles saved yet',
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
                        final result = await Navigator.push<CompanyModel>(
                          context,
                          MaterialPageRoute(builder: (_) => const AddEditCompanyScreen()),
                        );

                        if (result != null && context.mounted) {
                          provider.addCompany(result);
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
                final company = list[index];
                final initials = company.name.trim().isNotEmpty
                    ? company.name.trim().substring(0, 1).toUpperCase()
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
                              company.name,
                              style: TextStyle(
                                color: appColors.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (company.address.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                company.address,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: appColors.textSecondaryColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                            if (company.contactDetails.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                company.contactDetails,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: appColors.textSecondaryColor.withValues(alpha: 0.8),
                                  fontSize: 12,
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
                              final result = await Navigator.push<CompanyModel>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddEditCompanyScreen(company: company),
                                ),
                              );

                              if (result != null && context.mounted) {
                                provider.updateCompany(result);
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
                                    'Are you sure you want to delete the company profile for "${company.name}"?',
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
                                        provider.removeCompany(company.id);
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
