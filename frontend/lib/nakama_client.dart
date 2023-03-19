import 'package:flutter_nakama/nakama.dart';

class NakamaClient {
  static NakamaBaseClient? _instance;

  static NakamaBaseClient? getInstance() {
    if (_instance != null) return _instance!;

    _instance = getNakamaClient(
      host: '127.0.0.1',
      ssl: false,
      serverKey: 'defaultkey',
      grpcPort: 7349, // optional
      httpPort: 7350, // optional
    );

    return _instance;
  }
}
