class User {
  final String nif;
  final String email;
  final String? name;

  User({
    required this.nif,
    required this.email,
    this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nif: json['nif'],
      email: json['email'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nif': nif,
      'email': email,
      'name': name,
    };
  }
}
