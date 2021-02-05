import 'package:flutter/material.dart';
import 'package:kazandirio/provider/auth_provider.dart';
import 'package:kazandirio/utils/exception_handlers/auth_exception_handler.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  final BuildContext context;

  ForgotPasswordPage({Key key, this.context}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String email;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "Şifremi Unuttum",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Column(
                    children: [
                      photo(size),
                      forgotPasswordText(),
                      enterEmail(size),
                      forgotPasswordButton(size)
                    ],
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

  GestureDetector forgotPasswordButton(Size size) {
    final _authProvider = Provider.of<AuthProvider>(context);
    return GestureDetector(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          await _authProvider.forgotPassword(email).then((value) {
            if (value != AuthResultStatus.successful) {
              final errorMsg =
                  AuthExceptionHandler.generateExceptionMessage(value);
              showAlertDialog(errorMsg);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Şifre sıfırlama linki gönderilmiştir")));
            }
          });
        }
      },
      child: Container(
        width: size.width,
        height: size.height * 0.07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Color(0xffd4a244),
        ),
        alignment: Alignment.center,
        child: Text(
          "Şifremi Sıfırla",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Container enterEmail(Size size) {
    return Container(
      margin:
          EdgeInsets.only(bottom: size.height * 0.03, top: size.height * 0.03),
      child: TextFormField(
        onSaved: (value) {
          email = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return "Lütfen bu alanı doldurunuz";
          } else if (value.length < 4) {
            return "Lütfen en az 4 karakter giriniz";
          } else
            return null;
        },
        decoration: new InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: size.width * 0.03, vertical: size.height * 0.021),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffbdbdbd), width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffbdbdbd), width: 1.5),
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffbdbdbd), width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffbdbdbd), width: 1.5),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffbdbdbd), width: 1.5),
            borderRadius: BorderRadius.circular(5),
          ),
          hintText: "Şifre",
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
      ),
    );
  }

  Container forgotPasswordText() {
    return Container(
      child: Text(
        "Şifrenizi mi unuttunuz? Endişelenmeyin. E-Postanızı girdikten sonra size yanıt göndereceğiz.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Image photo(Size size) {
    return Image.asset(
      "assets/images/forgot_password.png",
      width: size.width * 0.5,
      fit: BoxFit.contain,
    );
  }
}
