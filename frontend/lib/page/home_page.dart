import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nakama/rtapi.dart';

import '../app_root.dart';
import '../cubit/application_cubit.dart';
import '../nakama_socket_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _matchIdController = TextEditingController();
  bool _isOnMatched = false;
  StreamSubscription<MatchData>? streamSubscription;

  void _goToLogin() {
    Navigator.pushNamed(context, LOGIN_PAGE);
  }

  void _goToChatRoom() {
    Navigator.pushNamed(context, CHAT_ROOM_PAGE);
  }

  void _createChatRoom(ApplicationCubit appCubit) async {
    if (appCubit.state.session != null && appCubit.state.match == null) {
      print("Create a new chat room!");
      await appCubit.createMatch();
      streamSubscription = NakamaWSClient.instance?.onMatchData.listen((e) {
        print("${e.presence.username} has join to this room");
        print("opcode : ${e.opCode}");
        if (e.opCode == Int64(AppOpCode.JOIN)) {
          _goToChatRoom();
        }
      });
    }
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  void _joinChatRoom(ApplicationCubit appCubit, String matchId) async {
    if (appCubit.state.session != null) {
      var snController = ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing....')),
      );
      try {
        var isMatched = await appCubit.joinMatch(matchId);
        print('matched! ${isMatched}');

        if (isMatched) {
          print('send ');
          NakamaWSClient.instance?.sendMatchData(
            matchId: matchId,
            opCode: Int64(AppOpCode.JOIN),
            data: 'join'.codeUnits,
          );
          snController.close();
          _goToChatRoom();
        } else {
          snController.close();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed for joining!')),
          );
        }
      } catch (e) {
        print("error : ${e.toString()}");
        snController.close();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed for joining!')),
        );
      }
    }
  }

  void _validateSession(ApplicationCubit appCubit) {
    if (appCubit.state.session == null) {
      Navigator.pushReplacementNamed(context, LOGIN_PAGE);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appCubit = context.watch<ApplicationCubit>();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _validateSession(appCubit);
      _createChatRoom(appCubit);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hello ${appCubit.state.session?.username}!',
            ),
            Text(
              'Here is your chat room id:',
            ),
            Text(appCubit.state.match?.matchId ?? ""),
            Text(
              'Share this id to your friend or entering the id to join your friend room',
            ),
            TextField(
              controller: _matchIdController,
            ),
            ElevatedButton(
                onPressed: () {
                  _joinChatRoom(appCubit, _matchIdController.text);
                },
                child: const Text('Join!'))
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _goToLogin,
            tooltip: 'Go to next page',
            child: const Icon(Icons.login),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
