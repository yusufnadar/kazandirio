import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:kazandirio/models/address_model.dart';
import 'package:kazandirio/models/product_model.dart';
import 'package:kazandirio/ortak_butonlar/ekran_dokunma_klavye_kapanma.dart';
import 'package:kazandirio/provider/user_provider.dart';
import 'package:provider/provider.dart';

class FastBuy1 extends StatefulWidget {
  final ProductModel gelenUrun;
  final AddressModel address;
  final AddressModel billAddress;

  FastBuy1({this.gelenUrun, this.address, this.billAddress});
  @override
  _FastBuy1State createState() => _FastBuy1State();
}

class _FastBuy1State extends State<FastBuy1> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: KlavyeninKapanmasi(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
              title: Text("Güvenli Alışveriş"),
            ),
            body: SingleChildScrollView(
              child: Container(
                width: size.width,
                height: size.height - size.height * 0.11,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        cardPhoto(),
                        cardDetails(),
                      ],
                    ),
                    payButton(size, context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  CreditCardWidget cardPhoto() {
    return CreditCardWidget(
      cardBgColor: Color(0xffd4a244),
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cardHolderName: cardHolderName,
      cvvCode: cvvCode,
      showBackView: isCvvFocused,
      obscureCardNumber: false,
      obscureCardCvv: false,
    );
  }

  Expanded cardDetails() {
    return Expanded(
      child: Column(
        children: [
          CreditCardForm(
            formKey: formKey,
            obscureCvv: false,
            obscureNumber: false,
            cardNumberDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Kart Numarası',
              hintText: '**** **** **** ****',
            ),
            expiryDateDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Son Kullanma Tarihi',
              hintText: 'Ay /Yıl',
            ),
            cvvCodeDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Güvenlik Kodu',
              hintText: 'CVC',
            ),
            cardHolderDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Kart Üzerindeki İsim',
            ),
            onCreditCardModelChange: onCreditCardModelChange,
          ),
        ],
      ),
    );
  }

  Positioned payButton(Size size, BuildContext context) {
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
                odemeyiGerceklestir();
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
                  "Ödemeyi Tamamla",
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

  void odemeyiGerceklestir() async {
    String card = cardNumber.replaceAll(RegExp(r"\s+"), "");

    final _userProvider = Provider.of<UserProvider>(context, listen: false);

    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);
    var url =
        'https://geziarkadasim.com/iyzico/iyzicoapi/controllers/create_payment.php';

    Map<String, String> headers = {
      "apiKey": "sandbox-hwY6RrdpAmuCpMka72kMWDhbCi4Oww3l",
      "secretKey": "sandbox-2D6uU0Q6WwAz6xpuvHmPwx4KVigFLc5r",
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final msg = jsonEncode({
      "price": widget.gelenUrun.countPrice,
      "paidPrice": widget.gelenUrun.countPrice,
      //"installment": "1",
      "cardHolderName": cardHolderName,
      "cardNumber": card,
      "expireMonth": expiryDate.substring(0, 2),
      "expireYear": expiryDate.substring(3, 5),
      "cvc": cvvCode.toString(),
      "buyerId": _userProvider.user.userID,
      "buyerName": widget.address.name,
      "buyerSurname": "s",
      "buyerIdentityNumber": "11111111111",
      "buyerCity": widget.address.city,
      "buyerCountry": "Turkey",
      "buyerEmail": _userProvider.user.email,
      "buyerGsmNumber": widget.address.phone,
      "buyerIp": "8.8.8.8",
      "buyerRegistrationAddress": widget.address.address,
      "shippingAddressContactName": "İsmail",
      "shippingAddressCity": "İstanbul",
      "shippingAddressCountry": "Turkey",
      "shippingAddressAddress": "739 Sk. No:17 K:3 İnönü Mh. Bornova",
      "billingAddressContactName": widget.billAddress.name,
      "billingAddressCity": widget.billAddress.city,
      "billingAddressCountry": "Turkey",
      "billingAddressAddress": widget.billAddress.address,
      "basketItems": [
        {
          "id": widget.gelenUrun.id,
          "price": widget.gelenUrun.countPrice,
          "name": widget.gelenUrun.name,
          "category1": "Empty",
          "category2": "Empty"
        },
      ]
    });

    http.Response response =
        await ioClient.post(url, headers: headers, body: msg);

    if (response.statusCode == 200) {
      print('İşlem Başarılı ${response.body}');
    } else {
      print('İşlem Başarısız ${response.body}');
    }
  }
}
