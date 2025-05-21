import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:my_project/services/mongo_service.dart';

final mongo = MongoService.getInstance(
  'mongodb://logger:gtx.lgd@10.3.15.86:27017/logs?authSource=admin',
);

Middleware loggerMiddleware() {
  return (handler) {
    return (context) async {
      final stopwatch = Stopwatch()..start();
      final request = context.request;

      // Log request info
      final requestBody = await request.body();

      // Get original response
      final response = await handler(context);

      // Read and copy response body
      final bodyStr = await response.body();

      await mongo.insertLog(
        level: 'INFO',
        message: 'Request to ${request.url.path}',
        service: 'bca-api',
        meta: {
          'method': request.method.name,
          'path': request.url.path,
          'queryParameters': request.url.queryParameters,
          'requestHeaders': request.headers,
          'requestBody': tryParseJson(requestBody),
          'statusCode': response.statusCode,
          'responseHeaders': response.headers,
          'responseBody': tryParseJson(bodyStr),
          'duration_ms': stopwatch.elapsedMilliseconds,
        },
      );
      stopwatch.stop();
      // Rebuild the response so it can be returned
      return Response(
        statusCode: response.statusCode,
        headers: response.headers,
        body: bodyStr,
      );
    };
  };
}

dynamic tryParseJson(String input) {
  try {
    return json.decode(input);
  } catch (_) {
    return input;
  }
}
