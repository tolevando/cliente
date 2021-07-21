import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/market.dart';


// ignore: must_be_immutable
class CardWidget extends StatelessWidget {
  Market market;
  String heroTag;

  CardWidget({Key key, this.market, this.heroTag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(      
      margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
      padding: EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(0)),
        boxShadow: [
          BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 15, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Image of the card
          Stack(
            fit: StackFit.loose,
            alignment: AlignmentDirectional.topStart,
            children: <Widget>[
              Hero(
                tag: this.heroTag + market.id,                
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100)),                  
                  child: CachedNetworkImage(
                    height: 60,
                    width: 60,
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                    imageUrl: market.image.url,
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Row(                
                children: <Widget>[
                  SizedBox(width:70),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width-(200),                            
                            child:Text(
                              market.name,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),                          
                          Text(
                            market.distance.toStringAsFixed(1).toString()+" Km de você",
                            overflow: TextOverflow.fade,
                            softWrap: true,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          SizedBox(height: 0),
                          Row(
                            children: <Widget>[
                              Column(children: [
                                  ((market.rate != "0")?
                                    Row(
                                      children: [
                                        Icon(Icons.star, size: 14, color: Color(0xFFE7A64A)),
                                        Text(
                                          market.rate,
                                          overflow: TextOverflow.fade,
                                          softWrap: false,
                                          style: TextStyle(color: Color(0xFFE7A64A),fontSize: 14.0),
                                        )                                
                                      ],
                                    ):Text(
                                      "Novo!",
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      style: TextStyle(color: Color(0xFFE7A64A),fontSize: 14.0),
                                    )
                                  )     
                                ],
                              ),
                              SizedBox(width:10),
                              Column(                                
                                children: [     
                                  Container(
                                    width: MediaQuery.of(context).size.width-(200),
                                    padding: new EdgeInsets.only(right: 23.0),
                                    child: Text(
                                      market.fields.map((e) => e.name).toList().join(', '),
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.subtitle2,
                                    ),                                
                                  )                                                               
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 0),
                          Row(
                            children: <Widget>[
                              Column(children: [
                                  Container(                                    
                                    child: market.closed
                                        ? Text(
                                            S.of(context).closed,
                                            style: Theme.of(context).textTheme.caption.merge(TextStyle(color: market.closed ? Colors.grey : Colors.green)),
                                          )
                                        : Text(
                                            S.of(context).open,
                                            style: Theme.of(context).textTheme.caption.merge(TextStyle(color: market.closed ? Colors.grey : Colors.green)),
                                          ),
                                  ),
                                ],
                              ),
                              SizedBox(width:5),
                              Icon(Icons.circle, size: 6, color: Color(0xFF999999)),
                              SizedBox(width:5),
                              Column(                                
                                children: [     
                                  Container(    
                                    width: MediaQuery.of(context).size.width-(200),                                                                                                
                                    child: Helper.canDelivery(market)
                                        ? Text(
                                            "Entrega no seu local",
                                            style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Colors.green)),
                                          )
                                        : Text(
                                            "Não entrega no seu local",
                                            style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Colors.orange)),
                                          ),
                                  )                                                             
                                ],
                              ),
                            ],
                          ),                     
                        ],
                      ),
                  )                  
                ],
              ),
            ],
          ),
          
        ],
      ),
    );
  }
}
