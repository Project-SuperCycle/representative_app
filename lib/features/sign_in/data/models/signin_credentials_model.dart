class SigninCredentialsModel {
  final String? email;
  final String? phone;
  final String password;

  SigninCredentialsModel({this.email, this.phone, required this.password});

  // fromJson constructor
  factory SigninCredentialsModel.fromJson(Map<String, dynamic> json) {
    return SigninCredentialsModel(
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
  SigninCredentialsModel copyWith({
    String? email,
    String? phone,
    String? password,
  }) {
    return SigninCredentialsModel(
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }
}
