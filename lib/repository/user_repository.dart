import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kazandirio/models/address_model.dart';
import 'package:kazandirio/models/product_model.dart';
import 'package:kazandirio/models/user_model.dart';
import 'package:kazandirio/provider/user_provider.dart';
import 'package:kazandirio/services/auth_service.dart';
import 'package:kazandirio/services/locator.dart';
import 'package:kazandirio/services/user_service.dart';

class UserRepository {
  AuthService _authService = locator<AuthService>();
  UserService _userService = locator<UserService>();
  //FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

  List<User1> kullanicilarListesi = [];
  Map<String, String> kullaniciToken = Map<String, String>();

  Future<User> createUserWithEmailandPassword(
      String adSoyad, String email, String sifre) async {
    await Firebase.initializeApp();
    User user = await _authService.createUserWithEmailandPassword(
        email, sifre, adSoyad);
    await _userService.saveUser(
        User1(
          email: email,
          userID: user.uid,
          userName: adSoyad,
          basket: 0,
        ),
        user);
    return user;
  }

  Future<User> currentUser() async {
    User user = await _authService.currentUser();
    if (user != null) {
      print("3 çalıştı");
      return user;
    } else {
      return null;
    }
  }

  Future<User> signInWithEmailandPassword(String email, String sifre) async {
    User user = await _authService.signInWithEmailandPassword(email, sifre);
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  Future<bool> signOut() async {
    return await _authService.signOut();
  }

  Future<User> signInWithGoogle() async {
    User user = await _authService.signInWithGoogle();
    if (await _userService.readUser(user.uid) == false) {
      await _userService.saveUser(
          User1(
              email: user.email,
              userID: user.uid,
              userName: user.displayName,
              basket: 0),
          user);
      return user;
    } else {
      return user;
    }
  }

  Future addBasket(product, User1 user, BuildContext context) async {
    return await _userService.addBasket(product, user, context);
  }

  Stream getMyBasket(User1 user) {
    return _userService.getMyBasket(user);
  }

  Future<List<ProductModel>> getMyBasket1(User1 user) async {
    return await _userService.getMyBasket1(user);
  }

  Future increase(piece, id, String userID, countPrice, User1 user) async {
    await _userService.increase(piece, id, userID, countPrice, user);
  }

  Future decrease(piece, id, String userID, countPrice) async {
    await _userService.decrease(piece, id, userID, countPrice);
  }

  Stream getTotalPrice(UserProvider userModel) {
    return _userService.getTotalPrice(userModel);
  }

  Future addAddress(String name, String phone, String address,
      String addressName, User1 user, String city) async {
    return await _userService.addAddress(
        name, phone, address, addressName, user, city);
  }

  Stream<List<AddressModel>> getAddress(User1 user) {
    return _userService.getAddress(user);
  }

  Future<List<AddressModel>> getAddress1(User1 user) async {
    return await _userService.getAddress1(user);
  }

  Future deleteAddress(id, User1 user, int currentIndex) async {
    await _userService.deleteAddress(id, user, currentIndex);
  }

  Future updateAddress(
      id, name, phone, address, addressName, User1 user, int index) async {
    await _userService.updateAddress(
        id, name, phone, address, addressName, user, index);
  }

  Future deleteProduct(ProductModel data, User1 user) async {
    await _userService.deleteProduct(data, user);
  }

  Future addBillAddress(String name, String phone, String address,
      String addressName, User1 user) async {
    return await _userService.addBillAddress(
        name, phone, address, addressName, user);
  }

  Stream<List<AddressModel>> getBillAddress(User1 user) {
    return _userService.getBillAddress(user);
  }

  Future forgotPassword(String email) async {
    await _authService.forgotPassword(email);
  }

  Future<bool> validateCurrentPassword(
      String oldPassword, String newPassword, User buUser) async {
    return await _authService.validateCurrentPassword(
        oldPassword, newPassword, buUser);
  }

  Future<List<AddressModel>> getBillAddress1(User1 user) async {
    return await _userService.getBillAddress1(user);
  }
}
