import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nakama/rtapi.dart';

import '../cubit/application_cubit.dart';
import '../nakama_socket_client.dart';

class ChatRoomPage extends StatefulWidget {
  final String title;

  const ChatRoomPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final _formKey = GlobalKey<FormState>();
  final _chatInputController = TextEditingController();
  final List<Widget> _allMessageWidgets = [];
  StreamSubscription<MatchData>? streamSubscription;

  @override
  void initState() {
    super.initState();

    streamSubscription = NakamaWSClient.instance?.onMatchData.listen((e) {
      if (e.opCode == Int64(AppOpCode.CHAT)) {
        print("receive from : ${e.presence.username}");
        buildMessageWidgets(e.presence.username, String.fromCharCodes(e.data));
      }
    });
  }

  void buildMessageWidgets(String userName, String message) {
    print("build : ${userName}, ${message}");
    setState(() {
      _allMessageWidgets.add(Text("$userName : $message"));
    });
  }

  void sendMessage(String matchId, String message) async {
    print("sendMessage op code : ${AppOpCode.CHAT}");
    NakamaWSClient.instance?.sendMatchData(
        matchId: matchId,
        opCode: Int64(AppOpCode.CHAT),
        data: message.codeUnits);
    buildMessageWidgets("Me", message);
    _chatInputController.text = "";
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appCubit = context.watch<ApplicationCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
                controller: _chatInputController,
                onSubmitted: (message) {
                  sendMessage(appCubit.state.match!.matchId, message);
                },
                decoration: InputDecoration(
                  hintText: 'Type your message here',
                  suffixIcon: IconButton(
                    onPressed: () {
                      sendMessage(appCubit.state.match!.matchId,
                          _chatInputController.text);
                    },
                    icon: const Icon(Icons.send),
                  ),
                )),
            ..._allMessageWidgets
          ],
        ),
      )),
    );
  }
}
