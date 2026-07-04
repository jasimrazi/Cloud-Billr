import 'package:cloud_billr/models/invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfHelper {
  static Future<void> exportPdf({
    required BuildContext context,
    required InvoiceModel invoice,
    String? companyName,
    String? companyAddress,
    String? companyContact,
    String? clientAddress,
    String? clientEmail,
    String? currencySymbol,
  }) async {
    final pdf = await generateInvoicePdf(
      invoice: invoice,
      companyName: companyName ?? 'My Company',
      companyAddress: companyAddress ?? '',
      companyContact: companyContact ?? '',
      clientAddress: clientAddress ?? '',
      clientEmail: clientEmail ?? '',
      currencySymbol: currencySymbol ?? '\$',
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Invoice_${invoice.invoiceNumber}.pdf',
    );
  }

  static Future<pw.Document> generateInvoicePdf({
    required InvoiceModel invoice,
    required String companyName,
    required String companyAddress,
    required String companyContact,
    required String clientAddress,
    required String clientEmail,
    required String currencySymbol,
  }) async {
    final pdf = pw.Document();

    // Fetch items or use fallback if empty
    final items = invoice.items.isNotEmpty
        ? invoice.items
        : [
            InvoiceItemModel(
              id: 'fallback',
              name: 'Services Rendered',
              quantity: 1,
              rate: invoice.totalAmount,
              tax: 0.0,
            )
          ];

    final templateIndex = invoice.templateIndex;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          switch (templateIndex) {
            case 1: // Minimalist Clean
              return _buildMinimalistLayout(invoice, items, companyName, companyAddress, companyContact, clientAddress, clientEmail, currencySymbol);
            case 2: // Creative Studio
              return _buildCreativeLayout(invoice, items, companyName, companyAddress, companyContact, clientAddress, clientEmail, currencySymbol);
            case 3: // Bold Corporate
              return _buildBoldCorporateLayout(invoice, items, companyName, companyAddress, companyContact, clientAddress, clientEmail, currencySymbol);
            case 0: // Classic Professional
            default:
              return _buildClassicLayout(invoice, items, companyName, companyAddress, companyContact, clientAddress, clientEmail, currencySymbol);
          }
        },
      ),
    );

    return pdf;
  }

  // --- TEMPLATE 0: CLASSIC PROFESSIONAL ---
  static List<pw.Widget> _buildClassicLayout(
    InvoiceModel invoice,
    List<InvoiceItemModel> items,
    String companyName,
    String companyAddress,
    String companyContact,
    String clientAddress,
    String clientEmail,
    String currencySymbol,
  ) {
    return [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(companyName, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              if (companyAddress.isNotEmpty) pw.Text(companyAddress, style: const pw.TextStyle(fontSize: 10)),
              if (companyContact.isNotEmpty) pw.Text(companyContact, style: const pw.TextStyle(fontSize: 10)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('INVOICE', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
              pw.Text('Invoice #: ${invoice.invoiceNumber}', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
              pw.Text('Date: ${invoice.date}', style: const pw.TextStyle(fontSize: 10)),
              pw.Text('Status: ${invoice.status}', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ],
      ),
      pw.SizedBox(height: 16),
      pw.Divider(thickness: 2, color: PdfColors.grey400),
      pw.SizedBox(height: 16),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('BILL TO:', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
              pw.SizedBox(height: 4),
              pw.Text(invoice.clientName, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              if (clientAddress.isNotEmpty) pw.Text(clientAddress, style: const pw.TextStyle(fontSize: 10)),
              if (clientEmail.isNotEmpty) pw.Text(clientEmail, style: const pw.TextStyle(fontSize: 10)),
            ],
          ),
        ],
      ),
      pw.SizedBox(height: 24),
      _buildTable(items, currencySymbol, useAlternatingRows: false, useHeaderBackground: false),
      pw.SizedBox(height: 24),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Container(
            width: 200,
            child: pw.Column(
              children: [
                pw.Divider(thickness: 1, color: PdfColors.grey300),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Amount Due:', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.Text('$currencySymbol${invoice.totalAmount.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Divider(thickness: 2, color: PdfColors.grey700),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  // --- TEMPLATE 1: MINIMALIST CLEAN ---
  static List<pw.Widget> _buildMinimalistLayout(
    InvoiceModel invoice,
    List<InvoiceItemModel> items,
    String companyName,
    String companyAddress,
    String companyContact,
    String clientAddress,
    String clientEmail,
    String currencySymbol,
  ) {
    return [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text('INVOICE', style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.normal, letterSpacing: 2)),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(invoice.invoiceNumber, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.Text(invoice.date, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
            ],
          ),
        ],
      ),
      pw.SizedBox(height: 24),
      pw.Divider(thickness: 0.5, color: PdfColors.grey300),
      pw.SizedBox(height: 24),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('From', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey500, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 4),
              pw.Text(companyName, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
              if (companyAddress.isNotEmpty) pw.Text(companyAddress, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
              if (companyContact.isNotEmpty) pw.Text(companyContact, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('To', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey500, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 4),
              pw.Text(invoice.clientName, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
              if (clientAddress.isNotEmpty) pw.Text(clientAddress, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
              if (clientEmail.isNotEmpty) pw.Text(clientEmail, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
            ],
          ),
        ],
      ),
      pw.SizedBox(height: 32),
      _buildTable(items, currencySymbol, useAlternatingRows: false, useHeaderBackground: false, minimalist: true),
      pw.SizedBox(height: 32),
      pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text('Total Amount', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
            pw.SizedBox(height: 4),
            pw.Text('$currencySymbol${invoice.totalAmount.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ),
    ];
  }

  // --- TEMPLATE 2: CREATIVE STUDIO ---
  static List<pw.Widget> _buildCreativeLayout(
    InvoiceModel invoice,
    List<InvoiceItemModel> items,
    String companyName,
    String companyAddress,
    String companyContact,
    String clientAddress,
    String clientEmail,
    String currencySymbol,
  ) {
    return [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Left side: Billing Details & Metadata
          pw.Expanded(
            flex: 2,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('CREATIVE STUDIO INVOICE', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, letterSpacing: 1, color: PdfColors.grey600)),
                pw.SizedBox(height: 16),
                pw.Text('From:', style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500, fontWeight: pw.FontWeight.bold)),
                pw.Text(companyName, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                if (companyAddress.isNotEmpty) pw.Text(companyAddress, style: const pw.TextStyle(fontSize: 9)),
                if (companyContact.isNotEmpty) pw.Text(companyContact, style: const pw.TextStyle(fontSize: 9)),
                pw.SizedBox(height: 16),
                pw.Text('Bill To:', style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500, fontWeight: pw.FontWeight.bold)),
                pw.Text(invoice.clientName, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                if (clientAddress.isNotEmpty) pw.Text(clientAddress, style: const pw.TextStyle(fontSize: 9)),
                if (clientEmail.isNotEmpty) pw.Text(clientEmail, style: const pw.TextStyle(fontSize: 9)),
              ],
            ),
          ),
          // Right side: Quick stats
          pw.Expanded(
            flex: 1,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(invoice.invoiceNumber, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text('Issued: ${invoice.date}', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                pw.Text('Status: ${invoice.status.toUpperCase()}', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 24),
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey100,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Total Due', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500)),
                      pw.Text('$currencySymbol${invoice.totalAmount.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      pw.SizedBox(height: 32),
      _buildTable(items, currencySymbol, useAlternatingRows: true, useHeaderBackground: false),
    ];
  }

  // --- TEMPLATE 3: BOLD CORPORATE ---
  static List<pw.Widget> _buildBoldCorporateLayout(
    InvoiceModel invoice,
    List<InvoiceItemModel> items,
    String companyName,
    String companyAddress,
    String companyContact,
    String clientAddress,
    String clientEmail,
    String currencySymbol,
  ) {
    return [
      // Solid Dark Header block
      pw.Container(
        color: PdfColors.black,
        padding: const pw.EdgeInsets.all(16),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(companyName.toUpperCase(), style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                if (companyAddress.isNotEmpty) pw.Text(companyAddress, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey300)),
                if (companyContact.isNotEmpty) pw.Text(companyContact, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey300)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('INVOICE', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                pw.Text(invoice.invoiceNumber, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey300)),
              ],
            ),
          ],
        ),
      ),
      pw.SizedBox(height: 24),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('CLIENT DETAILS', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
              pw.SizedBox(height: 4),
              pw.Text(invoice.clientName, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
              if (clientAddress.isNotEmpty) pw.Text(clientAddress, style: const pw.TextStyle(fontSize: 9)),
              if (clientEmail.isNotEmpty) pw.Text(clientEmail, style: const pw.TextStyle(fontSize: 9)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('DATE OF ISSUE: ${invoice.date}', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
              pw.Text('STATUS: ${invoice.status.toUpperCase()}', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ],
      ),
      pw.SizedBox(height: 24),
      _buildTable(items, currencySymbol, useAlternatingRows: false, useHeaderBackground: true),
      pw.SizedBox(height: 24),
      pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Container(
          width: 250,
          color: PdfColors.grey100,
          padding: const pw.EdgeInsets.all(12),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('GRAND TOTAL:', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.Text('$currencySymbol${invoice.totalAmount.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ),
      ),
    ];
  }

  // --- SHARED TABLE BUILDER ---
  static pw.Widget _buildTable(
    List<InvoiceItemModel> items,
    String currencySymbol, {
    required bool useAlternatingRows,
    required bool useHeaderBackground,
    bool minimalist = false,
  }) {
    final headers = ['Description', 'Qty', 'Rate', 'Total'];

    final tableRows = <pw.TableRow>[
      pw.TableRow(
        decoration: useHeaderBackground
            ? const pw.BoxDecoration(color: PdfColors.black)
            : minimalist
                ? const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 1, color: PdfColors.grey400)))
                : const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 2, color: PdfColors.grey800))),
        children: headers.map((header) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text(
              header,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
                color: useHeaderBackground ? PdfColors.white : PdfColors.black,
              ),
              textAlign: header == 'Description' ? pw.TextAlign.left : pw.TextAlign.right,
            ),
          );
        }).toList(),
      ),
    ];

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final isEven = i % 2 == 0;
      final rowBgColor = useAlternatingRows && !isEven ? PdfColors.grey100 : null;

      tableRows.add(
        pw.TableRow(
          decoration: pw.BoxDecoration(
            color: rowBgColor,
            border: minimalist
                ? const pw.Border(bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey200))
                : const pw.Border(bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey300)),
          ),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(item.name, style: const pw.TextStyle(fontSize: 10)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(item.quantity.toString(), style: const pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.right),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('$currencySymbol${item.rate.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.right),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('$currencySymbol${item.lineTotal.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right),
            ),
          ],
        ),
      );
    }

    return pw.Table(
      columnWidths: const {
        0: pw.FlexColumnWidth(3),
        1: pw.FlexColumnWidth(1),
        2: pw.FlexColumnWidth(1.2),
        3: pw.FlexColumnWidth(1.5),
      },
      children: tableRows,
    );
  }
}
