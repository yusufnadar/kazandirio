import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazandirio/models/address_model.dart';
import 'package:kazandirio/person_page/add_address_page.dart';
import 'package:kazandirio/person_page/edit_address_page.dart';
import 'package:kazandirio/provider/user_provider.dart';
import 'package:provider/provider.dart';

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  int _currentIndex = 0;

  Stream getAddress;
  Stream getBillAddress;

  @override
  void initState() {
    super.initState();
    final _userModel = Provider.of<UserProvider>(context, listen: false);
    _userModel.getAddress1(_userModel.user);
    getBillAddress = _userModel.getBillAddress(_userModel.user);
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          _currentIndex == 0 ? "Teslimat Adreslerim" : "Fatura Adreslerim",
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: size.width * 0.044, vertical: size.height * 0.007),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: size.height * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                      child: Container(
                        width: size.width * 0.44,
                        height: size.height * 0.05,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _currentIndex == 0 ? Colors.red : Colors.grey,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Teslimat Adresim",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = 1;
                        });
                      },
                      child: Container(
                        width: size.width * 0.44,
                        height: size.height * 0.05,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: _currentIndex == 1 ? Colors.red : Colors.grey,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Fatura Adresim",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              addAddress(context, size),
              if (_currentIndex == 0)
                Consumer<UserProvider>(
                  builder: (context, snapshot, w) {
                    if (snapshot.teslimatAdreslerim != null) {
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.teslimatAdreslerim.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin:
                                  EdgeInsets.only(bottom: size.height * 0.03),
                              child: card(index, size,
                                  snapshot.teslimatAdreslerim[index]),
                            );
                          });
                    } else
                      return Container(
                        width: size.width,
                        height: size.height,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                  },
                ),
              if (_currentIndex == 1)
                StreamBuilder<List<AddressModel>>(
                  stream: getBillAddress,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin:
                                  EdgeInsets.only(bottom: size.height * 0.03),
                              child: card(index, size, snapshot.data[index]),
                            );
                          });
                    } else
                      return Container(
                        width: size.width,
                        height: size.height,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  /*
                StreamBuilder<List<AddressModel>>(
                stream: _currentIndex == 0 ? getAddress : getBillAddress,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: size.height * 0.03),
                            child: card(index, size, snapshot.data[index]),
                          );
                        });
                  } else
                    return Container(
                      width: size.width,
                      height: size.height,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                },
              )
   */

  GestureDetector addAddress(BuildContext context, Size size) {
    final _userProvider = Provider.of<UserProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => AddAddress(
              index: _currentIndex,
            ),
          ),
        )
            .then((value) {
          _userProvider.getAddress1(_userProvider.user);
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: size.height * 0.02),
        color: Colors.grey.shade100,
        width: size.width,
        height: size.height * 0.08,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _currentIndex == 0
                ? Text("Yeni Teslimat Adresi Ekle")
                : Text("Yeni Fatura Adresi Ekle"),
            Icon(
              Icons.add_circle,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  card(int index, Size size, AddressModel data) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title(index, data.addressName),
            name(size, data.name),
            address(index, data.address),
            phoneNumber(size, data.phone),
            deleteAndEdit(size, data)
          ],
        ),
      ),
    );
  }

  Text title(int index, addressName) {
    return Text(
      addressName,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  Container name(Size size, name) {
    return Container(
      margin:
          EdgeInsets.only(top: size.height * 0.015, bottom: size.height * 0.01),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 20,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Text address(int index, address) => Text(address);

  Container phoneNumber(Size size, phone) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.04),
      child: Text(
        phone.toString().substring(0, 3) +
            " " +
            phone.toString().substring(3, 6) +
            " " +
            phone.toString().substring(6, 8) +
            " " +
            phone.toString().substring(8, 10),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Container deleteAndEdit(Size size, AddressModel data) {
    final _userModel = Provider.of<UserProvider>(context);
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  "Silmek istediğinize emin misiniz?",
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        _userModel
                            .deleteAddress(
                                data.id, _userModel.user, _currentIndex)
                            .then((value) {
                          if (value != UserStatus.SUCCESS) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text("Silinirken bir hata oluştu $value")));
                          } else {
                            Navigator.of(context).pop();
                          }
                        });
                      },
                      child: Text(
                        "Sil",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Vazgeç",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      )),
                ],
              ),
            ),
            child: Text("Sil"),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditAddress(
                  data: data,
                  index: _currentIndex,
                ),
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05, vertical: size.height * 0.017),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Color(0xffd4a244),
              ),
              margin: EdgeInsets.only(
                left: size.width * 0.05,
              ),
              child: Text("Düzenle"),
            ),
          ),
        ],
      ),
    );
  }
}

/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazandirio/models/address_model.dart';
import 'package:kazandirio/person_page/add_address_page.dart';
import 'package:kazandirio/person_page/edit_address_page.dart';
import 'package:kazandirio/provider/user_provider.dart';
import 'package:provider/provider.dart';

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  Future getAddress;

  @override
  void initState() {
    super.initState();
    final _userModel = Provider.of<UserModel>(context, listen: false);
    getAddress = _userModel.getAddress1(_userModel.user);
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddAddress()))
                  .then((value) async {
                getAddress = _userModel.getAddress1(_userModel.user);
                setState(() {});
              });
            },
            child: Container(width: size.width * 0.14, child: Icon(Icons.add)),
          )
        ],
        title: Text(
          "Adreslerim",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<AddressModel>>(
        future: getAddress,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                        vertical: size.height * 0.007),
                    child: card(index, size, snapshot.data[index]),
                  );
                });
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }

  Card card(int index, Size size, AddressModel data) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title(index, data.addressName),
            name(size, data.name),
            address(index, data.address),
            phoneNumber(size, data.phone),
            deleteAndEdit(size, data.id)
          ],
        ),
      ),
    );
  }

  Text title(int index, addressName) {
    return Text(
      addressName,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  Container name(Size size, name) {
    return Container(
      margin:
          EdgeInsets.only(top: size.height * 0.015, bottom: size.height * 0.01),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 20,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Text address(int index, address) => Text(address);

  Container phoneNumber(Size size, phone) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.04),
      child: Text(
        phone.toString().substring(0, 3) +
            " " +
            phone.toString().substring(3, 6) +
            " " +
            phone.toString().substring(6, 8) +
            " " +
            phone.toString().substring(8, 10),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Container deleteAndEdit(Size size, id) {
    final _userModel = Provider.of<UserModel>(context);
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  "Silmek istediğinize emin misiniz?",
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        _userModel
                            .deleteAddress(id, _userModel.user)
                            .then((value) {
                          Navigator.of(context).pop();
                          getAddress = _userModel.getAddress1(_userModel.user);
                          setState(() {});
                        });
                      },
                      child: Text(
                        "Sil",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Vazgeç",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      )),
                ],
              ),
            ),
            child: Text("Sil"),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => EditAddress())),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05, vertical: size.height * 0.017),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Color(0xffd4a244),
              ),
              margin: EdgeInsets.only(
                left: size.width * 0.05,
              ),
              child: Text("Düzenle"),
            ),
          ),
        ],
      ),
    );
  }
}

 */
