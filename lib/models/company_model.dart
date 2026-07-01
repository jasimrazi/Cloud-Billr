class CompanyModel {
  final String id;
  final String name;
  final String address;
  final String contactDetails;

  CompanyModel({
    required this.id,
    required this.name,
    required this.address,
    required this.contactDetails,
  });

  CompanyModel copyWith({
    String? id,
    String? name,
    String? address,
    String? contactDetails,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      contactDetails: contactDetails ?? this.contactDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'contactDetails': contactDetails,
    };
  }

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      contactDetails: map['contactDetails'] ?? '',
    );
  }
}
