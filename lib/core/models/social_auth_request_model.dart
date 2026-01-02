class SocialAuthRequestModel {
  final String provider;
  final String accessToken;

  const SocialAuthRequestModel({
    required this.provider,
    required this.accessToken,
  });

  factory SocialAuthRequestModel.fromJson(Map<String, dynamic> json) {
    return SocialAuthRequestModel(
      provider: json['provider'] as String,
      accessToken: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'provider': provider, 'accessToken': accessToken};
  }

  SocialAuthRequestModel copyWith({String? provider, String? token}) {
    return SocialAuthRequestModel(
      provider: provider ?? this.provider,
      accessToken: token ?? accessToken,
    );
  }

  @override
  String toString() {
    return 'SocialAuthRequestModel(provider: $provider, token: $accessToken)';
  }
}
