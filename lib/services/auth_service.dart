import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthService {
  Future<User> createUserWithEmailandPassword(
      String email, String sifre, String adSoyad) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: sifre);
    return userCredential.user;
  }

  Future<User> currentUser() async {
    try {
      User user = _auth.currentUser;
      print("4 çalıştı $user");
      return user;
    } catch (e) {
      print("auth server currentUser bölümünde hata var $e");
      return null;
    }
  }

  Future<User> signInWithEmailandPassword(String email, String sifre) async {
    UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(email: email, password: sifre);
    return userCredential.user;
  }

  Future<bool> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential userCredential = await _auth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        User _user = userCredential.user;
        return _user;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("forgot emailde sorun var $e");
    }
  }

  Future<bool> validateCurrentPassword(
      String oldPassword, String newPassword, User buUser) async {
    User firebaseUser = FirebaseAuth.instance.currentUser;
    var authCredentials = EmailAuthProvider.credential(
        email: buUser.email, password: oldPassword);
    print("credentialsımız $authCredentials");
    try {
      var authResult =
          await firebaseUser.reauthenticateWithCredential(authCredentials);
      if (authResult.user != null) {
        firebaseUser.updatePassword(newPassword);
        print("güncelledi");
        return true;
      } else {
        print("yok");
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print("hata aldı");
      return false;
    }
  }
}
