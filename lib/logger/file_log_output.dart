import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;

class FileLogOutput extends LogOutput {
  IOSink? _sink;
  String? _currentLogFile;
  final String logDir;

  FileLogOutput(this.logDir);

  @override
  void output(OutputEvent event) {
    final now = DateTime.now();
    final dateStr = '${now.year}-${_two(now.month)}-${_two(now.day)}';
    final filePath = p.join(logDir, 'app_$dateStr.log');

    if (_sink == null || _currentLogFile != filePath) {
      _sink?.close();
      Directory(logDir).createSync(recursive: true);
      final file = File(filePath);
      _sink = file.openWrite(mode: FileMode.append);
      _currentLogFile = filePath;
    }

    for (final line in event.lines) {
      _sink!.writeln(line);
    }
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Future<void> destroy() async {
    _sink?.close();
  }
}
