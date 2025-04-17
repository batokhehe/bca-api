import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:my_project/const.dart';

Future<String> generateAsymmetric(String timestamp, File keyFile) async {
  final stringToSign = '$CLIENT_ID|$timestamp';

  final privateKeyPem = keyFile.readAsString();
  final rsaPrivateKey =
      CryptoUtils.rsaPrivateKeyFromPem(await privateKeyPem);

  // Step 4: Sign the string
  final signer = Signer('SHA-256/RSA');
  final privateParams = PrivateKeyParameter<RSAPrivateKey>(rsaPrivateKey);
  signer.init(true, privateParams);

  final signature =
      signer.generateSignature(Uint8List.fromList(utf8.encode(stringToSign)))
          as RSASignature;
  final base64Signature = base64Encode(signature.bytes);

  return base64Signature;
}
