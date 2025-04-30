

import 'package:url_launcher/url_launcher.dart';

Future<void> openWhatsAppChat(String phone) async {
  final String phoneNumber = phone; // تأكد أن phone موجود في Provider
  final Uri whatsappUrl = Uri.parse('https://wa.me/$phoneNumber');

  print(phoneNumber);
  if (await canLaunchUrl(whatsappUrl)) {
    await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
  } else {
    await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    throw Exception('Could not open WhatsApp chat');
  }
}