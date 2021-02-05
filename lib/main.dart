import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kazandirio/bottom_navigation_bars/bottomNavigationBars.dart';
import 'package:kazandirio/provider/auth_provider.dart';
import 'package:kazandirio/provider/product_provider.dart';
import 'package:kazandirio/provider/user_provider.dart';
import 'package:kazandirio/services/locator.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.grey));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
            create: (context) => UserProvider()),
        ChangeNotifierProvider<ProductProvider>(
            create: (context) => ProductProvider()),
        ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme:
            ThemeData(fontFamily: "Poppins", primaryColor: Color(0xffd4a244)),
        home: AnimatedSplashScreen(
          duration: 2,
          splashTransition: SplashTransition.slideTransition,
          nextScreen: BottomNavigationBars(
            currentTab1: 0,
          ),
          splash: Image.asset("assets/images/basket.png"),
        ),
      ),
    );
  }
}
