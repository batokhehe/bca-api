import 'dart:convert';

import 'package:crypto/crypto.dart';

Future<String> generateSymmetric(
    String httpMethod,
    String accessToken,
    dynamic requestBody,
    String timestamp,
    String clientSecret,
    String endpoint) async {
  // Step 1: Minify JSON request body
  final minifiedJson = json.encode(requestBody);

  // Step 2: SHA-256 Hash (hex, lowercase)
  final hashedBody = sha256.convert(utf8.encode(minifiedJson)).toString();

  // Step 3: Construct StringToSign
  final stringToSign = [
    httpMethod.toUpperCase(),
    endpoint,
    accessToken,
    hashedBody,
    timestamp,
  ].join(':');

  print(stringToSign);
  // Step 4: Generate HMAC-SHA512 signature
  final hmacSha512 = Hmac(sha512, utf8.encode(clientSecret));
  final signatureBytes = hmacSha512.convert(utf8.encode(stringToSign)).bytes;

  // Step 5: Base64 Encode the Signature
  return base64Encode(signatureBytes);
}
