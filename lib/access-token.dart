import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:http/http.dart' as http;
import 'package:my_project/const.dart';

Future<String> accessToken(String timestamp, String xSignature) async {
  // External API URL
  final url = Uri.parse(
    API_ACCESS_TOKEN,
  );

  final requestHeader = {
    'Content-Type': 'application/json',
    'X-TIMESTAMP': timestamp,
    'X-CLIENT-KEY': CLIENT_ID,
    'X-SIGNATURE': xSignature,
  };

  final requestBody = jsonEncode({
    'grantType': 'client_credentials',
  });

  // Send POST request
  final response =
      await http.post(url, headers: requestHeader, body: requestBody);

  return response.body;
}
