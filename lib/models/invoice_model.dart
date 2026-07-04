class InvoiceItemModel {
  final String id;
  final String name;
  final int quantity;
  final double rate;
  final double tax;

  InvoiceItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.rate,
    required this.tax,
  });

  double get lineTotal => quantity * rate;

  Map<String, dynamic> toMap(String invoiceId) {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'name': name,
      'quantity': quantity,
      'rate': rate,
      'tax': tax,
    };
  }

  factory InvoiceItemModel.fromMap(Map<String, dynamic> json) {
    return InvoiceItemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      rate: (json['rate'] ?? 0.0).toDouble(),
      tax: (json['tax'] ?? 0.0).toDouble(),
    );
  }
}

class InvoiceModel {
  final String id;
  final String invoiceNumber;
  final String clientName;
  final String status;
  final String amount;
  final String date;
  final double totalAmount;
  final int templateIndex;
  final List<InvoiceItemModel> items;

  InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.clientName,
    required this.status,
    required this.amount,
    required this.date,
    this.totalAmount = 0.0,
    this.templateIndex = 0,
    this.items = const [],
  });

  InvoiceModel copyWith({
    String? id,
    String? invoiceNumber,
    String? clientName,
    String? status,
    String? amount,
    String? date,
    double? totalAmount,
    int? templateIndex,
    List<InvoiceItemModel>? items,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      clientName: clientName ?? this.clientName,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      totalAmount: totalAmount ?? this.totalAmount,
      templateIndex: templateIndex ?? this.templateIndex,
      items: items ?? this.items,
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
      'template_index': templateIndex,
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
      templateIndex: json['template_index'] ?? 0,
      items: const [],
    );
  }
}