import 'package:dart_frog/dart_frog.dart';
import 'package:my_project/logger/logger_middleware.dart';

Handler middleware(Handler handler) {
  return handler.use(loggerMiddleware());
}
