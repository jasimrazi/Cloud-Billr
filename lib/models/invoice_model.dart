class InvoiceModel {
  String invoiceNumber;
  String clientName;
  String status;
  String amount;
  String date;

  InvoiceModel({
    required this.invoiceNumber,
    required this.clientName,
    required this.status,
    required this.amount,
    required this.date
  });

  factory InvoiceModel.fromMap(Map<String,dynamic> json){
    return InvoiceModel(
      invoiceNumber: json['invoice_number'], 
      clientName: json['client_name'], 
      status: json['status'], 
      amount: json['amount'], 
      date: json['date']
    );
  }
}