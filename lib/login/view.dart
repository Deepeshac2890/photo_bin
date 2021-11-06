import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_search/Components/ReusablePaddingWidget.dart';
import 'package:photo_search/Resources/StringConstants.dart';
import 'package:photo_search/Resources/constants.dart';
import 'package:photo_search/dashboard/view.dart';
import 'package:photo_search/login/state.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'bloc.dart';
import 'event.dart';

class LoginPage extends StatefulWidget {
  static final id = "LoginPage";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String emailId;
  String password;
  var forgotEmailController = TextEditingController();
  final LoginBloc loginBloc = LoginBloc();

  @override
  void dispose() {
    loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      cubit: loginBloc,
      listener: (BuildContext context, state) {
        if (state is LoginSuccess) {
          if (state.success) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DashboardPage();
                },
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        } else if (state is ResetSuccess) {
          if (state.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'The Reset Link was sent successfully',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        }
      },
      builder: (BuildContext context, state) {
        if (state is InitEvent) {
          return loginInit(context);
        } else if (state is LoadingState)
          return Constants.loadingWidget();
        else
          return loginInit(context);
      },
    );
  }

  Widget loginInit(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (BuildContext innerContext) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Container(
                    child: Image.asset(
                      'assets/logo.png',
                      height: 200.0,
                      width: 200.0,
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
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: Constants.kTextFieldDecoration
                        .copyWith(hintText: passwordBoxHint),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Hero(
                  tag: 'Login',
                  child: Paddy(
                          op: () async {
                            // Login Here
                            loginBloc
                                .add(LoginUsingMailEvent(emailId, password));
                          },
                          textVal: 'Login',
                          bColor: Colors.blue)
                      .getPadding(),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    child: Text('Forgot Password ?'),
                    onPressed: () {
                      // Implement Forgot Password Page
                      Alert(
                        context: context,
                        title: 'Forgot Password',
                        content: Column(
                          children: [
                            GestureDetector(
                              child: TextField(
                                decoration: InputDecoration(
                                  icon: Icon(Icons.account_circle),
                                  labelText: 'Username',
                                ),
                                onChanged: (value) {
                                  // Do something
                                },
                                controller: forgotEmailController,
                              ),
                              onHorizontalDragDown: (dragDownDetails) {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                              },
                            ),
                          ],
                        ),
                        buttons: [
                          DialogButton(
                            onPressed: () async {
                              var email = forgotEmailController.text;
                              // Do reset here
                              loginBloc.add(SendResetLinkEvent(email));
                              Navigator.pop(context);
                              forgotEmailController.clear();
                            },
                            child: Text(
                              "Request",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ],
                      ).show();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
