import 'package:mongo_dart/mongo_dart.dart';

class MongoService {

  MongoService._internal(this.uri);
  final String uri;
  static MongoService? _instance;
  Db? _db;
  DbCollection? logs;
  bool _isConnected = false;

  static MongoService getInstance(String uri) {
    _instance ??= MongoService._internal(uri);
    return _instance!;
  }

  Future<void> connect() async {
    if (_db == null) {
      _db = Db(uri);
      await _db!.open();
      logs = _db!.collection('logs');
      _isConnected = true;
      print('MongoDB connected');
    }
  }


  Future<void> insertLog({
    required String level,
    required String message,
    String? service,
    Map<String, dynamic>? meta,
  }) async {
    if (!_isConnected) {
      await connect();
    }
    await logs!.insertOne({
      'level': level,
      'message': message,
      'service': service ?? 'unknown',
      'meta': meta,
      'timestamp': DateTime.now().toUtc(),
    });
  }

  Future<void> close() async {
    if (_isConnected) {
      await _db!.close();
      _isConnected = false;
    }
  }
}
