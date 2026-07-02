class CustomerModel {
  final String id;
  final String name;
  final String email;
  final String address;
  final String phone;

  CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
  });

  CustomerModel copyWith({
    String? id,
    String? name,
    String? email,
    String? address,
    String? phone,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'phone': phone,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
}
