import 'package:flutter/material.dart';
import 'package:photo_search/dashboard/view.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashPage extends StatelessWidget {
  static String id = "SplashPage";
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: new DashboardPage(),
      title: new Text(
        'Photo-Bin',
        textScaleFactor: 2,
      ),
      image: new Image.asset('assets/logo.png'),
      photoSize: 100.0,
      loaderColor: Colors.blue,
    );
  }
}
