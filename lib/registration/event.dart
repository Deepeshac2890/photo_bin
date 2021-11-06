abstract class RegistrationEvent {}

class InitEvent extends RegistrationEvent {}

class RegisterUser extends RegistrationEvent {
  final String name;
  final String emailID;
  final String phoneNumber;
  final String password;

  RegisterUser(this.name, this.emailID, this.phoneNumber, this.password);
}
