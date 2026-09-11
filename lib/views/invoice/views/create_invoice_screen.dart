import 'package:cloud_billr/helpers/responsive.dart';
import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/invoice/widgets/company_input_card.dart';
import 'package:cloud_billr/views/invoice/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {

  TextEditingController companyController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  @override
  void dispose(){
    companyController.dispose();
    contactController.dispose();
    addressController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.mainPadding),
        child: SafeArea(child: Scaffold(
          appBar: CustomAppBar(
            svgPath: 'assets/icons/back_arrow.svg',
            title: 'Create Invoice',
            action: 'PREVIEW',
          ),
          body: Column(
            spacing: Responsive.height(24),
            children: [
              Container(
                alignment: Alignment.center,
                height: Responsive.height(120),
                width: Responsive.width(120),
                decoration: BoxDecoration(
                  color: appColors.cardBackgroundColor,
                  borderRadius: BorderRadius.circular(AppRadius.medium)
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/camera.svg",
                      height: Responsive.height(32),
                      width: Responsive.width(32),
                    ),
                    SizedBox(height: Responsive.height(18),),
                    Text('Add Logo', style: TextStyle(
                      color: appColors.cardTextColor,
                      fontSize: AppFontsSizes.fontSizeM,
                      fontWeight: FontWeight.w400
                    ),)
                  ],
                ),
              ),
              CompanyInputCard(
                companyController: companyController,
                contactController: contactController,
                addressController: addressController,
              )
              
            ],
          ),
        ),),
      ),
    );
  }
}