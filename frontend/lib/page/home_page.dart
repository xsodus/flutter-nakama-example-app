import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_root.dart';
import '../cubit/application_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _matchIdController = TextEditingController();
  bool _isOnMatched = false;

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, LOGIN_PAGE);
  }

  void _goToChatRoom() {
    Navigator.pushReplacementNamed(context, CHAT_ROOM_PAGE);
  }

  void _createChatRoom(ApplicationCubit appCubit) async {
    if (appCubit.state.session != null && appCubit.state.match == null) {
      print("Create a new chat room!");
      await appCubit.createMatch();
    }
  }

  void _joinChatRoom(ApplicationCubit appCubit, String matchId) async {
    if (appCubit.state.session != null) {
      var snController = ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing....')),
      );
      try {
        var isMatched = await appCubit.joinMatch(matchId);

        if (isMatched) {
          snController.close();
          _goToChatRoom();
        } else {
          snController.close();
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed for joining!')),
          );
        }
      } catch (e) {
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateSession(appCubit);
      _createChatRoom(appCubit);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Welcome ${appCubit.state.session?.username}!',
                style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 30)),
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: const Text('Below is your game room id:',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
            ),
            Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Text(appCubit.state.match?.matchId ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 18))),
            Container(
                padding: const EdgeInsets.only(top: 20),
                child: const Text(
                  'Share this room id to your friend or enter your friend room id to join your friend room.',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                )),
            Container(
                padding: const EdgeInsets.all(20),
                child: TextField(
                    controller: _matchIdController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Room Id',
                    ))),
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
            tooltip: 'Logout',
            child: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
