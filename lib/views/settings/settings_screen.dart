import 'package:cloud_billr/controllers/company_provider.dart';
import 'package:cloud_billr/controllers/theme_provider.dart';
import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/models/company_model.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/settings/add_edit_company_screen.dart';
import 'package:cloud_billr/views/settings/customer_list_screen.dart';
import 'package:cloud_billr/views/settings/invoice_config_screen.dart';
import 'package:cloud_billr/views/settings/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _cloudBackupEnabled = true;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

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
          'Settings',
          style: TextStyle(
            color: appColors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.mainPadding,
            vertical: AppSpacing.paddingSmall,
          ),
          physics: const BouncingScrollPhysics(),
          children: [
            SettingsTile(
              leadingIcon: Icons.business,
              title: 'My Company Profile',
              subtitle: 'Edit your business name, address, and logo',
              trailing: _buildTrailingTextWithChevron(''),
              onTap: () async {
                final companyProvider = Provider.of<CompanyProvider>(context, listen: false);
                final primaryCompany = companyProvider.companies.isNotEmpty
                    ? companyProvider.companies.first
                    : null;

                final result = await Navigator.push<CompanyModel>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditCompanyScreen(company: primaryCompany),
                  ),
                );

                if (result != null && context.mounted) {
                  if (primaryCompany != null) {
                    await companyProvider.updateCompany(result);
                  } else {
                    await companyProvider.addCompany(result);
                  }
                }
              },
            ),
            _buildDivider(),
            SettingsTile(
              leadingIcon: Icons.people_outline,
              title: 'Manage Customers',
              subtitle: 'Add or edit customer profiles',
              trailing: _buildTrailingTextWithChevron(''),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CustomerListScreen()),
                );
              },
            ),
            _buildDivider(),
            SettingsTile(
              leadingIcon: Icons.receipt_long_outlined,
              title: 'Manage Invoice',
              subtitle: 'Configure columns, tax, numbering & totals',
              trailing: _buildTrailingTextWithChevron(''),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const InvoiceConfigScreen()),
                );
              },
            ),
            _buildDivider(),
            SizedBox(height: AppSpacing.spacingL),

            // Invoice Defaults Section
            _buildSectionHeader('Invoice Defaults'),
            SettingsTile(
              title: 'Currency',
              trailing: _buildTrailingTextWithChevron('USD - US Dollar'),
              onTap: () {},
            ),
            _buildDivider(),
            SettingsTile(
              title: 'Default Tax Rate',
              trailing: _buildTrailingTextWithChevron('18%'),
              onTap: () {},
            ),
            SizedBox(height: AppSpacing.spacingL),

            // Backup & Sync Section
            _buildSectionHeader('Backup & Sync'),
            SettingsTile(
              title: 'Cloud Backup',
              trailing: Switch.adaptive(
                value: _cloudBackupEnabled,
                activeTrackColor: appColors.primaryColor.withValues(alpha: 0.5),
                activeThumbColor: appColors.primaryColor,
                onChanged: (value) {
                  setState(() {
                    _cloudBackupEnabled = value;
                  });
                },
              ),
            ),
            _buildDivider(),
            SettingsTile(
              title: 'Backup Schedule',
              subtitle: 'Last backup: Today, 14:30',
              trailing: _buildTrailingTextWithChevron('Daily'),
              onTap: () {},
            ),
            SizedBox(height: AppSpacing.spacingL),

            // App Preferences Section
            _buildSectionHeader('App Preferences'),
            SettingsTile(
              leadingIcon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              trailing: Switch.adaptive(
                value: isDark,
                activeTrackColor: appColors.primaryColor.withValues(alpha: 0.5),
                activeThumbColor: appColors.primaryColor,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              ),
            ),
            _buildDivider(),
            SettingsTile(
              leadingIcon: Icons.notifications_none_outlined,
              title: 'Notifications',
              trailing: Switch.adaptive(
                value: _notificationsEnabled,
                activeTrackColor: appColors.primaryColor.withValues(alpha: 0.5),
                activeThumbColor: appColors.primaryColor,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ),
            _buildDivider(),
            SettingsTile(
              leadingIcon: Icons.translate,
              title: 'Language',
              trailing: _buildTrailingTextWithChevron('English'),
              onTap: () {},
            ),
            SizedBox(height: AppSpacing.spacingL),

            // Data Management Section
            _buildSectionHeader('Data Management'),
            SettingsTile(
              leadingIcon: Icons.file_download_outlined,
              iconColor: appColors.primaryColor,
              title: 'Export All Invoices',
              onTap: () {},
            ),
            _buildDivider(),
            SettingsTile(
              leadingIcon: Icons.cloud_upload_outlined,
              iconColor: appColors.primaryColor,
              title: 'Restore from Backup',
              onTap: () {},
            ),
            _buildDivider(),
            SettingsTile(
              leadingIcon: Icons.delete_outline,
              textColor: appColors.redColor,
              iconColor: appColors.redColor,
              title: 'Clear All Data',
              onTap: () {},
            ),
            SizedBox(height: AppSpacing.spacingXL),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          color: appColors.textSecondaryColor,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: appColors.borderColor,
      height: 1,
      thickness: 1,
    );
  }

  Widget _buildTrailingTextWithChevron(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: TextStyle(
            color: appColors.textSecondaryColor,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.chevron_right,
          color: appColors.textSecondaryColor,
          size: 20,
        ),
      ],
    );
  }
}
