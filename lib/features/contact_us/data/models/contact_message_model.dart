class ContactMessageModel {
  final String senderName;
  final String senderEmail;
  final String senderPhone;
  final bool isTrader;
  final String subject;
  final String message;

  ContactMessageModel({
    required this.senderName,
    required this.senderEmail,
    required this.senderPhone,
    required this.isTrader,
    required this.subject,
    required this.message,
  });

  // Factory constructor for creating instance from JSON
  factory ContactMessageModel.fromJson(Map<String, dynamic> json) {
    return ContactMessageModel(
      senderName: json['senderName'] ?? '',
      senderEmail: json['senderEmail'] ?? '',
      senderPhone: json['senderPhone'] ?? '',
      isTrader: json['isTrader'] ?? false,
      subject: json['subject'] ?? '',
      message: json['message'] ?? '',
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'senderName': senderName,
      'senderEmail': senderEmail,
      'senderPhone': senderPhone,
      'isTrader': isTrader,
      'subject': subject,
      'message': message,
    };
  }

  // CopyWith method for creating updated copies
  ContactMessageModel copyWith({
    String? senderName,
    String? senderEmail,
    String? senderPhone,
    bool? isTrader,
    String? subject,
    String? message,
  }) {
    return ContactMessageModel(
      senderName: senderName ?? this.senderName,
      senderEmail: senderEmail ?? this.senderEmail,
      senderPhone: senderPhone ?? this.senderPhone,
      isTrader: isTrader ?? this.isTrader,
      subject: subject ?? this.subject,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'ContactMessageModel(senderName: $senderName, senderEmail: $senderEmail, senderPhone: $senderPhone, isTrader: $isTrader, subject: $subject, message: $message)';
  }

  // Validation method
  bool isValid() {
    return senderName.isNotEmpty &&
        senderEmail.isNotEmpty &&
        _isValidEmail(senderEmail) &&
        senderPhone.isNotEmpty &&
        subject.isNotEmpty &&
        message.isNotEmpty;
  }

  // Email validation helper
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
