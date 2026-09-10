
import 'package:cloud_billr/models/invoice_model.dart';
import 'package:cloud_billr/utils/theme.dart';
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
      padding: EdgeInsets.all(AppSpacing.paddingMedium),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 60,
              surfaceTintColor: Colors.transparent,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CircleAvatar(
                  backgroundColor: AppColors.secondaryColorLight,
                  child: Icon(Icons.person, color: AppColors.lightTextColor,),
                ),
              ),
              title: Text('Invoices'),
              actions: [
                // IconButton(onPressed: (){}, icon: Icon(Icons.notifications_none))
                SvgPicture.asset(
                  'assets/icons/notification.svg',
                  width: 48,
                  height: 48,
                  colorFilter: const ColorFilter.mode(
                    Colors.blue, // Optional: change SVG color
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.spacingXL,),
                Container(
                  decoration: BoxDecoration(
                    border: BoxBorder.fromLTRB(
                      bottom: BorderSide(color: AppColors.borderColorLight, width: 2),
                      right: BorderSide(color: AppColors.borderColorLight, width: 1),
                      left: BorderSide(color: AppColors.borderColorLight, width: 1),
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingSmall, vertical: AppSpacing.paddingMedium),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildIconWidget(
                        icon: Icon(Icons.add), 
                        label: 'New Invoice',
                        color: AppColors.primaryColorLight
                      ),
                      _buildIconWidget(
                        icon: Icon(Icons.description_outlined), 
                        label: 'View All',
                        color: AppColors.successGreenLight
                      ),
                      _buildIconWidget(
                        icon: Icon(Icons.grid_view_outlined), 
                        label: 'Templates',
                        color: AppColors.violetLight
                      )
                    ],
                  ),
                ),
          
                SizedBox(height: AppSpacing.spacingM,),
                Container(
                  padding: EdgeInsets.fromLTRB(AppSpacing.paddingSmall, AppSpacing.paddingMedium, AppSpacing.paddingSmall, AppSpacing.paddingLarge),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColorLight,
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.cloud_done_outlined, color: AppColors.successGreenLight),
                      SizedBox(width: 20,),
                      Expanded(
                        child: Text('Last backup: Today at 6:00 PM', style: TextStyle(
                          color: AppColors.lightTextSecondaryColor
                        ),),
                      ),
                      // Spacer(),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.successGreenLight,
                          shape: BoxShape.circle
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.spacingM,),
                Text('Recent Invoices', style: TextStyle(
                  color: AppColors.lightTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),),SizedBox(height: AppSpacing.spacingM,),
                Expanded(
                  child: ListView.builder(
                    itemCount: invoices.length,
                    itemBuilder: (context, index) {
                      return _buildInvoiceCard(
                        invoiceNumber: invoices[index].invoiceNumber, 
                        clientName: invoices[index].clientName, 
                        amount: invoices[index].amount, 
                        status: invoices[index].status, 
                        date: invoices[index].date
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(AppSpacing.paddingMedium),
                  margin: EdgeInsets.all(AppSpacing.marginSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    border: BoxBorder.fromLTRB(
                      bottom: BorderSide(
                        color: AppColors.borderColorLight,
                        width: 2
                      ),
                      left: BorderSide(
                        color: AppColors.borderColorLight,
                        width: 1
                      ),
                      right: BorderSide(
                        color: AppColors.borderColorLight,
                        width: 1
                      )
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('This Month\'s Revenue', style: TextStyle(
                            color: AppColors.lightTextSecondaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 14
                          ),),
                            
                          Text('\$12,500.00',style: TextStyle(
                            color: AppColors.lightTextColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 20
                          ),),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pending Invoices', style: TextStyle(
                            color: AppColors.lightTextSecondaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 14
                          ),),
                            
                          Text('\$3,200.00',style: TextStyle(
                            color: AppColors.lightTextColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 20
                          ),),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.spacingM,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    border: BoxBorder.fromLTRB(
                      top: BorderSide(
                        color: AppColors.borderColorLight,
                        width: 2
                      ),
                    )
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.settings, color: AppColors.lightTextSecondaryColor,),
                      SizedBox(width: AppSpacing.spacingS,),
                      Text('Settings', style: TextStyle(
                        color: AppColors.lightTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 16
                      ),),
                      Spacer(),
                      IconButton(
                        onPressed: (){}, 
                        icon: Icon(Icons.keyboard_arrow_right, color: AppColors.lightTextSecondaryColor,))
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.spacingM,),
          
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconWidget({
    required Icon icon, 
    required String label,
    required Color color
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: AppColors.secondaryColorLight,
          child: Icon(icon.icon, color: color),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: AppColors.lightTextColor)),
      ],
    );
  }

  Widget _buildInvoiceCard({
    required String invoiceNumber,
    required String clientName,
    required String amount,
    required String status,
    required String date
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.paddingMedium),
      margin: EdgeInsets.all(AppSpacing.marginSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.borderColorLight)
      ),
      child: Column(
        spacing: AppSpacing.spacingS,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(invoiceNumber, style: TextStyle(
                    color: AppColors.lightTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14
                  ),),

                  Text(clientName,style: TextStyle(
                    color: AppColors.lightTextSecondaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14
                  ),),
                ],
              ),
              Spacer(),
              _buildStatusContainer(status: status)
            ],
          ),
          Row(
            children: [
              Text(amount, style: TextStyle(
                color: AppColors.lightTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500
              ),),
              Spacer(),
              Text(date, style: TextStyle(
                color: AppColors.lightTextSecondaryColor,
                fontWeight: FontWeight.w400,
                fontSize: 12

              ),)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatusContainer({
    required String status
  }){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingSmall),
      decoration: BoxDecoration(
        color: getStatusContainerColor(status: status.toLowerCase()),
        borderRadius: BorderRadius.circular(AppRadius.medium)
      ),child: Text(status, style: TextStyle(
        color: getStatusTextColor(status: status.toLowerCase())
      ),),
    );
  }

  Color getStatusContainerColor({
    required String status
  }){
    switch(status){
      case 'pending': 
        return AppColors.pendigYellowBgLight;
      case 'paid':
        return AppColors.successGreenBgLight;
      default :
        return Colors.white;
    }
  }

  Color getStatusTextColor({
    required String status
  }){
    switch(status){
      case 'pending': 
        return AppColors.pendingYellowTextLight;
      case 'paid':
        return AppColors.successGreenLight;
      default :
        return AppColors.lightTextColor;
    }
  }
}