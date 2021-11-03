import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/cart_controller.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';

class ReturnBackFloatButtonWidget extends StatefulWidget {
  const ReturnBackFloatButtonWidget({
    this.iconColor,
    this.labelColor,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;

  @override
  _ReturnBackFloatButtonWidgetState createState() =>
      _ReturnBackFloatButtonWidgetState();
}

class _ReturnBackFloatButtonWidgetState
    extends StateMVC<ReturnBackFloatButtonWidget> {
  _ReturnBackFloatButtonWidgetState() : super() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: RaisedButton(
        padding: EdgeInsets.all(0),
        // color: Color(333333),
        // color: Color(333333),
        color: Theme.of(context).accentColor,
        shape: StadiumBorder(),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: <Widget>[
            Icon(
              Icons.arrow_back,
              color: Colors.orange,
              size: 28,
            ),
          ],
        ),
      ),
    );
//    return FlatButton(
//      onPressed: () {
//        print('to shopping cart');
//      },
//      child:
//      color: Colors.transparent,
//    );
  }
}
