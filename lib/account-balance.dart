import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_project/const.dart';

Future accountBalance(
  String timestamp,
  String xSignature,
  String accessToken,
  String params,
) async {
  // External API URL
  final url = Uri.parse(
    API_ACCOUNT_BALANCE,
  );

  final jsonRequestBody = jsonDecode(params);

  final requestHeader = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
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

  print(url);
  print(requestHeader);
  print(requestBody);

  return jsonDecode(response.body);
}
