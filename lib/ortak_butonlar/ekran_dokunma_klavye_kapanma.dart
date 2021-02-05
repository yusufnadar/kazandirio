import 'package:flutter/material.dart';

class KlavyeninKapanmasi extends StatelessWidget {
  final child;

  KlavyeninKapanmasi({Key key, this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // Ekrana tıkladığında klavyenin kapanmasını sağlar focusScope ile.
      onTap: () {
        FocusScope.of(context).requestFocus(
            new FocusNode()); // Ekrana tıkladığında klavyenin kapanmasını sağlar behavior ile.
      },
      child: child,
    );
  }
}
