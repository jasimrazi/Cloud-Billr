class InvoiceModel {
  final String id;
  final String invoiceNumber;
  final String clientName;
  final String status;
  final String amount;
  final String date;

  InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.clientName,
    required this.status,
    required this.amount,
    required this.date,
  });

  InvoiceModel copyWith({
    String? id,
    String? invoiceNumber,
    String? clientName,
    String? status,
    String? amount,
    String? date,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      clientName: clientName ?? this.clientName,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoice_number': invoiceNumber,
      'client_name': clientName,
      'status': status,
      'amount': amount,
      'date': date,
    };
  }

  factory InvoiceModel.fromMap(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] ?? '',
      invoiceNumber: json['invoice_number'] ?? '',
      clientName: json['client_name'] ?? '',
      status: json['status'] ?? '',
      amount: json['amount'] ?? '',
      date: json['date'] ?? '',
    );
  }
}