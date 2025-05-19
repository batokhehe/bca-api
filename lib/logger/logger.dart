import 'package:logger/logger.dart';
import 'package:my_project/logger/file_log_output.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    // no stack trace
    errorMethodCount: 0,
    colors: false,
    // disable terminal color codes for log files
    printEmojis: false,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
  output: FileLogOutput('logs'), // <-- stores in ./logs/
);
