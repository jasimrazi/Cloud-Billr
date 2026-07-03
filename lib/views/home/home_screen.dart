
import 'package:cloud_billr/controllers/invoice_config_provider.dart';
import 'package:cloud_billr/controllers/invoice_provider.dart';
import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/create_invoice/create_invoice_screen.dart';
import 'package:cloud_billr/views/home/widgets/icon_widget.dart';
import 'package:cloud_billr/views/home/widgets/invoice_card.dart';
import 'package:cloud_billr/views/notifications/notifications_screen.dart';
import 'package:cloud_billr/views/past_invoices/past_invoices_screen.dart';
import 'package:cloud_billr/views/profile/profile_screen.dart';
import 'package:cloud_billr/views/settings/settings_screen.dart';
import 'package:cloud_billr/views/templates/templates_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final invoices = Provider.of<InvoiceProvider>(context).invoices;

    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: appColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 60,
        leading: Center(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: appColors.secondaryColor,
              child: Icon(Icons.person, color: appColors.textColor),
            ),
          ),
        ),
        title: const Text(
          'Invoices',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
            icon: SvgPicture.asset(
              'assets/icons/notification.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                appColors.textColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.paddingSmall),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.mainPadding,
            vertical: AppSpacing.paddingSmall,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.spacingL),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: appColors.shadowColor,
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                      blurStyle: BlurStyle.outer,
                    )
                  ],
                  borderRadius: AppRadius.medium,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.paddingSmall,
                  vertical: AppSpacing.paddingMedium,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CreateInvoiceScreen()),
                      ),
                      child: IconWidget(
                        icon: const Icon(Icons.add),
                        label: 'New Invoice',
                        color: appColors.primaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PastInvoicesScreen()),
                      ),
                      child: IconWidget(
                        icon: const Icon(Icons.description_outlined),
                        label: 'View All',
                        color: appColors.successGreenColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TemplatesScreen()),
                      ),
                      child: IconWidget(
                        icon: const Icon(Icons.grid_view_outlined),
                        label: 'Templates',
                        color: appColors.violetColor,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.spacingL),
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingMedium),
                decoration: BoxDecoration(
                  color: appColors.secondaryColor,
                  borderRadius: AppRadius.medium,
                ),
                child: Row(
                  children: [
                    Icon(Icons.cloud_done_outlined, color: appColors.successGreenColor),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        'Last backup: Today at 6:00 PM',
                        style: TextStyle(color: appColors.textSecondaryColor),
                      ),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: appColors.successGreenColor,
                        shape: BoxShape.circle,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.spacingL),
              Text(
                'Recent Invoices',
                style: TextStyle(
                  color: appColors.textColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: AppSpacing.spacingM),
              ListView.builder(
                itemCount: invoices.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InvoiceCard(
                    invoice: invoices[index],
                  );
                },
              ),
              SizedBox(height: AppSpacing.spacingS),
              Consumer2<InvoiceProvider, InvoiceConfigProvider>(
                builder: (context, invoiceProvider, configProvider, _) {
                  final symbol = configProvider.config.currencySymbol;
                  final revenue = invoiceProvider.totalRevenue;
                  final pending = invoiceProvider.pendingAmount;
                  return Container(
                    padding: const EdgeInsets.all(AppSpacing.paddingMedium),
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.medium,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                          color: appColors.shadowColor,
                          blurStyle: BlurStyle.outer,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "This Month's Revenue",
                              style: TextStyle(
                                color: appColors.textSecondaryColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '$symbol${revenue.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: appColors.textColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pending Invoices',
                              style: TextStyle(
                                color: appColors.textSecondaryColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '$symbol${pending.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: appColors.textColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: AppSpacing.spacingL),
              Divider(
                color: appColors.borderColor,
                thickness: 2,
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/settings.svg',
                        colorFilter: ColorFilter.mode(appColors.textSecondaryColor, BlendMode.srcIn),
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: AppSpacing.spacingS),
                      Expanded(
                        child: Text(
                          'Settings',
                          style: TextStyle(
                            color: appColors.textColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right, color: appColors.textSecondaryColor)
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.spacingM),
            ],
          ),
        ),
      ),
    );
  }
}