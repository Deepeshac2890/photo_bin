import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_search/Components/ReusablePaddingWidget.dart';
import 'package:photo_search/Resources/StringConstants.dart';
import 'package:photo_search/dashboard/view.dart';
import 'package:photo_search/login/view.dart';
import 'package:photo_search/registration/view.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = "WelcomeScreen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  void checkUserStatus() {}

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset(
                      'assets/logo.png',
                      height: 100.0,
                      width: 150.0,
                    ),
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: [dashboardAppTitleName],
                  textStyle: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Hero(
              tag: 'Login',
              child: Paddy(
                      op: () {
                        Navigator.pushNamed(context, LoginPage.id);
                      },
                      textVal: 'Log In',
                      bColor: Colors.lightBlue)
                  .getPadding(),
            ),
            Hero(
              tag: 'Register',
              child: Paddy(
                      op: () {
                        Navigator.pushNamed(context, RegistrationPage.id);
                      },
                      textVal: 'Register',
                      bColor: Colors.blue)
                  .getPadding(),
            ),
            Paddy(
                    op: () {
                      Navigator.pushNamed(context, DashboardPage.id);
                    },
                    textVal: 'Continue as Guest',
                    bColor: Colors.blue)
                .getPadding(),
          ],
        ),
      ),
    );
  }
}
