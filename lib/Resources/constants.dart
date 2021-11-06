import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_search/Simple_Screens/WelcomeScreen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'StringConstants.dart';

class Constants {
  static const kTextFieldDecoration = InputDecoration(
    hintText: searchBoxHint,
    hintStyle: TextStyle(
      color: Colors.grey,
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
  );

  static var _alertStyle = AlertStyle(
    animationType: AnimationType.grow,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    descTextAlign: TextAlign.start,
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.red,
    ),
    alertAlignment: Alignment.center,
  );

  static void showNoInternetAlert(BuildContext context) {
    Alert(
      context: context,
      style: _alertStyle,
      type: AlertType.info,
      title: noInternetAlertTitle,
      desc: noInternetAlertDesc,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }

  static void showNoLoginAlert(BuildContext context) {
    Alert(
      context: context,
      style: _alertStyle,
      type: AlertType.info,
      title: notLoggedInTitle,
      desc: notLoggedInDesc,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }

  static void showLogOutConfirmationAlert(BuildContext context) {
    Alert(
      context: context,
      style: _alertStyle,
      type: AlertType.info,
      title: "Logout Confirmation",
      desc: "Are your sure you want to Logout ?",
      buttons: [
        DialogButton(
          child: Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            Navigator.pop(context);
            logout(context);
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
        DialogButton(
          child: Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }

  static Future<void> logout(BuildContext context) async {
    FirebaseAuth fa = FirebaseAuth.instance;
    await fa.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, WelcomeScreen.id, (route) => false);
  }

  static Widget loadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
