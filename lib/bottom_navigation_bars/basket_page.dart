import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazandirio/complete_shopping/complete_shopping.dart';
import 'package:kazandirio/models/product_model.dart';
import 'package:kazandirio/product_detail/product_detail_page.dart';
import 'package:kazandirio/provider/user_provider.dart';
import 'package:provider/provider.dart';

class BasketPage extends StatefulWidget {
  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  int sayi = 1;

  Stream getMyBasket;

  @override
  void initState() {
    super.initState();
    final _userModel = Provider.of<UserProvider>(context, listen: false);
    getMyBasket = _userModel.getMyBasket(_userModel.user);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          physics: NeverScrollableScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                title: Text(
                  "Sepetim",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                pinned: false,
                floating: false,
                //forceElevated: innerBoxIsScrolled,
              ),
            ];
          },
          body: SafeArea(
            child: Stack(
              children: [
                StreamBuilder<List<ProductModel>>(
                    stream: getMyBasket,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          padding: EdgeInsets.only(bottom: size.height * 0.09),
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04),
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      bottom: size.height * 0.04),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          photo(size, snapshot.data[index].url),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    name(size,
                                                        snapshot.data[index]),
                                                    deleteButton(size,
                                                        snapshot.data[index])
                                                  ],
                                                ),
                                                price(
                                                  size,
                                                  snapshot.data[index].price,
                                                  snapshot.data[index].piece,
                                                ),
                                                countPrice(
                                                  size,
                                                  snapshot
                                                      .data[index].countPrice,
                                                  snapshot.data[index].piece,
                                                ),
                                                count(
                                                  size,
                                                  snapshot.data[index].piece,
                                                  snapshot.data[index].id,
                                                  snapshot
                                                      .data[index].countPrice,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        );
                      } else
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    }),
                finishShopping(size, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  photo(Size size, url) {
    return Container(
      margin: EdgeInsets.only(right: size.width * 0.04),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: CachedNetworkImage(
          imageUrl: url,
          height: size.height * 0.2,
          width: size.width * 0.3,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  name(Size size, ProductModel data) {
    return GestureDetector(
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
        width: size.width * 0.38,
        child: Text(
          data.name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  deleteButton(Size size, ProductModel data) {
    final _userModel = Provider.of<UserProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Text(
                    "Silmek istediğinize emin misiniz?",
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          await _userModel.deleteProduct(data, _userModel.user);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Sil",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        )),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "Vazgeç",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )),
                  ],
                ));
      },
      child: Image.asset(
        "assets/images/delete.png",
        width: size.width * 0.07,
        fit: BoxFit.contain,
      ),
    );
  }

  Container price(Size size, price, piece) {
    return Container(
      margin: EdgeInsets.only(
          top: size.height * 0.008, bottom: size.height * 0.008),
      child: Text(
        "${price * piece}.00 TL",
        style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            decoration: TextDecoration.lineThrough),
      ),
    );
  }

  Text countPrice(Size size, countPrice, piece) {
    return Text(
      "${countPrice * piece}.00 TL",
      style: TextStyle(
          fontSize: 20, color: Color(0xffd4a244), fontWeight: FontWeight.bold),
    );
  }

  count(Size size, piece, id, countPrice) {
    final _userModel = Provider.of<UserProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            await _userModel
                .decrease(piece, id, _userModel.user.userID, countPrice)
                .then((value) {
              if (value != UserStatus.SUCCESS) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Ürün artırılırken sorun oluştu")));
              }
            });
          },
          child: Icon(
            Icons.remove_circle,
            size: 30,
            color: Colors.grey,
          ),
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.02),
            child: Text(
              piece.toString(),
              style: TextStyle(fontSize: 24),
            )),
        GestureDetector(
          onTap: () async {
            await _userModel
                .increase(piece, id, _userModel.user.userID, countPrice,
                    _userModel.user)
                .then((value) {
              if (value != UserStatus.SUCCESS) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Ürün artırılırken sorun oluştu")));
              }
            });
          },
          child: Icon(
            Icons.add_circle,
            size: 30,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Positioned finishShopping(Size size, BuildContext context) {
    final _userModel = Provider.of<UserProvider>(context, listen: false);
    return Positioned(
      bottom: 0,
      child: StreamBuilder(
        stream: _userModel.getTotalPrice(_userModel),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: size.height * 0.1,
              decoration: BoxDecoration(color: Color(0xfff8f8f8), boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(0, 3),
                ),
              ]),
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              width: size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Ödenecek Tutar",
                      ),
                      Container(
                        margin: EdgeInsets.only(top: size.height * 0.01),
                        child: Text(
                          snapshot.data.basket.toString() + ".00 TL",
                          style: TextStyle(
                            color: Color(0xffd4a244),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => CompleteShopping(),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: size.height * 0.06,
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.022),
                      decoration: BoxDecoration(
                        color: Color(0xffd4a244),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Alışverişi Tamamla",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else
            return Container();
        },
      ),
    );
  }

  showdialog(Size size, piece, id) {
    //final _userModel = Provider.of<UserModel>(context, listen: false);
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content: Builder(
                builder: (context) => Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          //await _userModel.decrease(piece, id, _userModel.user.userID);
                        },
                        child: Icon(
                          Icons.remove_circle,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02),
                          child: Text(
                            piece.toString(),
                            style: TextStyle(fontSize: 24),
                          )),
                      GestureDetector(
                        onTap: () async {
                          //await _userModel.increase(piece, id, _userModel.user.userID);
                        },
                        child: Icon(
                          Icons.add_circle,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
