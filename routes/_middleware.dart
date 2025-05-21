import 'package:dart_frog/dart_frog.dart';
import '../middleware/logger.dart';

Handler middleware(Handler handler) {
  return handler.use(loggerMiddleware());
}
