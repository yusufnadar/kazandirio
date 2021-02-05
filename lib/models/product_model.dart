class ProductModel {
  var id;
  var name;
  var rating;
  var price;
  var countPrice;
  var description;
  var piece;
  var url;

  ProductModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        rating = map['rating'],
        price = map['price'],
        piece = map['piece'],
        url = map['url'],
        countPrice = map['countPrice'],
        description = map['description'];

  ProductModel.fromMap1(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        price = map['price'],
        piece = map['piece'],
        url = map['url'],
        countPrice = map['countPrice'];
}
