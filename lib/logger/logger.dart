import 'dart:io';

import 'package:logger/logger.dart';
import 'package:my_project/logger/file_log_output.dart';
import 'package:path/path.dart' as p;

final logDir = p.join(Directory.current.path, 'logs');

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
  output: FileLogOutput(logDir), // <-- stores in ./logs/
);
