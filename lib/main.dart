import 'package:flutter/material.dart';
import 'package:photo_search/dashboard/view.dart';
import 'package:photo_search/registration/view.dart';

import 'Simple_Screens/WelcomeScreen.dart';
import 'Simple_Screens/splashScreen.dart';
import 'login/view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo-Bin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashPage.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        SplashPage.id: (context) => SplashPage(),
        DashboardPage.id: (context) => DashboardPage(),
        LoginPage.id: (context) => LoginPage(),
        RegistrationPage.id: (context) => RegistrationPage(),
      },
    );
  }
}
