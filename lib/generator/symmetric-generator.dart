import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:my_project/const.dart';

Future<String> generateSymmetric(String httpMethod, String accessToken,
    String requestBody, String timestamp, String clientSecret,) async {
  // Step 1: Minify JSON request body
  final decodedBody = json.decode(requestBody);
  final minifiedJson = json.encode(decodedBody);

  // Step 2: SHA-256 Hash (hex, lowercase)
  final hashedBody = sha256.convert(utf8.encode(minifiedJson)).toString();

  // Step 3: Construct StringToSign
  final stringToSign = [
    httpMethod.toUpperCase(),
    ENDPOINT_TRANSFER_INTERBANK,
    accessToken,
    hashedBody,
    timestamp,
  ].join(':');

  // Step 4: Generate HMAC-SHA512 signature
  final hmacSha512 = Hmac(sha512, utf8.encode(clientSecret));
  final signatureBytes = hmacSha512.convert(utf8.encode(stringToSign)).bytes;

  // Step 5: Base64 Encode the Signature
  return base64Encode(signatureBytes);
}
