import 'package:flutter_nakama/nakama.dart';
import 'package:flutter_nakama/rtapi.dart' as rtpb;

class ApplicationState {
  rtpb.Match? match;
  Session? session;

  ApplicationState({this.session, this.match});
}
