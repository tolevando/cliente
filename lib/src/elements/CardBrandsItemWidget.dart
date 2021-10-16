import 'package:flutter/material.dart';

import '../models/card_brand.dart' as model;
import '../models/payment_method.dart';

// ignore: must_be_immutable
class CardBrandsItemWidget extends StatelessWidget {
  String heroTag;
  model.CardBrand card_brand;
  PaymentMethod paymentMethod;
  ValueChanged<model.CardBrand> onPressed;

  CardBrandsItemWidget(
      {Key key, this.card_brand, this.onPressed, this.paymentMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildItem(context);
  }

  InkWell buildItem(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        this.onPressed(card_brand);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Theme.of(context).focusColor),
                  child: Icon(
                    Icons.credit_card_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 38,
                  ),
                ),
              ],
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        card_brand?.brand != null
                            ? Text(
                                card_brand.brand,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: Theme.of(context).textTheme.subtitle1,
                              )
                            : SizedBox(height: 0),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
