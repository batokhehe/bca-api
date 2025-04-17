import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:http/http.dart' as http;
import 'package:my_project/const.dart';
import 'package:my_project/generator/asymmetric-generator.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'asymmetric_generator.dart';

Future<Response> onRequest(RequestContext context) async {
  tzdata.initializeTimeZones();
  final bangkok = tz.getLocation('Asia/Bangkok');
  final now = tz.TZDateTime.now(bangkok);
  final timestamp = formatTimestamp(now);

  const keyPath = 'certs/private_key.pem'; // Adjust if needed
  final keyFile = File(keyPath);
  if (!await keyFile.exists()) {
    return Response.json(
      statusCode: 500,
      body: {'error': 'Private key file not found'},
    );
  }

  final xSignature = await generateAsymmetric(timestamp, keyFile);

  try {
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

    // Check if successful
    // if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return Response.json(body: data);
    // } else {
    //   return Response.json(
    //     statusCode: response.statusCode,
    //     body: {'error': 'Failed to fetch access token'},
    //   );
    // }
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {'error': 'Exception: $e'},
    );
  }
}
