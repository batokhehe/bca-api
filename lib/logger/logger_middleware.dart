import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';

import 'package:my_project/logger/logger.dart';

Middleware loggerMiddleware() {
  return (handler) {
    return (context) async {
      final request = context.request;

      // Log request info
      final requestBody = await request.body();
      logger.i('➡️ ${request.method} ${request.url.path}');
      if (requestBody.isNotEmpty) {
        logger.i('📥 Request Body: $requestBody');
      }

      // Get original response
      final response = await handler(context);

      // Read and copy response body
      final bodyStr = await response.body();

      try {
        final decoded = json.decode(bodyStr);
        logger.i('📤 Response Body (JSON): $decoded');
      } catch (_) {
        logger.i('📤 Response Body (Raw): $bodyStr');
      }

      logger.i('⬅️ Status: ${response.statusCode}');

      // Rebuild the response so it can be returned
      return Response(
        statusCode: response.statusCode,
        headers: response.headers,
        body: bodyStr,
      );
    };
  };
}
