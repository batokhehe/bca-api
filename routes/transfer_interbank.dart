import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_project/access-token.dart';
import 'package:my_project/const.dart';
import 'package:my_project/generator/asymmetric-generator.dart';
import 'package:my_project/generator/symmetric-generator.dart';
import 'package:my_project/transfer-interbank.dart';
import 'package:my_project/utils.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405, body: 'Method Not Allowed');
  }

  final timestamp = getTimestamp();

  const keyPath = 'certs/private_key.pem'; // Adjust if needed
  final keyFile = File(keyPath);
  if (!await keyFile.exists()) {
    return Response.json(
      statusCode: 500,
      body: {'error': 'Private key file not found'},
    );
  }

  final xAsymmetric = await generateAsymmetric(timestamp, keyFile);

  try {
    // Send POST request
    final responseToken = await getAccessToken(timestamp, xAsymmetric);

    final data = jsonDecode(responseToken);
    final requestBody = jsonDecode(await context.request.body());
    final accessToken = data['accessToken'].toString();

    requestBody['partnerReferenceNo'] = getPartnerReferenceNo();
    requestBody['transactionDate'] = timestamp;

    final xSymmetric = await generateSymmetric(
      HTTP_METHOD_POST,
      accessToken,
      requestBody,
      timestamp,
      CLIENT_SECRET,
      ENDPOINT_TRANSFER_INTERBANK,
    );

    final response = await transferInterbank(
      timestamp,
      xSymmetric,
      accessToken,
      requestBody,
    );

    return Response.json(body: response);
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {'error': 'Exception: $e'},
    );
  }
}
