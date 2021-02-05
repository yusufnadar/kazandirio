import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazandirio/ortak_butonlar/ekran_dokunma_klavye_kapanma.dart';
import 'package:kazandirio/ortak_butonlar/text_area.dart';
import 'package:kazandirio/provider/user_provider.dart';
import 'package:provider/provider.dart';

class AddAddress extends StatefulWidget {
  int index;

  AddAddress({this.index});

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final _formKey = GlobalKey<FormState>();

  String name, phone, address, addressName, city;

  @override
  Widget build(BuildContext context) {
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
              widget.index == 0 ? "Teslimat Adresi Ekle" : "Fatura Adresi Ekle",
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(
                top: size.height * 0.02,
                right: size.width * 0.04,
                left: size.width * 0.04,
              ),
              child: Stack(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        namePart(size),
                        phonePart(size),
                        cityPart(size),
                        addressPart(size),
                        addressNamePart(size),
                        saveButton(size)
                      ],
                    ),
                  ),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  namePart(Size size) {
    return TextArea(
      validator: (value) {
        if (value.isEmpty) {
          return "Bu alanı doldurunuz";
        } else
          return null;
      },
      onSaved: (value) {
        name = value;
      },
      hintText: "Ad - Soyad",
      obsecureText: false,
    );
  }

  phonePart(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.03),
      child: TextArea(
        validator: (value) {
          if (value.isEmpty) {
            return "Bu alanı doldurunuz";
          } else if (value.length != 10) {
            return "Yalnızca 10 karakter giriniz";
          } else
            return null;
        },
        onSaved: (value) {
          phone = value;
        },
        hintText: "Telefon Numarası",
        obsecureText: false,
        keyboardType: TextInputType.phone,
      ),
    );
  }

  cityPart(Size size) {
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.03),
      child: TextArea(
        validator: (value) {
          if (value.isEmpty) {
            return "Bu alanı doldurunuz";
          } else
            return null;
        },
        onSaved: (value) {
          city = value;
        },
        hintText: "Şehir",
        obsecureText: false,
      ),
    );
  }

  addressPart(Size size) {
    return TextArea(
      maxLines: 4,
      validator: (value) {
        if (value.isEmpty) {
          return "Bu alanı doldurunuz";
        } else
          return null;
      },
      onSaved: (value) {
        address = value;
      },
      hintText: "Adres",
      obsecureText: false,
    );
  }

  addressNamePart(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.03),
      child: TextArea(
        validator: (value) {
          if (value.isEmpty) {
            return "Bu alanı doldurunuz";
          } else
            return null;
        },
        onSaved: (value) {
          addressName = value;
        },
        hintText: "Adres Adı",
        obsecureText: false,
      ),
    );
  }

  saveButton(Size size) {
    final _userModel = Provider.of<UserProvider>(context, listen: false);
    return GestureDetector(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          if (widget.index == 0) {
            await _userModel
                .addAddress(
                    name, phone, address, addressName, _userModel.user, city)
                .then((value) {
              if (value != UserStatus.SUCCESS) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Adres Eklerken Bir Sorun Oluştu $value"),
                ));
              } else {
                Navigator.of(context).pop();
              }
            });
          } else {
            await _userModel
                .addBillAddress(
                    name, phone, address, addressName, _userModel.user)
                .then((value) {
              if (value != UserStatus.SUCCESS) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Adres Eklerken Bir Sorun Oluştu $value"),
                ));
              } else {
                Navigator.of(context).pop();
              }
            });
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffd4a244),
          borderRadius: BorderRadius.circular(7),
        ),
        height: size.height * 0.07,
        child: Text(
          "Kaydet",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        alignment: Alignment.center,
      ),
    );
  }
}
