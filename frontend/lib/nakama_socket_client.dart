import 'package:flutter_nakama/nakama.dart';

class AppOpCode {
  static const int JOIN = 0;
  static const int CHAT = 1;
  static const int LEAVE = 2;
}

class NakamaWSClient {
  static NakamaWebsocketClient? _instance;
  static Session? _session;

  static void setSession(Session session) {
    _session = session;
    _instance = null;
  }

  static NakamaWebsocketClient? get instance {
    if (_instance != null) return _instance!;

    print("connecting to ws with token: ${_session?.token}");
    _instance = NakamaWebsocketClient.init(
      host: '127.0.0.1',
      ssl: false,
      token: _session?.token ?? "",
    );

    return _instance;
  }
}
