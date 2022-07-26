import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_call_app/src/models/user.dart';

class AuthenticationDataProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // retrieve the current user
  Stream<UserModel> getCurrentUser() {
    return _auth.authStateChanges().map((user) {
      user?.reload();
      print('The user is +++++++++++++++++++++++++++++++++++$user');
      if (user != null) {
        return UserModel(
          uid: user.uid,
          name: user.displayName,
          email: user.email,
          picture: user.photoURL,
        );
      } else {
        return UserModel(uid: 'uid');
      }
    });
  }

  // Signup with credential
  Future<UserCredential?> signUp(UserModel user) async {
    try {
      UserCredential _userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: user.email!, password: user.password!);
      _verifyEmail();
      return _userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  // Signin with email and password
  Future<UserCredential?> signIn(UserModel user) async {
    try {
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
          email: user.email!, password: user.password!);

      return _userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }



  // Verify email address
  Future _verifyEmail() async {
    try {
      User? _user = _auth.currentUser;
      if (_user != null && !_user.emailVerified) {
        return await _user.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  // Signout from the app
  Future signOut() async {
    try {
      return await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }
}
