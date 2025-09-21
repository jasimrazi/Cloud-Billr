
import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/models/invoice_model.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/home/widgets/icon_widget.dart';
import 'package:cloud_billr/views/home/widgets/invoice_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<InvoiceModel> invoices = [
    {'invoice_number': 'INV-2024-001', 'client_name': 'Tech Solutions Inc', 'status': 'Paid', 'amount': '\$2,500.00', 'date': 'Jan 15, 2025'},
    {'invoice_number': 'INV-2024-002', 'client_name': 'Design Studio Co', 'status': 'Pending', 'amount': '\$1,800.00', 'date': 'Jan 14, 2024'},
    {'invoice_number': 'INV-2024-003', 'client_name': 'Marketing Pro Ltd', 'status': 'Paid', 'amount': '\$3,200.00', 'date': 'Jan 13, 2024'}
  ].map((e) => InvoiceModel.fromMap(e)).toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.mainPadding),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
            surfaceTintColor: Colors.transparent,
            leading: CircleAvatar(
              backgroundColor: appColors.secondaryColor,
              child: Icon(Icons.person, color: appColors.textColor,),
            ),
            title: Text('Invoices'),
            actions: [
              // IconButton(onPressed: (){}, icon: Icon(Icons.notifications_none))
              SvgPicture.asset(
                'assets/icons/notification.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  appColors.textColor, // Optional: change SVG color
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.spacingL,),
                Container(
                  decoration: BoxDecoration(
                    // border: BoxBorder.fromLTRB(
                    //   bottom: BorderSide(color: appColors.borderColor, width: 2),
                    //   right: BorderSide(color: appColors.borderColor, width: 1),
                    //   left: BorderSide(color: appColors.borderColor, width: 1),
                    // ),
                    boxShadow: [
                      BoxShadow(
                        color: appColors.shadowColor,
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        blurStyle: BlurStyle.outer
                    
                      )
                    ],
                    borderRadius: AppRadius.medium,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingSmall, vertical: AppSpacing.paddingMedium),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconWidget(
                        icon: Icon(Icons.add), 
                        label: 'New Invoice',
                        color: appColors.primaryColor
                      ),
                      IconWidget(
                        icon: Icon(Icons.description_outlined), 
                        label: 'View All',
                        color: appColors.successGreenColor
                      ),
                      IconWidget(
                        icon: Icon(Icons.grid_view_outlined), 
                        label: 'Templates',
                        color: appColors.violetColor
                      )
                    ],
                  ),
                ),
                    
                SizedBox(height: AppSpacing.spacingL,),
                Container(
                  padding: EdgeInsets.all(AppSpacing.paddingMedium),
                  decoration: BoxDecoration(
                    color: appColors.secondaryColor,
                    borderRadius: AppRadius.medium,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.cloud_done_outlined, color: appColors.successGreenColor),
                      SizedBox(width: 20,),
                      Expanded(
                        child: Text('Last backup: Today at 6:00 PM', style: TextStyle(
                          color: appColors.textSecondaryColor
                        ),),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: appColors.successGreenColor,
                          shape: BoxShape.circle
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.spacingL,),
                Text('Recent Invoices', style: TextStyle(
                  color: appColors.textColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),),
                SizedBox(height: AppSpacing.spacingM,),
                ListView.builder(
                  itemCount: invoices.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InvoiceCard(
                      invoice: invoices[index],
                    );
                  },
                ),
                SizedBox(height: AppSpacing.spacingS,),
                Container(
                  padding: EdgeInsets.all(AppSpacing.paddingMedium),
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.medium,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        color: appColors.shadowColor,
                        blurStyle: BlurStyle.outer
                      )
                    ]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('This Month\'s Revenue', style: TextStyle(
                            color: appColors.textSecondaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 14
                          ),),
                            
                          Text('\$12,500.00',style: TextStyle(
                            color: appColors.textColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 20
                          ),),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pending Invoices', style: TextStyle(
                            color: appColors.textSecondaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 14
                          ),),
                            
                          Text('\$3,200.00',style: TextStyle(
                            color: appColors.textColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 20
                          ),),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.spacingL,),
                Divider(
                  color: appColors.borderColor,
                  thickness: 2,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/settings.svg',
                      colorFilter: ColorFilter.mode(appColors.textSecondaryColor, BlendMode.srcIn),
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: AppSpacing.spacingS,),
                    Expanded(
                      child: Text('Settings', style: TextStyle(
                        color: appColors.textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 16
                      ),),
                    ),
                    IconButton(
                      onPressed: (){}, 
                      icon: Icon(Icons.keyboard_arrow_right, color: appColors.textSecondaryColor,))
                  ],
                ),
                SizedBox(height: AppSpacing.spacingM,),
                    
              ],
            ),
          ),
        ),
      ),
    );
  }
}