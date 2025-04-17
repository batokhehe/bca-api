import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

Future<Response> onRequest(RequestContext context) async {
  // Step 1: Initialize timezone (only once ideally, but ok here for demo)
  tzdata.initializeTimeZones();
  final bangkok = tz.getLocation('Asia/Bangkok');
  final now = tz.TZDateTime.now(bangkok);
  final timestamp = formatTimestamp(now);

  // Step 2: Your client ID and string to sign
  const clientId = '76c97d77-44d9-46c4-bb45-87e807b72c93';
  final stringToSign = '$clientId|$timestamp';

  // Step 3: Load private key
  const keyPath = 'certs/private_key.pem'; // Adjust if needed
  final keyFile = File(keyPath);
  if (!await keyFile.exists()) {
    return Response.json(
      statusCode: 500,
      body: {'error': 'Private key file not found'},
    );
  }

  final privateKeyPem = await keyFile.readAsString();
  final rsaPrivateKey = CryptoUtils.rsaPrivateKeyFromPem(privateKeyPem);

  // Step 4: Sign the string
  final signer = Signer('SHA-256/RSA');
  final privateParams = PrivateKeyParameter<RSAPrivateKey>(rsaPrivateKey);
  signer.init(true, privateParams);

  final signature =
      signer.generateSignature(Uint8List.fromList(utf8.encode(stringToSign)))
          as RSASignature;
  final base64Signature = base64Encode(signature.bytes);

  // Return result
  return Response.json(body: {
    'x-signature': base64Signature,
    'timestamp': timestamp,
  });
}

String formatTimestamp(tz.TZDateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  final h = dt.hour.toString().padLeft(2, '0');
  final min = dt.minute.toString().padLeft(2, '0');
  final s = dt.second.toString().padLeft(2, '0');

  final offset = dt.timeZoneOffset;
  final sign = offset.isNegative ? '-' : '+';
  final hours = offset.inHours.abs().toString().padLeft(2, '0');
  final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');

  return '$y-$m-${d}T$h:$min:$s$sign$hours:$minutes';
}