import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kazandirio/models/product_model.dart';
import 'package:kazandirio/person_page/person_page.dart';
import 'package:kazandirio/product_detail/product_detail_page.dart';
import 'package:kazandirio/provider/auth_provider.dart';
import 'package:kazandirio/provider/product_provider.dart';
import 'package:kazandirio/provider/user_provider.dart';
import 'package:kazandirio/sign_login_pages/login_page.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  AuthProvider _authProvider;
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).currentUser();
    final _productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _productProvider.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xfff1f1f1),
      body: Stack(
        children: [
          Consumer<ProductProvider>(builder: (context, snapshot, w) {
            if (snapshot.products != null) {
              return CarouselSlider.builder(
                itemCount: snapshot.products.length,
                itemBuilder: (BuildContext context, int itemIndex) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 0),
                              spreadRadius: 0.5,
                              blurRadius: 3,
                            )
                          ],
                          color: Colors.white,
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: size.height * 0.2),
                        width: size.width,
                        height: size.height,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              photo(size, itemIndex,
                                  snapshot.products[itemIndex].url),
                              title(size, snapshot.products[itemIndex].name),
                              rate(size, snapshot.products[itemIndex].rating),
                              prices(size, snapshot.products[itemIndex].price,
                                  snapshot.products[itemIndex].countPrice),
                            ],
                          ),
                        ),
                      ),
                      showProductDetail(size, context, itemIndex,
                          snapshot.products[itemIndex]),
                    ],
                  );
                },
                options: CarouselOptions(
                  height: size.height,
                  autoPlay: false,
                  enlargeCenterPage: true,
                  initialPage: 2,
                ),
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          }),
          if (_authProvider.buUser != null)
            Positioned(
              right: size.width * 0.1,
              top: size.height * 0.06,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (context) => PersonPage()));
                },
                child: CircleAvatar(
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  backgroundColor: Color(0xffd4a244),
                ),
              ),
            )
          else
            Positioned(
              right: size.width * 0.1,
              top: size.height * 0.06,
              child: FloatingActionButton.extended(
                backgroundColor: Color(0xffd4a244),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(
                        context: context,
                      ),
                    ),
                  );
                },
                label: Text(
                  "Giriş Yap",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  photo(Size size, int itemIndex, url) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      child: CachedNetworkImage(
        imageUrl: url,
        width: size.width * 0.8,
        height: size.height * 0.46,
        fit: BoxFit.cover,
      ),
    );
  }

  Container title(Size size, name) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.01),
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  RatingBarIndicator rate(Size size, rating) {
    return RatingBarIndicator(
      rating: rating,
      itemCount: 5,
      itemSize: size.height * 0.02,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Color(0xffd4a244),
      ),
    );
  }

  Container prices(Size size, price, countPrice) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.005),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: size.width * 0.02),
            child: Text('$price.00 TL',
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                )),
          ),
          Text(
            "$countPrice.00 TL",
            style: TextStyle(
                color: Color(0xffd4a244),
                fontWeight: FontWeight.bold,
                fontSize: 24),
          ),
        ],
      ),
    );
  }

  Positioned showProductDetail(
      Size size, BuildContext context, int itemIndex, ProductModel data) {
    return Positioned(
      bottom: size.height * 0.166,
      right: size.width * 0.16,
      //transitionDuration: Duration(seconds: 1),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(
                id: data.id,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(size.height * 0.012),
          decoration: BoxDecoration(
            color: Color(0xffd4a244),
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            "Ürün Bilgilerini Görüntüle",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
