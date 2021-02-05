import 'package:flutter/material.dart';
import 'package:kazandirio/models/product_model.dart';
import 'package:kazandirio/services/locator.dart';
import 'package:kazandirio/services/user_service.dart';

class ProductProvider with ChangeNotifier {
  final _firebasedbService = locator<UserService>();

  List<ProductModel> _products;

  List<ProductModel> get products => _products;

  set products(List<ProductModel> value) {
    _products = value;
    notifyListeners();
  }

  ProductModel oneProduct;

  String about;

  Future<List<ProductModel>> getProducts() async {
    products = await _firebasedbService.getProducts();
  }

  Future getAbout() async {
    about = await _firebasedbService.getAbout();
    notifyListeners();
  }

  Future<ProductModel> getProductWithID(String id) async {
    oneProduct = await _firebasedbService.getProductWithID(id);
    notifyListeners();
  }
}
