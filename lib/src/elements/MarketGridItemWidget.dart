import 'package:flutter/material.dart';

import '../models/market.dart';
import '../models/route_argument.dart';
import '../../src/helpers/helper.dart';
import '../repository/settings_repository.dart';

class MarketGridItemWidget extends StatefulWidget {
  final String heroTag;
  final Market market;
  final VoidCallback onPressed;

  MarketGridItemWidget({Key key, this.heroTag, this.market, this.onPressed})
      : super(key: key);

  @override
  _MarketGridItemWidgetState createState() => _MarketGridItemWidgetState();
}

class _MarketGridItemWidgetState extends State<MarketGridItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Menu',
            arguments: new RouteArgument(
                heroTag: this.widget.heroTag, id: this.widget.market.id));
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: widget.heroTag + widget.market.id,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(this.widget.market.image.thumb),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                widget.market.name,
                style: Theme.of(context).textTheme.bodyText1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                Helper.getDistance(widget.market.distance,
                    Helper.of(context).trans(setting.value.distanceUnit)),
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: 40,
            height: 40,
          ),
        ],
      ),
    );
  }
}
