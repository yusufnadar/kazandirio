import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazandirio/fast_buy/fast_buy_1.dart';
import 'package:kazandirio/models/address_model.dart';
import 'package:kazandirio/models/product_model.dart';
import 'package:kazandirio/provider/user_provider.dart';
import 'package:provider/provider.dart';

class FastBuy extends StatefulWidget {
  ProductModel gelenUrun;

  FastBuy({this.gelenUrun});

  @override
  _FastBuyState createState() => _FastBuyState();
}

class _FastBuyState extends State<FastBuy> {
  int _currentIndex;
  int _currentIndex1;
  String isim = "";

  @override
  void initState() {
    super.initState();
    var _userProvider = Provider.of<UserProvider>(context, listen: false);
    _userProvider.getAddress1(_userProvider.user);
    _userProvider.getBillAddress1(_userProvider.user);
    _userProvider.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text("Güvenli Alışveriş"),
      ),
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, snapshot, w) {
            if (snapshot.faturaAdreslerim != null) {
              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        firstAddressTitle(size),
                        firstAddresses(size, snapshot.teslimatAdreslerim),
                        secondAddressTitle(size),
                        secondAddresses(size, snapshot.faturaAdreslerim),
                        name(size),
                        kdv(size),
                        shippingFee(size),
                      ],
                    ),
                  ),
                  payButton(size, context, snapshot.teslimatAdreslerim,
                      snapshot.faturaAdreslerim),
                ],
              );
            } else
              return Container(
                width: size.width,
                height: size.height,
                child: Center(child: CircularProgressIndicator()),
              );
          },
        ),
      ),
    );
  }

  Container firstAddressTitle(Size size) {
    return Container(
      margin: EdgeInsets.only(left: size.width * 0.06),
      child: Text(
        "Teslimat Adresi",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  firstAddresses(Size size, List<AddressModel> data) {
    return Container(
      margin: EdgeInsets.only(
          top: size.height * 0.015, bottom: size.height * 0.025),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            data.length,
            (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = index;
                    isim = data[_currentIndex].name;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(
                      right: size.width * 0.03,
                      left: index == 0 ? size.width * 0.06 : 0),
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.grey.shade100
                        : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0),
                        spreadRadius: 1,
                        blurRadius: 5,
                        color: Colors.grey.shade200,
                      ),
                    ],
                    border: Border.all(
                      width: 0.2,
                      color: Colors.grey,
                    ),
                  ),
                  height: size.height * 0.17,
                  width: size.width * 0.43,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: size.height * 0.01),
                        child: Text(
                          data[index].addressName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: size.height * 0.02,
                              fontFamily: "PoppinsMedium"),
                        ),
                      ),
                      Text(
                        data[index].address.length > 50
                            ? "${data[index].address.substring(0, 50)} .. "
                            : data[index].address,
                        style: TextStyle(
                          fontSize: size.height * 0.017,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Container secondAddressTitle(Size size) {
    return Container(
      margin: EdgeInsets.only(left: size.width * 0.06),
      child: Text(
        "Fatura Adresi",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  secondAddresses(Size size, data) {
    return Container(
      margin:
          EdgeInsets.only(top: size.height * 0.015, bottom: size.height * 0.04),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            data.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex1 = index;
                });
              },
              child: Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(
                    right: size.width * 0.03,
                    left: index == 0 ? size.width * 0.06 : 0),
                decoration: BoxDecoration(
                  color: _currentIndex1 == index
                      ? Colors.grey.shade100
                      : Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      spreadRadius: 1,
                      blurRadius: 5,
                      color: Colors.grey.shade200,
                    ),
                  ],
                  border: Border.all(
                    width: 0.2,
                    color: Colors.grey,
                  ),
                ),
                height: size.height * 0.17,
                width: size.width * 0.43,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: size.height * 0.01),
                      child: Text(
                        data[index].addressName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: size.height * 0.02,
                            fontFamily: "PoppinsMedium"),
                      ),
                    ),
                    Text(
                      data[index].address.length > 50
                          ? "${data[index].address.substring(0, 50)} .. "
                          : data[index].address,
                      style: TextStyle(
                        fontSize: size.height * 0.017,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container name(Size size) {
    return Container(
      margin: EdgeInsets.only(left: size.width * 0.06),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Alıcı Adı: "),
          Text(
            isim,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Container kdv(Size size) {
    return Container(
      margin: EdgeInsets.only(left: size.width * 0.06, top: size.height * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("KDV: "),
          Text(
            "19.08 TL",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Container shippingFee(Size size) {
    return Container(
      margin: EdgeInsets.only(left: size.width * 0.06, top: size.height * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Kargo Ücreti: "),
          Text(
            "15.45 TL",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Positioned payButton(Size size, BuildContext context, List<AddressModel> data,
      List<AddressModel> data1) {
    final _userProvider = Provider.of<UserProvider>(context, listen: false);
    return Positioned(
      bottom: 0,
      child: Container(
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
                    widget.gelenUrun.countPrice.toString() + ".00 TL",
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
                    builder: (context) => FastBuy1(
                      gelenUrun: widget.gelenUrun,
                      address: data[_currentIndex],
                      billAddress: data1[_currentIndex1],
                    ),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: size.height * 0.06,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.022),
                decoration: BoxDecoration(
                  color: Color(0xffd4a244),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Ödemeye Geç",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
