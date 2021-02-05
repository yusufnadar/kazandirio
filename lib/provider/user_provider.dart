import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kazandirio/models/address_model.dart';
import 'package:kazandirio/models/product_model.dart';
import 'package:kazandirio/models/user_model.dart';
import 'package:kazandirio/repository/user_repository.dart';
import 'package:kazandirio/services/locator.dart';

enum UserStatus { SUCCESS }

class UserProvider with ChangeNotifier {
  UserRepository _userRepository = locator<UserRepository>();
  User1 _user;
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  UserStatus _userStatus;

  List<ProductModel> sepetim;

  List<AddressModel> teslimatAdreslerim;
  List<AddressModel> faturaAdreslerim;

  User1 get user => _user;

  set user(User1 value) {
    _user = value;
    notifyListeners();
  }

  UserProvider() {
    currentUser();
    notifyListeners();
  }

  bool isLoading = false;

  changeState(bool _isLoading) {
    isLoading = _isLoading;
    notifyListeners();
  }

  Future<User1> currentUser() async {
    try {
      User _user1 = await _userRepository.currentUser();
      if (_user1 != null) {
        DocumentSnapshot userDocSnapshot =
            await _firebaseDB.collection("users").doc(_user1.uid).get();
        user = User1.fromDoc(userDocSnapshot);
        notifyListeners();
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print('User Store getCurrentUser error: $e');
      return null;
    }
  }

  Future addBasket(product, User1 user, BuildContext context) async {
    try {
      changeState(true);
      await _userRepository.addBasket(product, user, context);
      _userStatus = UserStatus.SUCCESS;
    } catch (e) {
      _userStatus = e;
    } finally {
      changeState(false);
    }
    return _userStatus;
  }

  Stream<List<ProductModel>> getMyBasket(User1 user) {
    return _userRepository.getMyBasket(user);
  }

  Future<List<ProductModel>> getMyBasket1(User1 user) async {
    sepetim = await _userRepository.getMyBasket1(user);
    notifyListeners();
  }

  Future increase(piece, id, String userID, countPrice, User1 user) async {
    try {
      changeState(true);
      await _userRepository.increase(piece, id, userID, countPrice, user);
      _userStatus = UserStatus.SUCCESS;
      notifyListeners();
    } catch (e) {
      _userStatus = e;
    } finally {
      changeState(false);
    }
    return _userStatus;
  }

  Future decrease(piece, id, String userID, countPrice) async {
    try {
      changeState(true);
      await _userRepository.decrease(piece, id, userID, countPrice);
      _userStatus = UserStatus.SUCCESS;
    } catch (e) {
      _userStatus = e;
    } finally {
      changeState(false);
    }
    return _userStatus;
  }

  Stream getTotalPrice(UserProvider userModel) {
    return _userRepository.getTotalPrice(userModel);
  }

  Future addAddress(String name, String phone, String address,
      String addressName, User1 user, String city) async {
    try {
      changeState(true);
      await _userRepository.addAddress(
          name, phone, address, addressName, user, city);
      changeState(false);
      _userStatus = UserStatus.SUCCESS;
      notifyListeners();
    } catch (e) {
      _userStatus = e;
    } finally {
      changeState(false);
      getAddress(user);
    }
    return _userStatus;
  }

  Stream<List<AddressModel>> getAddress(User1 user) {
    return _userRepository.getAddress(user);
  }

  Future<List<AddressModel>> getAddress1(User1 user) async {
    teslimatAdreslerim = await _userRepository.getAddress1(user);
    notifyListeners();
  }

  Future<List<AddressModel>> getBillAddress1(User1 user) async {
    faturaAdreslerim = await _userRepository.getBillAddress1(user);
    notifyListeners();
  }

  Future deleteAddress(id, User1 user, int currentIndex) async {
    try {
      changeState(true);
      await _userRepository.deleteAddress(id, user, currentIndex);
      notifyListeners();
      changeState(false);
      _userStatus = UserStatus.SUCCESS;
    } catch (e) {
      _userStatus = e;
    } finally {
      changeState(false);
      getAddress(user);
    }
    return _userStatus;
  }

  Future updateAddress(
      id, name, phone, address, addressName, User1 user, int index) async {
    try {
      changeState(true);
      await _userRepository.updateAddress(
          id, name, phone, address, addressName, user, index);
      changeState(false);
      _userStatus = UserStatus.SUCCESS;
    } catch (e) {
      _userStatus = e;
    } finally {
      changeState(false);
      getAddress(user);
    }
    return _userStatus;
  }

  Future deleteProduct(ProductModel data, User1 user) async {
    await _userRepository.deleteProduct(data, user);
  }

  Future addBillAddress(String name, String phone, String address,
      String addressName, User1 user) async {
    try {
      changeState(true);
      await _userRepository.addBillAddress(
          name, phone, address, addressName, user);
      changeState(false);
      _userStatus = UserStatus.SUCCESS;
    } catch (e) {
      changeState(false);
      _userStatus = e;
    }
    return _userStatus;
  }

  Stream<List<AddressModel>> getBillAddress(User1 user) {
    return _userRepository.getBillAddress(user);
  }
}

/*

  Future createUserWithEmailandPassword(email, sifre, adSoyad) async {
    try {
      user = await _userRepository.createUserWithEmailandPassword(
          email, sifre, adSoyad);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future currentUser() async {
    print("curent user");
    try {
      user = await _userRepository.currentUser();
      if (user != null) {
        print("içinde dönüyor");
        return user;
      }
    } catch (e) {
      print("UserModel currentUser bölümünde hata var $e");
      return null;
    }
  }

  Future signInWithEmailandPassword(
      String email, String sifre, BuildContext context1) async {
    try {
      notifyListeners();
      user = await _userRepository.signInWithEmailandPassword(email, sifre);
      if (user != null) {
        Navigator.of(context1).push(MaterialPageRoute(
          builder: (context) => BottomNavigationBars(
            currentTab1: 0,
          ),
        ));
        return user;
      }
    } on FirebaseAuthException catch (e) {
      if (e.toString() ==
          "[firebase_auth/ınvalıd-emaıl] The email address is badly formatted.") {
        ScaffoldMessenger.of(context1).showSnackBar(SnackBar(
          content: Text("Bu email adresi geçersiz formatta"),
          duration: Duration(seconds: 1),
        ));
      } else if (e.toString() ==
          "[firebase_auth/emaıl-already-ın-use] The email address is already in use by another account.") {
        ScaffoldMessenger.of(context1).showSnackBar(SnackBar(
          content: Text("Bu email adresi zaten kullanımda"),
          duration: Duration(seconds: 1),
        ));
      } else {
        ScaffoldMessenger.of(context1).showSnackBar(SnackBar(
          content: Text("Böyle bir hesap bulunmamaktadır"),
          duration: Duration(seconds: 1),
        ));
      }
    }
  }

  Future<bool> signOut() async {
    try {
      await _userRepository.signOut();
      user = null;
      return true;
    } catch (e) {
      print("UserModel signOut bölümünde hata var $e");
      return false;
    }
  }

  Future<User1> signInWithGoogle() async {
    try {
      user = await _userRepository.signInWithGoogle();
      return _user;
    } catch (e) {
      print("hata var ${e.toString()}");
      return null;
    }
  }
 */
