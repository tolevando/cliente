import 'package:flutter/material.dart';

import 'CardsCarouselLoaderWidget.dart';
import '../models/market.dart';
import '../models/route_argument.dart';
import 'CardWidget.dart';

// ignore: must_be_immutable
class CardsCarouselHorizontalWidget extends StatefulWidget {
  List<Market> marketsList;
  String heroTag;

  CardsCarouselHorizontalWidget({Key key, this.marketsList, this.heroTag}) : super(key: key);

  @override
  _CardsCarouselHorizontalWidgetState createState() => _CardsCarouselHorizontalWidgetState();
}

class _CardsCarouselHorizontalWidgetState extends State<CardsCarouselHorizontalWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.marketsList.isEmpty
        ? CardsCarouselLoaderWidget()
        : Container(
            height: (288).toDouble(),
            child: ListView.builder(
              //physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.marketsList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Menu',
                        arguments: RouteArgument(
                          id: widget.marketsList.elementAt(index).id,
                          //heroTag: widget.heroTag,
                        ));
                  },
                  child: CardWidget(market: widget.marketsList.elementAt(index), heroTag: widget.heroTag),
                );
              },
            ),
          );
  }
}
