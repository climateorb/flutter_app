import 'package:flutter/material.dart';
import 'package:climateorb/screens/home.dart';
import 'package:climateorb/screens/intro.dart';
import 'package:climateorb/screens/splash.dart';

var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => HomeScreen(),
  "/intro": (BuildContext context) => IntroScreen(),
};

void main() => runApp(new ClimateOrbApp());

class ClimateOrbApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.blueGrey, accentColor: Colors.greenAccent),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: routes);
  }
}