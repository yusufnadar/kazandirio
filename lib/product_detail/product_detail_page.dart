import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kazandirio/fast_buy/fast_buy.dart';
import 'package:kazandirio/models/product_model.dart';
import 'package:kazandirio/provider/product_provider.dart';
import 'package:kazandirio/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final String id;

  ProductDetailPage({this.id});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    super.initState();
    final _productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    _productProvider.getProductWithID(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //timeDilation = 2.0;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Consumer<ProductProvider>(builder: (context, snapshot, w) {
                if (snapshot.oneProduct != null) {
                  return Column(
                    children: [
                      Stack(
                        children: [
                          photo(size, snapshot.oneProduct.url),
                          backIcon(size, context),
                        ],
                      ),
                      title(size, snapshot.oneProduct.name),
                      rate(size, snapshot.oneProduct.rating),
                      prices(size, snapshot.oneProduct.price,
                          snapshot.oneProduct.countPrice),
                      description(size, snapshot.oneProduct.description),
                      Container(
                        margin: EdgeInsets.only(
                            top: size.height * 0.02,
                            bottom: size.height * 0.02),
                        width: size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            addBasket(size, snapshot.oneProduct),
                            fastBuy(size, snapshot.oneProduct),
                          ],
                        ),
                      )
                    ],
                  );
                } else
                  return Container(
                    width: size.width,
                    height: size.height,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
              }),
              Consumer<UserProvider>(
                builder: (_, model, child) {
                  return model.isLoading
                      ? Container(
                          width: size.width,
                          height: size.height,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                          color: Colors.white.withOpacity(0.8),
                        )
                      : Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  /**/

  photo(Size size, url) {
    return Container(
      width: size.width,
      height: size.height * 0.35,
      child: PageView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: url,
              width: size.width,
              height: size.height * 0.35,
              fit: BoxFit.cover,
            );
          }),
    );
  }

  Positioned backIcon(Size size, BuildContext context) {
    return Positioned(
        top: size.height * 0.03,
        right: size.width * 0.07,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: Color(0xffd4a244),
                  borderRadius: BorderRadius.circular(20)),
              child: Icon(
                Icons.close,
                color: Colors.white,
              )),
        ));
  }

  Container title(Size size, name) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.01),
      child: Text(
        name,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  RatingBarIndicator rate(Size size, rating) {
    return RatingBarIndicator(
      rating: rating,
      itemCount: 5,
      itemSize: 15.0,
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
                    color: Color(0xff616161))),
          ),
          Text(
            "$countPrice.00 TL",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ],
      ),
    );
  }

  Container description(Size size, description) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.007),
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Text(
        description,
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  addBasket(Size size, ProductModel product) {
    final _userModel = Provider.of<UserProvider>(context, listen: false);
    return GestureDetector(
      onTap: () async {
        await _userModel
            .addBasket(product, _userModel.user, context)
            .then((value) {
          if (value != UserStatus.SUCCESS) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Ürün eklenirken bir sorun oluştu $value"),
              duration: Duration(seconds: 1),
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Ürün sepetinize başarıyla eklendi"),
              duration: Duration(seconds: 1),
            ));
          }
        });
      },
      child: Container(
        child: Text(
          "Sepete Ekle",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        margin: EdgeInsets.only(right: size.width * 0.1),
        padding: EdgeInsets.symmetric(
            vertical: size.height * 0.008, horizontal: size.width * 0.024),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13), color: Color(0xffd4a244)),
      ),
    );
  }

  fastBuy(Size size, ProductModel oneProduct) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FastBuy(
              gelenUrun: oneProduct,
            ),
          ),
        );
      },
      child: Container(
        child: Text(
          "Hızlı Sipariş",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        padding: EdgeInsets.symmetric(
            vertical: size.height * 0.008, horizontal: size.width * 0.024),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13), color: Color(0xffd4a244)),
      ),
    );
  }
}
