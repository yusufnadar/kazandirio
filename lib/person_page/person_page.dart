import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazandirio/bottom_navigation_bars/bottomNavigationBars.dart';
import 'package:kazandirio/person_page/about_page.dart';
import 'package:kazandirio/person_page/address_page.dart';
import 'package:kazandirio/person_page/change_password_page.dart';
import 'package:kazandirio/provider/auth_provider.dart';
import 'package:kazandirio/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonPage extends StatefulWidget {
  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  //String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  bool cikisYapildi = false;

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff212121),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                aboutPerson(size),
                Container(
                  margin: EdgeInsets.only(
                      top: size.height * 0.04, left: size.width * 0.08),
                  child: Column(
                    children: [
                      address(context, size),
                      changePassword(context, size),
                      aboutUs(context, size),
                      contact(size),
                      logout(_authProvider, size),
                      instaAndFace(size)
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  color: Color(0xff505050),
                  width: size.width,
                  height: size.height * 0.07,
                  alignment: Alignment.center,
                  child: Text(
                    "Kapat",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Consumer<AuthProvider>(
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
            ),
          ],
        ),
      ),
    );
  }

  Container aboutPerson(Size size) {
    final _userModel = Provider.of<UserProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.02),
      width: size.width,
      height: size.height * 0.16,
      color: Color(0xff191919),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: size.width * 0.04),
            child: CircleAvatar(
              radius: 40,
              child: Icon(
                Icons.person,
                size: 40,
              ),
            ),
          ),
          if (cikisYapildi == false && _userModel.user != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: size.height * 0.01),
                  child: Text(
                    _userModel.user.userName,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Text(
                  _userModel.user.email,
                  style: TextStyle(color: Colors.white54, fontSize: 15),
                )
              ],
            )
          else
            Container(),
        ],
      ),
    );
  }

  GestureDetector address(BuildContext context, Size size) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddressPage()));
      },
      child: Row(
        children: [
          Image.asset(
            "assets/images/konum1.png",
            width: size.width * 0.05,
            fit: BoxFit.contain,
            color: Colors.white,
          ),
          Container(
            margin: EdgeInsets.only(left: size.width * 0.03),
            child: Text(
              "Adreslerim",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector changePassword(BuildContext context, Size size) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ChangePassword()));
      },
      child: Container(
        margin: EdgeInsets.only(top: size.height * 0.04),
        child: Row(
          children: [
            Image.asset(
              "assets/images/password.png",
              width: size.width * 0.05,
              fit: BoxFit.contain,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(left: size.width * 0.03),
              child: Text(
                "Şifre Değişikliği",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector aboutUs(BuildContext context, Size size) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => About()));
      },
      child: Container(
        margin: EdgeInsets.only(top: size.height * 0.04),
        child: Row(
          children: [
            Image.asset(
              "assets/images/about.png",
              width: size.width * 0.05,
              fit: BoxFit.contain,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(left: size.width * 0.03),
              child: Text(
                "Hakkımızda",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector contact(Size size) {
    return GestureDetector(
      onTap: () => launch(
          'mailto:gezi_arkadasim@outlook.com?subject=Selam%20Yusuf&body=%20'),
      child: Container(
        margin: EdgeInsets.only(top: size.height * 0.04),
        child: Row(
          children: [
            Image.asset(
              "assets/images/contact.png",
              width: size.width * 0.05,
              fit: BoxFit.contain,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(left: size.width * 0.03),
              child: Text(
                "İletişim",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector logout(AuthProvider authProvider, Size size) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          cikisYapildi = true;
        });
        await authProvider.signOut().then((value) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BottomNavigationBars(
                currentTab1: 0,
              ),
            ),
          );
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: size.height * 0.04),
        child: Row(
          children: [
            Image.asset(
              "assets/images/logout.png",
              width: size.width * 0.05,
              fit: BoxFit.contain,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(left: size.width * 0.03),
              child: Text(
                "Çıkış Yap",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container instaAndFace(Size size) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.08),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => launch('https://www.instagram.com/'),
            child: Container(
                margin: EdgeInsets.only(right: size.width * 0.04),
                child: Image.asset("assets/images/instagram1.png",
                    width: size.width * 0.07, fit: BoxFit.contain)),
          ),
          GestureDetector(
            onTap: () => launch("https://www.facebook.com/"),
            child: Image.asset("assets/images/facebook.png",
                width: size.width * 0.07, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}
