import 'package:supercycle/core/services/contact_service.dart';
import 'package:supercycle/features/contact_us/data/models/contact_form_data.dart';

class MockContactService implements ContactService {
  @override
  Future<bool> submitContactForm(ContactFormData data) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate success/failure (you can add logic here)
    // For demo purposes, always return true
    return true;
  }
}

// For real API implementation:
/*
class ApiContactService implements ContactService {
  final http.Client client;
  final String baseUrl;

  ApiContactService({required this.client, required this.baseUrl});

  @override
  Future<bool> submitContactForm(ContactFormData data) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/contact'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}*/
