import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                backgroundColor: Colors.white,
                title: Text(
                  "Siparişlerim",
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
            child: Container(
              height: size.height,
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return SafeArea(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.017,
                            horizontal: size.width * 0.03),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(width: 0.5, color: Colors.grey)),
                        margin: EdgeInsets.only(bottom: size.height * 0.04),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: size.width * 0.05),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  "assets/images/photo3.jpg",
                                  height: size.height * 0.15,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: size.height * 0.15,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "15 Şubat 2021",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return alertDialog(size);
                                                });
                                          },
                                          child: Text("Detaylar"),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          bottom: size.height * 0.05),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Toplam : ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "120.95 TL",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Sipariş Durumu : ",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                        Text(
                                          "Kargoda",
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 12),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  alertDialog(Size size) {
    return AlertDialog(
      content: Builder(
        builder: (context) => Container(
          height: size.height * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bambu Kapaklı Cam Yağ 900 ML",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    child: Text("352.38 TL"),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: size.width * 0.02),
                      child: Text(
                        "Sipariş Numarası",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "192 168 123",
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: size.height * 0.04, bottom: size.height * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: size.width * 0.02),
                      child: Text(
                        "Kargo Takip Numarası",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "KP03111173816",
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: size.height * 0.07,
                width: size.width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6)),
                child: Text(
                  "Kargom Nerede ? ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: size.width * 0.38,
                                        child: Text(
                                          "Bambu Kapaklı Cam Yağ 900 ML",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text("352.38 TL"),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    child: Text("Sipariş Numarası"),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: size.height * 0.003),
                                    child: Text(
                                      "192 168 123",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: size.height * 0.003),
                                    child: Text(
                                      "Kargo Takip Numarası",
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "KP03111173816",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Text(
                                          "Kargom Nerede ? ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )

 */
