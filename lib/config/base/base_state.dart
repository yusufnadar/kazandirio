import 'package:flutter/material.dart';
import 'package:kazandirio/provider/user_provider.dart';
import 'package:provider/provider.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  ThemeData get currentTheme => Theme.of(context);

  double dynamicHeight(double val) => MediaQuery.of(context).size.height * val;

  double dynamicWidth(double val) => MediaQuery.of(context).size.width * val;

  EdgeInsets insetsAll(double val) => EdgeInsets.all(dynamicHeight(val));

  EdgeInsets insetHorizontal(double val) =>
      EdgeInsets.symmetric(horizontal: dynamicHeight(val));

  EdgeInsets insetVertical(double val) =>
      EdgeInsets.symmetric(vertical: dynamicHeight(val));

  UserProvider authProvider;

  @override
  void initState() {
    authProvider = Provider.of<UserProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  T getProvider<T>() => Provider.of<T>(context, listen: false);
}
