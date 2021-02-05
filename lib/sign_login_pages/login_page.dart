import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazandirio/bottom_navigation_bars/products_page.dart';
import 'package:kazandirio/ortak_butonlar/ekran_dokunma_klavye_kapanma.dart';
import 'package:kazandirio/ortak_butonlar/text_area.dart';
import 'package:kazandirio/provider/auth_provider.dart';
import 'package:kazandirio/sign_login_pages/forgot_password_page.dart';
import 'package:kazandirio/sign_login_pages/sign_up_page.dart';
import 'package:kazandirio/utils/exception_handlers/auth_exception_handler.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final BuildContext context;

  LoginPage({this.context});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email, sifre;

  bool _obsecureText = true;
  bool hatali = false;

  void toogle() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _userModel = Provider.of<AuthProvider>(context);
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
              child: Container(
                height: size.height,
                width: size.width,
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
    return Container(
      padding: EdgeInsets.only(
          top: size.height * 0.02,
          right: size.height * 0.02,
          left: size.height * 0.02),
      margin: EdgeInsets.only(
        right: size.width * 0.05,
        left: size.width * 0.05,
        top: size.height * 0.3,
      ),
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
      height: hatali == false ? size.height * 0.52 : size.height * 0.58,
      alignment: Alignment.center,
      child: Column(
        children: [
          enterEmail(size),
          enterpassword(size),
          forgotPassword(context, size),
          loginButton(_userModel, context, size),
          Container(
            margin: EdgeInsets.only(
                top: size.height * 0.03, bottom: size.height * 0.06),
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                loginWithApple(size),
                loginWithGoogle(_userModel, context, size)
              ],
            ),
          ),
          signUp(size, context)
        ],
      ),
    );
  }

  enterEmail(Size size) {
    return TextArea(
      obsecureText: false,
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
    );
  }

  enterpassword(Size size) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.03),
      child: TextArea(
        onSaved: (value) {
          sifre = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return "Lütfen bu alanı doldurunuz";
          } else if (value.length < 4) {
            return "Lütfen en az 4 karakter giriniz";
          } else
            return null;
        },
        hintText: "Şifre",
        obsecureText: _obsecureText,
        maxLines: 1,
      ),
    );
  }

  GestureDetector forgotPassword(BuildContext context, Size size) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ForgotPasswordPage(context: context)));
      },
      child: Container(
        margin: EdgeInsets.only(
            bottom: size.height * 0.02, top: size.height * 0.01),
        alignment: Alignment.centerRight,
        child: Text(
          "Şifremi Unuttum",
          style: TextStyle(
              fontSize: 14,
              color: Color(0xffd4a244),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  loginButton(AuthProvider authProvider, BuildContext context, Size size) {
    return GestureDetector(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          await authProvider
              .signInWithEmailandPassword(email: email, password: sifre)
              .then((value) {
            if (value != AuthResultStatus.successful) {
              if (authProvider.verifyState == VerifyState.WAITING_FOR_VERIFY) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Emailinize gelen kodu onaylayınız")));
              } else {
                final errorMsg =
                    AuthExceptionHandler.generateExceptionMessage(value);
                showAlertDialog(errorMsg);
              }
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductPage(),
              ));
            }
          });
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
          "Giriş Yap",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Container loginWithApple(Size size) {
    return Container(
      width: size.width * 0.4,
      height: size.height * 0.06,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            "assets/images/apple1.png",
            width: size.width * 0.05,
            fit: BoxFit.contain,
            color: Colors.white,
          ),
          Text(
            "Apple ile Giriş Yap",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  loginWithGoogle(AuthProvider _userModel, BuildContext context, Size size) {
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

  Container signUp(Size size, BuildContext context) {
    return Container(
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Üye değil misin?",
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SignUpPage(
                        context: context,
                      )));
            },
            child: Text(
              " Üye ol",
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
