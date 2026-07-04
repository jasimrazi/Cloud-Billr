import 'package:cloud_billr/helpers/pdf_helper.dart';
import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/models/invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PdfPreviewScreen extends StatelessWidget {
  final InvoiceModel invoice;
  final String companyName;
  final String companyAddress;
  final String companyContact;
  final String clientAddress;
  final String clientEmail;
  final String currencySymbol;

  const PdfPreviewScreen({
    super.key,
    required this.invoice,
    required this.companyName,
    required this.companyAddress,
    required this.companyContact,
    required this.clientAddress,
    required this.clientEmail,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: appColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: appColors.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'PDF Preview',
          style: TextStyle(
            color: appColors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: PdfPreview(
        build: (format) async {
          final pdf = await PdfHelper.generateInvoicePdf(
            invoice: invoice,
            companyName: companyName,
            companyAddress: companyAddress,
            companyContact: companyContact,
            clientAddress: clientAddress,
            clientEmail: clientEmail,
            currencySymbol: currencySymbol,
          );
          return pdf.save();
        },
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        pdfPreviewPageDecoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
      ),
    );
  }
}
