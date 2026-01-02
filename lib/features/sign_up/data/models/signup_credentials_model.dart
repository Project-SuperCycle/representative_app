class SignupCredentialsModel {
  final String? email;
  final String? phone;
  final String password;

  SignupCredentialsModel({this.email, this.phone, required this.password});

  // fromJson constructor
  factory SignupCredentialsModel.fromJson(Map<String, dynamic> json) {
    return SignupCredentialsModel(
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'password': password};

    if (email != null && email!.isNotEmpty) {
      data['email'] = email;
    }

    if (phone != null && phone!.isNotEmpty) {
      data['phone'] = phone;
    }

    return data;
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'SigninCredentials(email: $email, password: $password, phone: $phone)';
  }

  // Optional: copyWith method for creating modified copies
  SignupCredentialsModel copyWith({
    String? email,
    String? phone,
    String? password,
  }) {
    return SignupCredentialsModel(
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }
}
