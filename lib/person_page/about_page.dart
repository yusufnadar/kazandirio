import 'package:flutter/material.dart';
import 'package:kazandirio/provider/product_provider.dart';
import 'package:provider/provider.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  void initState() {
    super.initState();
    final _productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    _productProvider.getAbout();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "HAKKIMIZDA",
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: about(size),
      ),
    );
  }

  about(Size size) {
    return Consumer<ProductProvider>(builder: (context, snapshot, w) {
      if (snapshot.about != null) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Text(
            snapshot.about,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
          ),
        );
      } else
        return Container(
          width: size.width,
          height: size.height,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
    });
  }
}
