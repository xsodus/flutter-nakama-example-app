import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app_root.dart';
import 'package:frontend/observer/application_observer.dart';

void main() {
  Bloc.observer = ApplicationObserver();
  runApp(const AppRoot());
}
