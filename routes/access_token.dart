import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_project/access-token.dart';
import 'package:my_project/generator/asymmetric-generator.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'asymmetric_generator.dart';

Future<Response> onRequest(RequestContext context) async {
  tzdata.initializeTimeZones();
  final bangkok = tz.getLocation('Asia/Bangkok');
  final now = tz.TZDateTime.now(bangkok).add(const Duration(hours: 7));
  final timestamp = formatTimestamp(now);

  return Response.json(
    statusCode: 500,
    body: {'error': timestamp},
  );

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
    // Send POST request
    final response = await getAccessToken(timestamp, xSignature);

    final data = jsonDecode(response);
    return Response.json(body: data);
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {'error': 'Exception: $e'},
    );
  }
}
