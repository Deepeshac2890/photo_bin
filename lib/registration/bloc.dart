import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:photo_search/Resources/StringConstants.dart';

import 'event.dart';
import 'state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegistrationState().init());
  Firestore fs = Firestore.instance;
  final fa = FirebaseAuth.instance;

  @override
  Stream<RegistrationState> mapEventToState(RegistrationEvent event) async* {
    String error;
    if (event is InitEvent) {
      yield await init();
    } else if (event is RegisterUser) {
      yield LoadingState();
      bool success = await _register(
          event.emailID, event.password, event.name, event.phoneNumber);
      if (!success) error = "Registration Failed !!!";

      yield RegistrationSuccess(error, success);
    }
  }

  Future<RegistrationState> init() async {
    return state.clone();
  }

  Future<bool> _register(
      String emailId, String password, String fName, String phoneNumber) async {
    if (emailId.contains('@') && password.length > 6) {
      try {
        // Always remember to enable authentication from firebase console
        final user = await fa.createUserWithEmailAndPassword(
            email: emailId, password: password);
        if (user != null) {
          await fs
              .collection('Users')
              .document(user.uid)
              .collection('Details')
              .document('Details')
              .setData({
            'Name': fName,
            'Email': emailId,
            'Profile Image': profileImageAsset,
            'Phone Number': phoneNumber,
            'About': '',
          });
          await fs
              .collection('UIDS')
              .document(emailId)
              .setData({'uid': user.uid});
          await user.sendEmailVerification();
          return true;
        }
      } catch (e) {
        print(e);
        return false;
      }
    }
    return false;
  }
}
