class UserModel {
  final String id;
  final String name;
  final String title;
  final String email;
  final String phone;
  final String companyName;
  final String websiteLink;


  UserModel({
    required this.id,
    required this.name,
    required this.title,
    required this.email,
    required this.phone,
    required this.companyName,
    required this.websiteLink
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? title,
    String? email,
    String? phone,
    String? companyName,
    String? websiteLink,
  }){
    return UserModel(
      id: id?? this.id, 
      name: name ?? this.name,
      title: title ?? this.title, 
      email: email ?? this.email, 
      phone: phone ?? this.phone, 
      companyName: companyName ?? this.companyName, 
      websiteLink: websiteLink ?? this.websiteLink
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'title': title,
      'email': email,
      'phone': phone,
      'company_name': companyName,
      'website_link': websiteLink
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map){
    return UserModel(
      id: map['id'], 
      name: map['name'], 
      title: map['title'],
      email: map['email'], 
      phone: map['phone'], 
      companyName: map['company_name'], 
      websiteLink: map['website_link']
    );
  }
}