import 'package:flutter/material.dart';
import 'package:kazandirio/bottom_navigation_bars/products_page.dart';
import 'package:kazandirio/ortak_butonlar/ekran_dokunma_klavye_kapanma.dart';
import 'package:kazandirio/ortak_butonlar/text_area.dart';
import 'package:kazandirio/provider/auth_provider.dart';
import 'package:kazandirio/sign_login_pages/login_page.dart';
import 'package:kazandirio/utils/exception_handlers/auth_exception_handler.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  final BuildContext context;

  SignUpPage({this.context});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String email, sifre, sifreTekrar, adSoyad;
  bool _obsecureText = true;
  bool _obsecureText1 = true;
  bool hatali = false;

  void toogle() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  void toogle1() {
    setState(() {
      _obsecureText1 = !_obsecureText1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<AuthProvider>(context);
    Size size = MediaQuery.of(context).size;
    return KlavyeninKapanmasi(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Stack(
                children: [
                  Container(
                    height: size.height * 0.45,
                    color: Color(0xff192a6c),
                  ),
                  photo(size),
                  whiteBox(size, context, _userModel),
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
          ),
        ),
      ),
    );
  }

  Positioned photo(Size size) {
    return Positioned(
      top: size.height * 0.015,
      left: size.width * 0.24,
      child: Image.asset(
        "assets/images/photo1.png",
        width: size.width * 0.5,
        fit: BoxFit.contain,
      ),
    );
  }

  whiteBox(Size size, BuildContext context, AuthProvider _userModel) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: size.height * 0.012),
        child: Container(
          padding: EdgeInsets.only(
              top: size.height * 0.02,
              right: size.height * 0.02,
              left: size.height * 0.02),
          margin: EdgeInsets.only(
              right: size.width * 0.05,
              left: size.width * 0.05,
              top: size.height * 0.26),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          height: hatali == false ? size.height * 0.62 : size.height * 0.76,
          alignment: Alignment.center,
          width: size.width,
          child: Column(
            children: [
              enterName(size),
              enterEmail(size),
              enterPassword(size),
              enterPasswordAgain(size),
              signUp(context, _userModel, size),
              Container(
                margin: EdgeInsets.only(
                    top: size.height * 0.03, bottom: size.height * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.4,
                      height: size.height * 0.06,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: signUpWithApple(size),
                    ),
                    signUpWithGoogle(_userModel, context, size)
                  ],
                ),
              ),
              login(size, context)
            ],
          ),
        ),
      ),
    );
  }

  enterName(Size size) {
    return TextArea(
      onSaved: (value) {
        adSoyad = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Lütfen bu alanı doldurunuz";
        } else if (value.length < 3) {
          return "Lütfen en az 3 karakter giriniz";
        } else
          return null;
      },
      hintText: "Ad Soyad",
      obsecureText: false,
    );
  }

  enterEmail(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.03),
      child: TextArea(
        onSaved: (value) {
          email = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return "Lütfen bu alanı doldurunuz";
          } else if (!value.contains("@")) {
            return "Lütfen geçerli bir email giriniz";
          } else
            return null;
        },
        hintText: "E-Posta",
        obsecureText: false,
      ),
    );
  }

  enterPassword(Size size) {
    return TextArea(
      maxLines: 1,
      onSaved: (value) {
        sifre = value;
      },
      obsecureText: _obsecureText,
      validator: (value) {
        if (value.isEmpty) {
          return "Lütfen bu alanı doldurunuz";
        } else if (value.length < 4) {
          return "Lütfen en az 4 karakter giriniz";
        } else
          return null;
      },
      suffixIcon: GestureDetector(
          onTap: () {
            toogle();
          },
          child: Icon(Icons.lock_open_outlined)),
      hintText: "Şifre",
    );
  }

  enterPasswordAgain(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.03),
      child: TextArea(
        maxLines: 1,
        onSaved: (value) {
          sifreTekrar = value;
        },
        obsecureText: _obsecureText1,
        validator: (value) {
          if (value.isEmpty) {
            return "Lütfen bu alanı doldurunuz";
          } else if (value.length < 4) {
            return "Lütfen en az 4 karakter giriniz";
          } else
            return null;
        },
        suffixIcon: GestureDetector(
            onTap: () {
              toogle1();
            },
            child: Icon(Icons.lock_open_outlined)),
        hintText: "Şifre Tekrar",
      ),
    );
  }

  signUp(BuildContext context, AuthProvider _authProvider, Size size) {
    return GestureDetector(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          if (sifreTekrar != sifre) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Şifreleriniz Eşleşmiyor"),
              duration: Duration(seconds: 1),
            ));
          } else {
            await _authProvider
                .signUp(name: adSoyad, email: email, password: sifre)
                .then((value) {
              if (value != AuthResultStatus.successful) {
                final errorMsg =
                    AuthExceptionHandler.generateExceptionMessage(value);
                showAlertDialog(errorMsg);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Lütfen mailinize gelen kodu onaylayınız")));
                /*
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductPage(),
                ));
                 */
              }
            });
          }
        } else {}
      },
      child: Container(
        width: size.width,
        height: size.height * 0.06,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Color(0xffd4a244),
        ),
        alignment: Alignment.center,
        child: Text(
          "Üye Ol",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Row signUpWithApple(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          "assets/images/apple1.png",
          width: size.width * 0.05,
          fit: BoxFit.contain,
          color: Colors.white,
        ),
        Text(
          "Apple ile Üye Ol",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  signUpWithGoogle(AuthProvider _userModel, BuildContext context, Size size) {
    return GestureDetector(
      onTap: () async {
        await _userModel.loginWithGoogle().then((value) {
          if (value != AuthResultStatus.successful) {
            final errorMsg =
                AuthExceptionHandler.generateExceptionMessage(value);
            showAlertDialog(errorMsg);
          } else {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductPage(),
            ));
          }
        });
      },
      child: Image.asset(
        "assets/images/google1.png",
        width: size.width * 0.1,
        fit: BoxFit.contain,
      ),
    );
  }

  Container login(Size size, BuildContext context) {
    return Container(
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Üye misin?",
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoginPage(
                        context: context,
                      )));
            },
            child: Text(
              " Giriş Yap",
              style: TextStyle(
                  color: Color(0xffd4a244), fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  showAlertDialog(String error) {
    showDialog(
      context: widget.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(error),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Kapat",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ))
          ],
        );
      },
    );
  }
}
