import 'package:flutter/material.dart';
import 'package:kazandirio/ortak_butonlar/ekran_dokunma_klavye_kapanma.dart';
import 'package:kazandirio/provider/auth_provider.dart';
import 'package:kazandirio/provider/user_provider.dart';
import 'package:kazandirio/utils/exception_handlers/auth_exception_handler.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  String oldPassword;
  String newPassword;
  String newPassword1;
  bool checkPassword = true;

  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserProvider>(context);
    Size size = MediaQuery.of(context).size;
    return KlavyeninKapanmasi(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              "Şifre Değişikliği",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
          ),
          body: Stack(
            children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: size.height * 0.03,
                        left: size.width * 0.05,
                        right: size.width * 0.05),
                    height: size.height * 0.8,
                    width: size.width,
                    child: Column(
                      children: [
                        //photo(),
                        oldPasswordPart(),
                        SizedBox(
                          height: 20,
                        ),
                        password(),
                        SizedBox(
                          height: 20,
                        ),
                        passwordAgain(),
                        SizedBox(
                          height: 20,
                        ),
                        sendPasswordButton(size),
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
      ),
    );
  }

  oldPasswordPart() {
    return TextFormField(
      controller: passwordController,
      onSaved: (value) {
        oldPassword = value;
      },
      obscureText: false,
      cursorColor: Colors.grey.shade400,
      autocorrect: true,
      decoration: InputDecoration(
        hintText: "Mevcut Şifreniz",
        contentPadding: EdgeInsets.all(10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade700, width: 0.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  TextFormField password() {
    return TextFormField(
      obscureText: true,
      validator: (value) {
        if (value.isEmpty) {
          return "Bu alanı boş bırakamazsınız";
        } else if (value.length < 6) {
          return "Minimum 6 karakter giriniz";
        } else
          return null;
      },
      onSaved: (value) {
        newPassword = value;
      },
      cursorColor: Colors.grey.shade400,
      decoration: InputDecoration(
        hintText: "Yeni Şifre",
        contentPadding: EdgeInsets.all(10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade700, width: 0.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  TextFormField passwordAgain() {
    return TextFormField(
      obscureText: true,
      validator: (value) {
        if (value.isEmpty) {
          return "Bu alanı boş bırakamazsınız";
        } else if (value.length < 6) {
          return "Minimum 6 karakter giriniz";
        } else
          return null;
      },
      onSaved: (value) {
        newPassword1 = value;
      },
      autocorrect: true,
      cursorColor: Colors.grey.shade400,
      decoration: InputDecoration(
        hintText: "Yeni Şifre Tekrar",
        contentPadding: EdgeInsets.all(10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade700, width: 0.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Image photo() => Image.asset("assets/images/sendEmail.png");

  void updateUserPassword(String newPassword) {}

  sendPasswordButton(Size size) {
    final _authProvider = Provider.of<AuthProvider>(context);
    return GestureDetector(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          if (newPassword != newPassword1) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Şifreler Eşleşmiyor")));
          } else {
            checkPassword = await _authProvider
                .validateCurrentPassword(
                    oldPassword, newPassword, _authProvider.buUser)
                .then((value) {
              if (value != AuthResultStatus.successful) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Şifre güncellenirken sorun oluştu $value")));
                return null;
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Şifreniz başarıyla güncellendi")));
                Navigator.of(context).pop();
                return null;
              }
            });
            setState(() {});
          }
        } else {}
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xffd4a244),
          borderRadius: BorderRadius.circular(8),
        ),
        width: size.width,
        height: size.height * 0.07,
        child: Text(
          "Şifremi Değiştir",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
