import 'package:flutter/material.dart';
import 'package:markets/src/elements/SearchMarketWidget.dart';
import 'package:markets/src/models/market.dart';

class SearchBarMarketWidget extends StatelessWidget {
  
  final Market market;


  const SearchBarMarketWidget({Key key, this.market}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(SearchMarketModal(market:this.market));
      },
      child: Container(
        padding: EdgeInsets.all(9),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Theme.of(context).focusColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 0),
              child: Icon(Icons.search, color: Theme.of(context).accentColor),
            ),
            Expanded(
              child: Text(
                "Pesquise pelo produto desejado",
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 12)),
              ),
            ),
            SizedBox(width: 8),            
          ],
        ),
      ),
    );
  }
}
