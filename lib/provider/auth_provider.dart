import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kazandirio/repository/user_repository.dart';
import 'package:kazandirio/services/locator.dart';
import 'package:kazandirio/utils/exception_handlers/auth_exception_handler.dart';

enum VerifyState { WAITING_FOR_VERIFY, VERIFIED }

class AuthProvider with ChangeNotifier {
  UserRepository _userRepository = locator<UserRepository>();

  AuthProvider() {
    currentUser();
    notifyListeners();
  }
  AuthResultStatus authStatus;
  AuthResultStatus accountAuthStatus;

  VerifyState verifyState = VerifyState.WAITING_FOR_VERIFY;
  List<String> signInMethods = [];

  bool isLoading = false;

  User buUser;

  setUser(User _user) {
    buUser = _user;
    notifyListeners();
  }

  changeState(bool _isLoading) {
    isLoading = _isLoading;
    notifyListeners();
  }

  currentUser() async {
    try {
      changeState(true);
      buUser = await _userRepository.currentUser();
      return currentUser;
    } catch (e) {
      print('AuthStore getUser Error: $e');
      return null;
    } finally {
      changeState(false);
    }
  }

  signOut() async {
    changeState(true);
    await _userRepository.signOut();
    buUser = null;
    notifyListeners();
    changeState(false);
  }

  Future<AuthResultStatus> signInWithEmailandPassword(
      {@required String email, @required String password}) async {
    changeState(true);
    authStatus = null;
    try {
      User user =
          await _userRepository.signInWithEmailandPassword(email, password);
      if (user != null) {
        if (user.emailVerified) {
          print('AuthStore logIn user verified');
          verifyState = VerifyState.VERIFIED;
          buUser = user;
          authStatus = AuthResultStatus.successful;
          changeState(false);
        } else {
          print("emaile bak");
          verifyState = VerifyState.WAITING_FOR_VERIFY;
          authStatus = null;
          buUser = null;
          changeState(false);
        }
      } else {
        print('AuthStore Login user null');
        changeState(false);
      }
    } on FirebaseAuthException catch (e) {
      print('Auth Store Login Error: $e');
      verifyState = VerifyState.VERIFIED;
      authStatus = AuthExceptionHandler.handleException(e);
      changeState(false);
    }
    return authStatus;
  }

  Future<AuthResultStatus> loginWithGoogle() async {
    try {
      authStatus = null;
      changeState(true);
      User user = await _userRepository.signInWithGoogle();
      if (user != null) {
        print('AuthStore user Logged with loginWithGoogle');
        authStatus = AuthResultStatus.successful;
        buUser = user;
        changeState(false);
      } else {
        print('AuthStore loginWithGoogle user null');
        authStatus = AuthResultStatus.abortedByUser;
        changeState(false);
      }
    } catch (e) {
      print('Auth Store loginWithGoogle Error: $e');
      authStatus = AuthResultStatus.abortedByUser;
      changeState(false);
    }
    return authStatus;
  }

  Future<AuthResultStatus> signUp(
      {@required String name,
      @required String email,
      @required String password}) async {
    try {
      authStatus = null;
      changeState(true);
      User user = await _userRepository.createUserWithEmailandPassword(
          name, email, password);
      if (user != null) {
        await user.sendEmailVerification();
        print('AuthStore signUp user waiting for verify');
        authStatus = AuthResultStatus.successful;
        await signOut();
        buUser = null;
        changeState(false);
      } else {
        print('AuthStore signUp user null');
        changeState(false);
      }
    } on FirebaseAuthException catch (e) {
      print('Auth Store signUp Error: $e');
      authStatus = AuthExceptionHandler.handleException(e);
      changeState(false);
    }
    return authStatus;
  }

  Future forgotPassword(String email) async {
    try {
      changeState(true);
      await _userRepository.forgotPassword(email);
      authStatus = AuthResultStatus.successful;
      changeState(false);
    } on FirebaseAuthException catch (e) {
      authStatus = AuthExceptionHandler.handleException(e);
      changeState(false);
    }
    return authStatus;
  }

  Future validateCurrentPassword(
      String oldPassword, String newPassword, User buUser) async {
    try {
      changeState(true);
      await _userRepository
          .validateCurrentPassword(oldPassword, newPassword, buUser)
          .then((value) {
        if (value == true) {
          print("başarılı");
          authStatus = AuthResultStatus.successful;
          changeState(false);
        } else {
          print("başarısız");
          authStatus = AuthResultStatus.wrongPassword;
          changeState(false);
        }
      });
    } on FirebaseAuthException catch (e) {
      print("başarısız 2");
      authStatus = AuthExceptionHandler.handleException(e);
      changeState(false);
    }
    return authStatus;
  }
}
