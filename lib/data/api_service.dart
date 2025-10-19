// lib/data/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/user.dart';

class ApiService {
  static const String _baseUrl = 'https://randomuser.me/api/?results=20';

  Future<List<User>> fetchUsers() async {
    for (int attempt = 1; attempt <= 3; attempt++) {
      // Retry up to 3 times
      try {
        final response = await http
            .get(Uri.parse(_baseUrl))
            .timeout(const Duration(seconds: 15)); // Increased timeout
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
          return (jsonData['results'] as List)
              .map((json) => User.fromJson(json as Map<String, dynamic>))
              .toList(); // Inline parsing
        } else {
          throw Exception('Failed to load users: ${response.statusCode}');
        }
      } catch (e) {
        if (attempt == 3) rethrow; // Rethrow on last attempt
        await Future.delayed(
          Duration(seconds: attempt * 2),
        ); // Exponential backoff
      }
    }
    throw Exception('Failed to fetch users after 3 attempts');
  }
}
