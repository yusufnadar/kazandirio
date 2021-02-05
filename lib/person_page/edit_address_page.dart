import 'package:flutter/material.dart';
import 'package:kazandirio/models/address_model.dart';
import 'package:kazandirio/ortak_butonlar/ekran_dokunma_klavye_kapanma.dart';
import 'package:kazandirio/ortak_butonlar/text_area.dart';
import 'package:kazandirio/provider/user_provider.dart';
import 'package:provider/provider.dart';

class EditAddress extends StatefulWidget {
  AddressModel data;
  int index;

  EditAddress({Key key, this.data, this.index}) : super(key: key);

  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String name, phone, address, addressName;

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
              "Adres Düzenle",
              style: TextStyle(color: Colors.black),
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
                        addressPart(size),
                        addressNamePart(size),
                        updateButton(size)
                      ],
                    ),
                  ),
                  if (_isLoading == true)
                    Container(
                      width: size.width,
                      height: size.height,
                      color: Colors.white.withOpacity(0.8),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.black),
                        ),
                      ),
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
        widget.data.name = value;
      },
      hintText: "Ad - Soyad",
      obsecureText: false,
      initialValue: widget.data.name,
    );
  }

  Container phonePart(Size size) {
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
          widget.data.phone = value;
        },
        hintText: "Telefon Numarası",
        obsecureText: false,
        initialValue: widget.data.phone,
        keyboardType: TextInputType.phone,
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
        widget.data.address = value;
      },
      hintText: "Adres",
      initialValue: widget.data.address,
      obsecureText: false,
    );
  }

  Container addressNamePart(Size size) {
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
          widget.data.addressName = value;
        },
        initialValue: widget.data.addressName,
        hintText: "Adres Adı",
        obsecureText: false,
      ),
    );
  }

  updateButton(Size size) {
    final _userModel = Provider.of<UserProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          setState(() {
            _isLoading = true;
          });
          _userModel
              .updateAddress(
                  widget.data.id,
                  widget.data.name,
                  widget.data.phone,
                  widget.data.address,
                  widget.data.addressName,
                  _userModel.user,
                  widget.index)
              .then((value) {
            if (value != UserStatus.SUCCESS) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Hata oluştu $value")));
            } else {
              Navigator.of(context).pop();
            }
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffd4a244),
          borderRadius: BorderRadius.circular(7),
        ),
        height: size.height * 0.07,
        child: Text(
          "Güncelle",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        alignment: Alignment.center,
      ),
    );
  }
}
