import 'package:cloud_billr/utils/theme.dart';
import 'package:flutter/material.dart';

import 'input_widget.dart';
import 'normal_text_field.dart';
import 'phone_text_field.dart';

class CompanyInputCard extends StatelessWidget {
  final TextEditingController companyController;
  final TextEditingController contactController;
  final TextEditingController addressController;
  const CompanyInputCard({super.key,
  required this.companyController,
  required this.contactController,
  required this.addressController});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.spacingM,
      children: [
        InputWidget(
          label: 'Company Name', 
          textField: NormalTextField(
          controller: companyController, 
          hintText: 'Enter Company Name'
        )),

        InputWidget(
          label: 'Company Address', 
          textField: NormalTextField(
          controller: addressController, 
          hintText: 'Enter company address',
          lineCount: 3,
        )),

        InputWidget(
          label: 'Contact Details', 
          textField: PhoneTextField(
          controller: contactController, 
          hintText: 'Enter contact details',
        ))
      ],
    );
  }
}