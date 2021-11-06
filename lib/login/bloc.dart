import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'event.dart';
import 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState().init());
  final FirebaseAuth fa = FirebaseAuth.instance;

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is InitEvent) {
      yield await init();
    } else if (event is LoginUsingMailEvent) {
      yield LoadingState();
      bool success = await loginUsingEmail(event.emailID, event.password);
      print(success);
      String error;
      if (success)
        error = null;
      else
        error = "Login Attempt was unsuccessful";
      yield LoginSuccess(success, error);
    } else if (event is SendResetLinkEvent) {
      bool success = await sendResetLink(event.emailID);
      String error;
      if (success)
        error = null;
      else
        error = "Reset Link was not sent";
      yield ResetSuccess(success, error);
    }
  }

  Future<LoginState> init() async {
    return state.clone();
  }

  Future<bool> loginUsingEmail(String emailID, String password) async {
    try {
      await fa.signInWithEmailAndPassword(email: emailID, password: password);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> sendResetLink(String emailID) async {
    try {
      await fa.sendPasswordResetEmail(email: emailID);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
