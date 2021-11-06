import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_search/Components/ReusablePaddingWidget.dart';
import 'package:photo_search/Resources/StringConstants.dart';
import 'package:photo_search/Resources/constants.dart';
import 'package:photo_search/login/view.dart';
import 'package:photo_search/registration/bloc.dart';
import 'package:photo_search/registration/state.dart';

import 'event.dart';

// ignore: must_be_immutable
class RegistrationPage extends StatelessWidget {
  static String id = "RegistrationPage";
  String emailId;
  String password;
  String fName;
  // String gender; Implement the gender Radio Buttons Later
  String phoneNumber;
  final RegistrationBloc rb = RegistrationBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegistrationBloc, RegistrationState>(
      cubit: rb,
      listener: (BuildContext context, state) {
        if (state is RegistrationSuccess) {
          if (state.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Registration was successful',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return LoginPage();
                },
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Registration was unsuccessful',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        }
      },
      builder: (BuildContext context, state) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);

        if (state is InitEvent) {
          return initUI(context);
        } else if (state is LoadingState) {
          return Constants.loadingWidget();
        } else {
          return initUI(context);
        }
      },
    );
  }

  Widget initUI(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset(
                    'assets/logo.png',
                    height: 200.0,
                    width: 200.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            GestureDetector(
              onHorizontalDragDown: (dragDownDetails) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  fName = value;
                },
                decoration: Constants.kTextFieldDecoration.copyWith(
                  hintText: 'Enter Your Full Name',
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            GestureDetector(
              onHorizontalDragDown: (dragDownDetails) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  emailId = value;
                },
                decoration: Constants.kTextFieldDecoration.copyWith(
                  hintText: emailIDBoxHint,
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            GestureDetector(
              onHorizontalDragDown: (dragDownDetails) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  phoneNumber = value;
                },
                decoration: Constants.kTextFieldDecoration.copyWith(
                  hintText: phoneNumberBoxHint,
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            GestureDetector(
              onHorizontalDragDown: (dragDownDetails) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              child: TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: Constants.kTextFieldDecoration.copyWith(
                  hintText: passwordBoxHint,
                ),
              ),
            ),
            SizedBox(height: 24),
            Flexible(
              child: Hero(
                tag: 'Register',
                child: Paddy(
                        op: () async {
                          rb.add(RegisterUser(
                              fName, emailId, phoneNumber, password));
                        },
                        textVal: 'Register',
                        bColor: Colors.blue)
                    .getPadding(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
