import 'package:flutter/material.dart';
import 'package:frontend/Classes/connectionhandler.dart';
import 'package:provider/provider.dart';

import 'screens/MainScreen.dart';

void main() {
  runApp(ChangeNotifierProvider<connectionhandler>(
      create: (BuildContext context) => connectionhandler(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}
