import 'package:url_launcher/url_launcher.dart';

Future<void> launchEmail(String email) async {
  // Ensure email is not empty
  if (email.isEmpty) {
    throw 'Email cannot be null or empty';
  }

  // Create a mailto Uri
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: email,
    queryParameters: {'subject': 'EduHub'},
  );

  // Check if the email URI can be launched
  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    throw 'Could not launch email client';
  }
}
