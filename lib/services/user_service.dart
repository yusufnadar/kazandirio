import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kazandirio/models/address_model.dart';
import 'package:kazandirio/models/product_model.dart';
import 'package:kazandirio/models/user_model.dart';
import 'package:kazandirio/provider/user_provider.dart';

class UserService {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  Future saveUser(User1 user1, User firebaseDB) async {
    try {
      await _firebaseDB
          .collection("users")
          .doc(user1.userID)
          .set(user1.toMap());
      print("firebase_db_service kullanıcı başarıyla kaydedildi");
    } catch (e) {
      print("firebase_db_service kullanıcı kaydedilmesi başarısız $e");
    }
  }

  Future readUser(String userID) async {
    try {
      DocumentSnapshot _okunanUser =
          await _firebaseDB.collection("users").doc(userID).get();
      print("firebase_db_service kullanıcı okunması başarılı");
      if (_okunanUser.data() != null) {
        return true;
      } else
        return false;
    } catch (e) {
      print("firebase_db_service kullanıcı okunması başarısız $e");
    }
  }

  Future<List<ProductModel>> getProducts() async {
    try {
      List<ProductModel> productList = [];
      QuerySnapshot querySnapshot =
          await _firebaseDB.collection("products").get();
      for (var item in querySnapshot.docs) {
        productList.add(ProductModel.fromMap(item.data()));
      }
      print("firebase_db_service ürünleri getirme başarılı");
      return productList;
    } catch (e) {
      print("firebase_db_service ürünleri getirme başarısız");
    }
  }

  Future addBasket(
      ProductModel product, User1 user, BuildContext context) async {
    DocumentSnapshot aboutUser =
        await _firebaseDB.collection("users").doc(user.userID).get();
    var basket = aboutUser.data()["basket"];
    basket = basket + product.countPrice;
    await _firebaseDB
        .collection("users")
        .doc(user.userID)
        .update({"basket": basket});
    DocumentSnapshot documentSnapshot = await _firebaseDB
        .collection("users")
        .doc(user.userID)
        .collection("sepetim")
        .doc(product.id)
        .get();
    if (documentSnapshot.data() == null) {
      await _firebaseDB
          .collection("users")
          .doc(user.userID)
          .collection("sepetim")
          .doc(product.id)
          .set({
        "id": product.id,
        "name": product.name,
        "piece": 1,
        "url": product.url,
        "price": product.price,
        "countPrice": product.countPrice,
      });
    } else {
      int adet = documentSnapshot.data()["piece"];
      adet++;
      await _firebaseDB
          .collection("users")
          .doc(user.userID)
          .collection("sepetim")
          .doc(product.id)
          .update({"piece": adet});
    }
  }

  Stream<List<ProductModel>> getMyBasket(User1 user) {
    var snapshot = _firebaseDB
        .collection("users")
        .doc(user.userID)
        .collection("sepetim")
        .snapshots();
    print("sepetimi getirme işlemi başarılı");
    return snapshot.map((sepetim) => sepetim.docs
        .map((product) => ProductModel.fromMap1(product.data()))
        .toList());
  }

  Future<List<ProductModel>> getMyBasket1(User1 user) async {
    List<ProductModel> list = [];
    var snapshot = await _firebaseDB
        .collection("users")
        .doc(user.userID)
        .collection("sepetim")
        .get();
    print("sepetimi getirme işlemi başarılı");
    for (var item in snapshot.docs) {
      list.add(ProductModel.fromMap1(item.data()));
    }
    return list;
  }

  /*
  for (var item in querySnapshot.docs) {
        ProductModel productModel = ProductModel.fromMap1(item.data());
        productList.add(productModel);
      }
   */

  Future increase(piece, id, String userID, countPrice, User1 user) async {
    await _firebaseDB
        .collection("users")
        .doc(userID)
        .collection("sepetim")
        .doc("$id")
        .update({"piece": piece + 1});
    DocumentSnapshot aboutUser =
        await _firebaseDB.collection("users").doc(userID).get();
    var basket = aboutUser.data()["basket"];
    basket = basket + countPrice;
    await _firebaseDB
        .collection("users")
        .doc(userID)
        .update({"basket": basket});
  }

  Future decrease(piece, id, String userID, countPrice) async {
    if (piece > 1) {
      await _firebaseDB
          .collection("users")
          .doc(userID)
          .collection("sepetim")
          .doc("$id")
          .update({"piece": piece - 1});
    } else {
      await _firebaseDB
          .collection("users")
          .doc(userID)
          .collection("sepetim")
          .doc("$id")
          .delete();
    }
    DocumentSnapshot aboutUser =
        await _firebaseDB.collection("users").doc(userID).get();
    var basket = aboutUser.data()["basket"];
    basket = basket - countPrice;
    await _firebaseDB
        .collection("users")
        .doc(userID)
        .update({"basket": basket});
    print("firebase_db_service azaltma işlemi başarılı");
  }

  Stream getTotalPrice(UserProvider userModel) {
    var snapshot =
        _firebaseDB.collection("users").doc(userModel.user.userID).snapshots();
    return snapshot.map((mesaj) => User1.fromMap(mesaj.data()));
  }

  Future addAddress(String name, String phone, String address,
      String addressName, User1 user, String city) async {
    var rastgeleID = _firebaseDB.collection("konusmalar").doc().id;
    try {
      await _firebaseDB
          .collection("users")
          .doc(user.userID)
          .collection("teslimatAdreslerim")
          .doc(rastgeleID)
          .set({
        "name": name,
        "phone": phone,
        "address": address,
        "city": city,
        "addressName": addressName,
        "id": rastgeleID
      });
    } catch (e) {
      print("firebase_db_service addaddress bölümünde hata var $e");
    }
  }

  Stream<List<AddressModel>> getAddress(User1 user) {
    try {
      var snapshot = _firebaseDB
          .collection("users")
          .doc(user.userID)
          .collection("teslimatAdreslerim")
          .snapshots();
      print("hata yok");
      return snapshot.map((sepetim) => sepetim.docs
          .map((product) => AddressModel.fromMap(product.data()))
          .toList());
    } catch (e) {
      print("hata geliyor");
    }
  }

  Future<List<AddressModel>> getAddress1(User1 user) async {
    List<AddressModel> liste = [];
    var snapshot = await _firebaseDB
        .collection("users")
        .doc(user.userID)
        .collection("teslimatAdreslerim")
        .get();
    print("hata yok");
    for (var item in snapshot.docs) {
      liste.add(AddressModel.fromMap(item.data()));
    }
    return liste;
  }

  Future deleteAddress(id, User1 user, int currentIndex) async {
    if (currentIndex == 0) {
      await _firebaseDB
          .collection("users")
          .doc(user.userID)
          .collection("teslimatAdreslerim")
          .doc(id)
          .delete();
    } else {
      await _firebaseDB
          .collection("users")
          .doc(user.userID)
          .collection("faturaAdreslerim")
          .doc(id)
          .delete();
    }
  }

  Future<List<AddressModel>> getAddressFuture(User1 user) async {
    print("geliyorr");
    List<AddressModel> adresler = [];
    QuerySnapshot snapshot = await _firebaseDB
        .collection("users")
        .doc(user.userID)
        .collection("teslimatAdreslerim")
        .get();
    for (var item in snapshot.docs) {
      adresler.add(AddressModel.fromMap(item.data()));
    }
    return adresler;
  }

  Future updateAddress(
      id, name, phone, address, addressName, User1 user, int index) async {
    print("id $id userid ${user.userID} $index");
    if (index == 0) {
      _firebaseDB
          .collection("users")
          .doc(user.userID)
          .collection("teslimatAdreslerim")
          .doc(id)
          .update({
        "name": name,
        "phone": phone,
        "address": address,
        "addressName": addressName
      });
    } else {
      _firebaseDB
          .collection("users")
          .doc(user.userID)
          .collection("faturaAdreslerim")
          .doc(id)
          .update({
        "name": name,
        "phone": phone,
        "address": address,
        "addressName": addressName
      });
    }
  }

  Future getAbout() async {
    var deger = await _firebaseDB.collection("about").doc("about").get();
    return deger.data()["about"];
  }

  Future deleteProduct(ProductModel data, User1 user) async {
    DocumentSnapshot aboutUser =
        await _firebaseDB.collection("users").doc(user.userID).get();
    var basket = aboutUser.data()["basket"];
    basket = basket - (data.countPrice * data.piece);
    await _firebaseDB
        .collection("users")
        .doc(user.userID)
        .update({"basket": basket});
    await _firebaseDB
        .collection("users")
        .doc(user.userID)
        .collection("sepetim")
        .doc(data.id)
        .delete();
  }

  Future<ProductModel> getProductWithID(String id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firebaseDB.collection("products").doc(id).get();
      return ProductModel.fromMap(documentSnapshot.data());
    } catch (e) {
      print("firebase_db_service ürünleri getirme başarısız");
    }
  }

  Future addBillAddress(String name, String phone, String address,
      String addressName, User1 user) async {
    var rastgeleID = _firebaseDB.collection("konusmalar").doc().id;
    try {
      await _firebaseDB
          .collection("users")
          .doc(user.userID)
          .collection("faturaAdreslerim")
          .doc(rastgeleID)
          .set({
        "name": name,
        "phone": phone,
        "address": address,
        "addressName": addressName,
        "id": rastgeleID
      });
    } catch (e) {
      print("firebase_db_service addaddress bölümünde hata var $e");
    }
  }

  Stream<List<AddressModel>> getBillAddress(User1 user) {
    try {
      var snapshot = _firebaseDB
          .collection("users")
          .doc(user.userID)
          .collection("faturaAdreslerim")
          .snapshots();
      print("hata yok");
      return snapshot.map((sepetim) => sepetim.docs
          .map((product) => AddressModel.fromMap(product.data()))
          .toList());
    } catch (e) {
      print("hata geliyor");
    }
  }

  Future getBillAddress1(User1 user) async {
    print("geliyorr");
    List<AddressModel> adresler = [];
    QuerySnapshot snapshot = await _firebaseDB
        .collection("users")
        .doc(user.userID)
        .collection("faturaAdreslerim")
        .get();
    for (var item in snapshot.docs) {
      adresler.add(AddressModel.fromMap(item.data()));
    }
    return adresler;
  }
}
