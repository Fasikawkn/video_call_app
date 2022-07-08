

import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_call_app/src/models/user.dart';
import 'package:video_call_app/src/services/data_provider/authentication_service.dart';

class AuthenticationRepository{
  final  AuthenticationDataProvider dataProvider;

  AuthenticationRepository({required this.dataProvider});


  // get current user
  Stream<UserModel> getCurrentUser() {
    return dataProvider.getCurrentUser();
  }

  // signup using credential
  Future<UserCredential?> signUp(UserModel user) async{
    try {
      return await dataProvider.signUp(user);
      
      
    } on FirebaseAuthException catch (e) {
       throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  // signin with credential
  Future<UserCredential?> signIn(UserModel user) async{
    try {
      return await dataProvider.signIn(user);
      
    } on FirebaseAuthException catch (e) {
       throw FirebaseAuthException(code: e.code, message: e.message);
      
    }
  }

  // signout the user from the app
  Future signOut() async{
    try {
      return await dataProvider.signOut();
      
    } on FirebaseAuthException catch (e) {
       throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }


}