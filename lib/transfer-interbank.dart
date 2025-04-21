import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:http/http.dart' as http;
import 'package:my_project/const.dart';

Future<String> transferInterbank(String timestamp, String xSignature,
    String accessToken, String params,) async {
  // External API URL
  final url = Uri.parse(
    API_TRANSFER_INTERBANK,
  );

  final jsonRequestBody = jsonDecode(params);

  final requestHeader = {
    'Content-Type': 'application/json',
    'Authorization': accessToken,
    'X-TIMESTAMP': timestamp,
    'X-SIGNATURE': xSignature,
    'CHANNEL-ID': CHANNEL_ID,
    'X-PARTNER-ID': PARTNER_ID,
    'X-EXTERNAL-ID': jsonRequestBody['partnerReferenceNo'].toString(),
  };

  final requestBody = jsonEncode(jsonRequestBody);

  // Send POST request
  final response =
      await http.post(url, headers: requestHeader, body: requestBody);

  return response.body;
}
