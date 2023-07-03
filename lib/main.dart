import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/layout/home_layout.dart';

import 'shared/bloc_observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home:  Homelayout(),

    );
  }
}