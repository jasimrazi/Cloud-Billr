import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/settings/widgets/settings_tile.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _cloudBackupEnabled = true;
  bool _darkModeEnabled = false;
  bool _notificationsEnabled = true;

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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.mainPadding,
            vertical: AppSpacing.paddingSmall,
          ),
          physics: const BouncingScrollPhysics(),
          children: [
            // Account Section
            _buildSectionHeader('Account'),
            Container(
              padding: const EdgeInsets.all(AppSpacing.paddingSmall),
              decoration: BoxDecoration(
                color: appColors.surfaceColor,
                borderRadius: AppRadius.medium,
                border: Border.all(color: appColors.borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: appColors.backgroundColor,
                      borderRadius: AppRadius.medium,
                      border: Border.all(color: appColors.borderColor),
                    ),
                    child: Icon(
                      Icons.business,
                      color: appColors.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacingM),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.paddingMedium,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: appColors.backgroundColor,
                        borderRadius: AppRadius.medium,
                        border: Border.all(color: appColors.borderColor),
                      ),
                      child: Text(
                        'Company Logo',
                        style: TextStyle(
                          color: appColors.textSecondaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacingM),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Update Logo',
                      style: TextStyle(
                        color: appColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacingL),

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
            const SizedBox(height: AppSpacing.spacingL),

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
            const SizedBox(height: AppSpacing.spacingL),

            // App Preferences Section
            _buildSectionHeader('App Preferences'),
            SettingsTile(
              leadingIcon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              trailing: Switch.adaptive(
                value: _darkModeEnabled,
                activeTrackColor: appColors.primaryColor.withValues(alpha: 0.5),
                activeThumbColor: appColors.primaryColor,
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
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
            const SizedBox(height: AppSpacing.spacingL),

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
            const SizedBox(height: AppSpacing.spacingXL),
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
