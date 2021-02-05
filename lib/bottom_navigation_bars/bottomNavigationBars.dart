import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazandirio/bottom_navigation_bars/basket_page.dart';
import 'package:kazandirio/bottom_navigation_bars/order_page.dart';
import 'package:kazandirio/bottom_navigation_bars/products_page.dart';

enum TabItem { Products, Basket, Order }

class BottomNavigationBars extends StatefulWidget {
  final int currentTab1;

  BottomNavigationBars({
    Key key,
    this.currentTab1,
  }) : super(key: key);

  @override
  _BottomNavigationBarsState createState() => _BottomNavigationBarsState();
}

class _BottomNavigationBarsState extends State<BottomNavigationBars>
    with SingleTickerProviderStateMixin {
  TabItem _currentTab = TabItem.Products;

  //her sayfanın bir navigatorkeyi olmalı
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Products: GlobalKey<NavigatorState>(),
    TabItem.Basket: GlobalKey<NavigatorState>(),
    TabItem.Order: GlobalKey<NavigatorState>(),
  };

  //bizi yönlendireceği sayfalar
  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Products: ProductPage(),
      TabItem.Basket: BasketPage(),
      TabItem.Order: OrderPage(),
      //TabItem.Mesajlar: Mesajlar(),
    };
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      // sayfanın içerisinde yeni bir sekmeye gittiysek, o sekmeden geri çıkınca uygulamadan çıkmaması için
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoTabScaffold(
        // birden fazla navigator istiyorsak..
        tabBar: CupertinoTabBar(
          // ilk başlayacağı tab
          currentIndex: widget.currentTab1,
          //altta görünecek menünün görünürlüğüyle ilgili yer
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/images/products.png",
                width: size.width * 0.07,
                fit: BoxFit.contain,
                color: _currentTab == TabItem.Products
                    ? Colors.orange.shade900
                    : Colors.grey,
              ),
              backgroundColor: Colors.orange,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/images/basket.png",
                width: size.width * 0.07,
                fit: BoxFit.contain,
                color: _currentTab == TabItem.Basket
                    ? Colors.orange.shade900
                    : Colors.grey,
              ),
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/images/order.png",
                width: size.width * 0.07,
                fit: BoxFit.contain,
                color: _currentTab == TabItem.Order
                    ? Colors.orange.shade900
                    : Colors.grey,
              ),
              backgroundColor: Colors.blue,
            ),
          ],
          onTap: (index) {
            TabItem newTabItem = TabItem.values[index];
            // TabItem değerine integer bir değer gönderip enum listesinde  denk gelen sayfayı çağırdık
            if (newTabItem == _currentTab) {
              // eğer tıklanılan sekme şuanki sekmeyse ilk sayfaya geri döner
              navigatorKeys[newTabItem].currentState.popUntil(
                    (route) => route.isFirst,
                  );
            }
            setState(() {
              _currentTab = newTabItem;
            });
          },
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(
            navigatorKey: navigatorKeys[TabItem.values[index]],
            //buradaki map fonksiyon olduğu için sadece [] kullandık
            builder: (context) {
              //buradaki map fonksiyon olduğu için () kullandık
              return tumSayfalar()[TabItem.values[index]];
            },
          );
        },
      ),
    );
  }
}
