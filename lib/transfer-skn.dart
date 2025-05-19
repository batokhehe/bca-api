import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_project/const.dart';

Future transferSkn(
  String timestamp,
  String xSignature,
  String accessToken,
  dynamic params,
) async {
  // External API URL
  final url = Uri.parse(
    API_TRANSFER_SKN,
  );

  final requestHeader = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
    'X-TIMESTAMP': timestamp,
    'X-SIGNATURE': xSignature,
    'CHANNEL-ID': CHANNEL_ID,
    'X-PARTNER-ID': PARTNER_ID,
    'X-EXTERNAL-ID': params['partnerReferenceNo'].toString(),
  };

  final requestBody = jsonEncode(params);

  // Send POST request
  final response =
      await http.post(url, headers: requestHeader, body: requestBody);

  return jsonDecode(response.body);
}
