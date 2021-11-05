import 'package:flutter/material.dart';
import 'package:photo_search/Stateless_Screen/splashScreen.dart';
import 'package:photo_search/dashboard/view.dart';

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
        SplashPage.id: (context) => SplashPage(),
        DashboardPage.id: (context) => DashboardPage(),
      },
    );
  }
}
