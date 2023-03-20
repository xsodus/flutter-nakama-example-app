import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app_root.dart';

import '../cubit/application_cubit.dart';

const String nakamaIcon = 'assets/images/nakama-icon.png';

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

  String? validateUserNameField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter user name';
    }
    return null;
  }

  String? validatePasswordField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    return null;
  }

  void onSubmit(
      ApplicationCubit appCubit, BuildContext context, bool isLoggingIn) async {
    if (!_formKey.currentState!.validate()) return;

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
      Navigator.pushReplacementNamed(context, HOME_PAGE);
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
            const Text('Flutter Nakama App',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 30)),
            const Image(image: AssetImage(nakamaIcon)),
            Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                    enabled: !_isProcessing,
                    validator: validateUserNameField,
                    controller: _userNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ))),
            Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                    obscureText: true,
                    enabled: !_isProcessing,
                    validator: validatePasswordField,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ))),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  onPressed: !_isProcessing
                      ? () {
                          onSubmit(appCubit, context, true);
                        }
                      : null,
                  child: const Text('Login'),
                ),
              ),
              ElevatedButton(
                onPressed: !_isProcessing
                    ? () {
                        onSubmit(appCubit, context, false);
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
