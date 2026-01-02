import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlFunc(String url) async {
  String link = url;
  if (!url.contains('https://')) {
    link = 'https://$url';
  }
  final Uri uri = Uri.parse(link);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $link';
  }
}
