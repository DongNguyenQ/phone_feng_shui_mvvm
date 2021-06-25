import 'package:flutter/material.dart';
import 'package:phone_feng_shui_mvvm/view/screen/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feng Shui Number',
      theme: ThemeData(
        primaryColor: Colors.black,
        primaryColorBrightness: Brightness.light,
        primaryColorDark: Colors.black,
        primaryColorLight: Colors.black,
        primaryTextTheme: TextTheme(),
        textTheme: TextTheme(),
        // primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
