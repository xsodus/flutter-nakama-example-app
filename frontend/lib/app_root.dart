import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/page/chat_room.dart';
import 'package:frontend/page/home_page.dart';
import 'package:frontend/page/login_page.dart';

import 'cubit/application_cubit.dart';

String HOME_PAGE = "/";
String LOGIN_PAGE = "/login";
String CHAT_ROOM_PAGE = "/chat";

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ApplicationCubit(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            HOME_PAGE: (context) =>
                const HomePage(title: 'Flutter Demo Home Page'),
            // When navigating to the "/second" route, build the SecondScreen widget.
            LOGIN_PAGE: (context) => const LoginPage(title: 'Login'),
            CHAT_ROOM_PAGE: (context) => const ChatRoomPage(title: "Chat JA!")
          },
        ));
  }
}
