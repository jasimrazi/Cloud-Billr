class InvoiceModel {
  final String id;
  final String invoiceNumber;
  final String clientName;
  final String status;
  final String amount;
  final String date;
  final double totalAmount;

  InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.clientName,
    required this.status,
    required this.amount,
    required this.date,
    this.totalAmount = 0.0,
  });

  InvoiceModel copyWith({
    String? id,
    String? invoiceNumber,
    String? clientName,
    String? status,
    String? amount,
    String? date,
    double? totalAmount,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      clientName: clientName ?? this.clientName,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      totalAmount: totalAmount ?? this.totalAmount,
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
      'total_amount': totalAmount,
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
      totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
    );
  }
}