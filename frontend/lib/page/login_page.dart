import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app_root.dart';

import '../cubit/application_cubit.dart';

class LoginPage extends StatefulWidget {
  final String title;

  const LoginPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isProcessing = false;

  String? validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  void onSubmit(ApplicationCubit appCubit, bool isLoggingIn) async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      var snackBarController = ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );

      try {
        setState(() {
          _isProcessing = true;
        });
        if (isLoggingIn) {
          await appCubit.login(
              _userNameController.text, _passwordController.text);
        } else {
          await appCubit.signUp(
              _userNameController.text, _passwordController.text);
        }
        snackBarController.close();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Success!')),
        );
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, HOME_PAGE);
        setState(() {
          _isProcessing = false;
        });
      } catch (e) {
        snackBarController.close();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Failed!')),
        );
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appCubit = context.watch<ApplicationCubit>();
    print("username:${appCubit.state.session?.username}");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to online chat. Please login',
            ),
            const Text(
              'Username:',
            ),
            TextFormField(
              enabled: !_isProcessing,
              validator: validateTextField,
              controller: _userNameController,
            ),
            const Text(
              'Password:',
            ),
            TextFormField(
              enabled: !_isProcessing,
              validator: validateTextField,
              controller: _passwordController,
            ),
            Row(children: [
              ElevatedButton(
                onPressed: !_isProcessing
                    ? () {
                        onSubmit(appCubit, true);
                      }
                    : null,
                child: const Text('Login'),
              ),
              ElevatedButton(
                onPressed: !_isProcessing
                    ? () {
                        onSubmit(appCubit, false);
                      }
                    : null,
                child: const Text('Sign up'),
              )
            ]),
          ],
        ),
      )),
    );
  }
}
