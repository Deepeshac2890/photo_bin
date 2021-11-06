class LoginState {
  LoginState init() {
    return LoginState();
  }

  LoginState clone() {
    return LoginState();
  }
}

class LoginSuccess extends LoginState {
  final bool success;
  final String error;

  LoginSuccess(this.success, this.error);
}

class ResetSuccess extends LoginState {
  final bool success;
  final String error;

  ResetSuccess(this.success, this.error);
}

class LoadingState extends LoginState {}
