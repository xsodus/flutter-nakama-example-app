import 'package:bloc/bloc.dart';
import 'package:frontend/nakama_client.dart';
import 'package:frontend/nakama_socket_client.dart';

import 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit() : super(ApplicationState(session: null, match: null));

  Future<void> login(String username, String password) async {
    var session = await NakamaClient.getInstance()!
        .authenticateEmail(email: username, password: password, create: false);

    await NakamaClient.getInstance()
        ?.updateAccount(session: session, username: username.split("@")[0]);

    emit(ApplicationState(session: session, match: state.match));
    NakamaWSClient.setSession(session);
  }

  Future<void> signUp(String username, String password) async {
    var session = await NakamaClient.getInstance()!
        .authenticateEmail(email: username, password: password, create: true);

    await NakamaClient.getInstance()
        ?.updateAccount(session: session, username: username.split("@")[0]);

    emit(ApplicationState(session: session, match: state.match));
    NakamaWSClient.setSession(session);
  }

  Future<void> createMatch() async {
    final match = await NakamaWSClient.instance?.createMatch();
    emit(ApplicationState(session: state.session, match: match));
  }

  Future<bool> joinMatch(String matchId) async {
    print("match id : ${matchId}");
    final match = await NakamaWSClient.instance?.joinMatch(matchId);
    bool isMatched = match?.hasMatchId() ?? false;
    if (isMatched) {
      emit(ApplicationState(session: state.session, match: match));
    }
    return isMatched;
  }
}
