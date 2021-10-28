import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/parser.dart';

import '../../generated/l10n.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/cart.dart';
import '../models/market.dart';
import '../models/order.dart';
import '../models/product_order.dart';
import '../models/product.dart';
import '../repository/settings_repository.dart';
import 'app_config.dart' as config;
import 'custom_trace.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
  BuildContext context;
  DateTime currentBackPressTime;

  Helper.of(BuildContext _context) {
    this.context = _context;
  }

  // for mapping data retrieved form json array
  static getData(Map<String, dynamic> data) {
    return data['data'] ?? [];
  }

  static int getIntData(Map<String, dynamic> data) {
    return (data['data'] as int) ?? 0;
  }

  static bool getBoolData(Map<String, dynamic> data) {
    return (data['data'] as bool) ?? false;
  }

  static getObjectData(Map<String, dynamic> data) {
    return data['data'] ?? new Map<String, dynamic>();
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  static Future<Marker> getMarker(Map<String, dynamic> res) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/img/marker.png', 120);
    final Marker marker = Marker(
        markerId: MarkerId(res['id']),
        icon: BitmapDescriptor.fromBytes(markerIcon),
//        onTap: () {
//          //print(res.name);
//        },
        anchor: Offset(0.5, 0.5),
        infoWindow: InfoWindow(
            title: res['name'],
            snippet: getDistance(
                res['distance'].toDouble(), setting.value.distanceUnit),
            onTap: () {
              print(CustomTrace(StackTrace.current, message: 'Info Window'));
            }),
        position: LatLng(
            double.parse(res['latitude']), double.parse(res['longitude'])));

    return marker;
  }

  static Future<Marker> getMyPositionMarker(
      double latitude, double longitude) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/img/my_marker.png', 120);
    final Marker marker = Marker(
        markerId: MarkerId(Random().nextInt(100).toString()),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        anchor: Offset(0.5, 0.5),
        position: LatLng(latitude, longitude));

    return marker;
  }

  static List<Icon> getStarsList(double rate, {double size = 18}) {
    var list = <Icon>[];
    list = List.generate(rate.floor(), (index) {
      return Icon(Icons.star, size: size, color: Color(0xFFFFB24D));
    });
    if (rate - rate.floor() > 0) {
      list.add(Icon(Icons.star_half, size: size, color: Color(0xFFFFB24D)));
    }
    list.addAll(
        List.generate(5 - rate.floor() - (rate - rate.floor()).ceil(), (index) {
      return Icon(Icons.star_border, size: size, color: Color(0xFFFFB24D));
    }));
    return list;
  }

  static void launchURL(String subject, String body) async {
    var url =
        'mailto:${GlobalConfiguration().getString('email')}?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Widget getPrice(double myPrice, BuildContext context,
      {TextStyle style,
      String zeroPlaceholder = '-',
      Product product = null,
      options = null}) {
    if (style != null) {
      style = style.merge(TextStyle(fontSize: style.fontSize + 2));
    }
    try {
      if (myPrice == 0) {
        switch (product.option_mid_pizza) {
          case '0': //NÃO OFERECE OPÇÃO PIZZA MEIO A MEIO
            print("RETURN DEFAULT - CASE 0");
            return Text('-',
                style: style ?? Theme.of(context).textTheme.subtitle1);
            break;
          case '1': //COBRA VALOR MEDIO OPÇÃO PIZZA MEIO A MEIO
            print("COBRAR VALOR MÉDIO OPÇÃO PIZZA MEIO A MEIO GET PRICE");
            var counter = 0;
            for (var t = 0; t < options.length; t++) {
              counter += 1;
              if (counter < 3) {
                myPrice += (options[t].price / 2);
              } else {
                myPrice += options[t].price;
              }
            }
            break;
          case '2': //COBRA VALOR MAIOR OPÇÃO PIZZA MEIO A MEIO
            print("COBRAR VALOR MAIOR OPÇÃO PIZZA MEIO A MEIO GET PRICE");
            var counter = 0;
            var firstPrice = 0.0;
            for (var t = 0; t < options.length; t++) {
              print("COUNTER: " + counter.toString());
              if (counter == 0) {
                print("ENTROU NO COUNTER ZERO");
                firstPrice = options[t].price;
              }
              counter += 1;
              if (counter < 3) {
                print("FIRST PRICE: " + firstPrice.toString());
                print("OPTION PRICE: " + options[t].price.toString());
                myPrice = (firstPrice > options[t].price
                    ? firstPrice
                    : options[t].price);
              } else {
                myPrice += options[t].price;
              }
            }
            break;
          default:
            print("RETURN DEFAULT");
            return Text('-',
                style: style ?? Theme.of(context).textTheme.subtitle1);

            break;
        }
      }
      return RichText(
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
        text: setting.value?.currencyRight != null &&
                setting.value?.currencyRight == false
            ? TextSpan(
                text: setting.value?.defaultCurrency,
                style: style == null
                    ? Theme.of(context).textTheme.subtitle1.merge(
                          TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .fontSize -
                                  6),
                        )
                    : style.merge(TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: style.fontSize - 6)),
                children: <TextSpan>[
                  TextSpan(
                      text: myPrice.toStringAsFixed(
                              setting.value?.currencyDecimalDigits) ??
                          '',
                      style: style ?? Theme.of(context).textTheme.subtitle1),
                ],
              )
            : TextSpan(
                text: myPrice.toStringAsFixed(
                        setting.value?.currencyDecimalDigits) ??
                    '',
                style: style ?? Theme.of(context).textTheme.subtitle1,
                children: <TextSpan>[
                  TextSpan(
                    text: setting.value?.defaultCurrency,
                    style: style == null
                        ? Theme.of(context).textTheme.subtitle1.merge(
                              TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .fontSize -
                                      6),
                            )
                        : style.merge(TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: style.fontSize - 6)),
                  ),
                ],
              ),
      );
    } catch (e) {
      return Text('');
    }
  }

  static Widget getPriceMinimum(double myPrice, BuildContext context,
      {TextStyle style,
      String zeroPlaceholder = '-',
      Product product = null,
      options = null}) {
    if (style != null) {
      style = style.merge(TextStyle(fontSize: style.fontSize + 2));
    }
    if (myPrice == 0) {
      return Text('', style: style ?? Theme.of(context).textTheme.subtitle1);
    }
    try {
      return RichText(
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
        text: setting.value?.currencyRight != null &&
                setting.value?.currencyRight == false
            ? TextSpan(
                text: '-' + setting.value?.defaultCurrency,
                style: style == null
                    ? Theme.of(context).textTheme.subtitle1.merge(
                          TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .fontSize -
                                  6),
                        )
                    : style.merge(TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: style.fontSize - 6)),
                children: <TextSpan>[
                  TextSpan(
                      text: myPrice.toStringAsFixed(
                              setting.value?.currencyDecimalDigits) ??
                          '',
                      style: style ?? Theme.of(context).textTheme.subtitle1),
                ],
              )
            : TextSpan(
                text: myPrice.toStringAsFixed(
                        setting.value?.currencyDecimalDigits) ??
                    '',
                style: style ?? Theme.of(context).textTheme.subtitle1,
                children: <TextSpan>[
                  TextSpan(
                    text: setting.value?.defaultCurrency,
                    style: style == null
                        ? Theme.of(context).textTheme.subtitle1.merge(
                              TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .fontSize -
                                      6),
                            )
                        : style.merge(TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: style.fontSize - 6)),
                  ),
                ],
              ),
      );
    } catch (e) {
      return Text('');
    }
  }

  static Widget getPriceMinimumPercent(double myPrice, BuildContext context,
      {TextStyle style,
      String zeroPlaceholder = '-',
      Product product = null,
      options = null}) {
    if (style != null) {
      style = style.merge(TextStyle(fontSize: style.fontSize + 2));
    }
    if (myPrice == 0) {
      return Text('', style: style ?? Theme.of(context).textTheme.subtitle1);
    }
    try {
      return RichText(
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
        text: setting.value?.currencyRight != null &&
                setting.value?.currencyRight == false
            ? TextSpan(
                text: '-' + setting.value?.defaultCurrency,
                style: style == null
                    ? Theme.of(context).textTheme.subtitle1.merge(
                          TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .fontSize -
                                  6),
                        )
                    : style.merge(TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: style.fontSize - 6)),
                children: <TextSpan>[
                  TextSpan(
                      text: myPrice.toStringAsFixed(
                              setting.value?.currencyDecimalDigits) ??
                          '',
                      style: style ?? Theme.of(context).textTheme.subtitle1),
                ],
              )
            : TextSpan(
                text: myPrice.toStringAsFixed(
                        setting.value?.currencyDecimalDigits) ??
                    '',
                style: style ?? Theme.of(context).textTheme.subtitle1,
                children: <TextSpan>[
                  TextSpan(
                    text: setting.value?.defaultCurrency,
                    style: style == null
                        ? Theme.of(context).textTheme.subtitle1.merge(
                              TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .fontSize -
                                      6),
                            )
                        : style.merge(TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: style.fontSize - 6)),
                  ),
                ],
              ),
      );
    } catch (e) {
      return Text('');
    }
  }

  static double getTotalOrderPrice(ProductOrder productOrder) {
    double total = productOrder.price;
    productOrder.options.forEach((option) {
      total += option.price != null ? option.price : 0;
    });
    total *= productOrder.quantity;
    return total;
  }

  static double getOrderPrice(ProductOrder productOrder) {
    double total = productOrder.price;
    print("OPTION PRICE TOTAL INITIAL: " + total.toString());

    switch (productOrder.product.option_mid_pizza) {
      case '0': //NÃO OFERECE OPÇÃO PIZZA MEIO A MEIO
        print("NÃO OFERECE OPÇÃO PIZZA MEIO A MEIO");
        // productOrder.options.forEach((option) {
        //   print("OPTION PRODUCT PRICE: " + option.price.toString());
        //   print("OPTION PRODUCT NAME: " + option.name.toString());
        //   total += option.price != null ? option.price : 0;
        // });

        print("OPTION PRICE TOTAL: " + total.toString());
        break;
      case '1': //COBRA VALOR MEDIO OPÇÃO PIZZA MEIO A MEIO
        print("COBRAR VALOR MÉDIO OPÇÃO PIZZA MEIO A MEIO");
        total = productOrder.price;
        break;
      case '2': //COBRA VALOR MAIOR OPÇÃO PIZZA MEIO A MEIO
        print("COBRAR VALOR MAIOR OPÇÃO PIZZA MEIO A MEIO");
        total = productOrder.price;
        break;
      default:
        print("COBRAR VALOR DEFAULT");
        // productOrder.options.forEach((option) {
        //   total += option.price != null ? option.price : 0;
        // });
        break;
    }
    print("OPTION PRICE TOTAL FINAL: " + total.toString());

    return total;
  }

  static double getTaxOrder(Order order) {
    double total = 0;
    order.productOrders.forEach((productOrder) {
      total += getTotalOrderPrice(productOrder);
    });
    return order.tax * total / 100;
  }

  static double getDiscountTotalOrdersPrice(Order order) {
    double total = 0;
    double discount = 0;
    order.productOrders.forEach((productOrder) {
      total += productOrder.price;
    });

    total += order.deliveryFee;
    total += order.tax * total / 100;

    discount = total - order.payment.price;
    return discount;
  }

  static double getTotalOrdersPrice(Order order) {
    double total = 0;
    order.productOrders.forEach((productOrder) {
      total += getTotalOrderPrice(productOrder);
    });
    total += order.deliveryFee;
    total += order.tax * total / 100;
    return total;
  }

  static String getDistance(double distance, String unit) {
    String _unit = setting.value.distanceUnit;
    if (_unit == 'km') {
      distance *= 1.60934;
    }
    return distance != null
        ? distance.toStringAsFixed(2) + " " + unit + " de você"
        : "";
  }

  static bool canDelivery(Market _market, {List<Cart> carts}) {
    bool _can = true;
    String _unit = setting.value.distanceUnit;
    double _deliveryRange = _market.deliveryRange;
    double _distance = _market.distance;
    carts?.forEach((Cart _cart) {
      _can &= _cart.product.deliverable;
    });

    if (_unit == 'km') {
      _deliveryRange /= 1.60934;
    }
    //print(deliveryAddress.value.id);
    if (_distance == 0 && !deliveryAddress.value.isUnknown()) {
      _distance = sqrt(pow(
              69.1 *
                  (double.parse(_market.latitude) -
                      deliveryAddress.value.latitude),
              2) +
          pow(
              69.1 *
                  (deliveryAddress.value.longitude -
                      double.parse(_market.longitude)) *
                  cos(double.parse(_market.latitude) / 57.3),
              2));
    }
    //print(deliveryAddress.value.latitude);
    //print(_deliveryRange);
    //print(_distance);
    _can &= _market.availableForDelivery &&
        (_distance < _deliveryRange) &&
        !deliveryAddress.value.isUnknown();
    return _can;
  }

  static String skipHtml(String htmlString) {
    try {
      var document = parse(htmlString);
      String parsedString = parse(document.body.text).documentElement.text;
      return parsedString;
    } catch (e) {
      return '';
    }
  }

  static Html applyCustomHtml(context, String html, {TextStyle style}) {
    return Html(
      data: html ?? '',
    );
  }

  static Html applyHtml(context, String html, {TextStyle style}) {
    return Html(
      data: html ?? '',
      style: {
        "*": Style(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(0),
          color: Theme.of(context).hintColor,
          fontSize: FontSize(16.0),
          display: Display.INLINE_BLOCK,
          width: config.App(context).appWidth(100),
        ),
        "h4,h5,h6": Style(
          fontSize: FontSize(18.0),
        ),
        "h1,h2,h3": Style(
          fontSize: FontSize.xLarge,
        ),
        "br": Style(
          height: 0,
        ),
        "p": Style(
          fontSize: FontSize(16.0),
        )
      },
    );
  }

  static OverlayEntry overlayLoader(context) {
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
          color: Theme.of(context).primaryColor.withOpacity(0.85),
          child: CircularLoadingWidget(height: 200),
        ),
      );
    });
    return loader;
  }

  static hideLoader(OverlayEntry loader) {
    Timer(Duration(milliseconds: 500), () {
      try {
        loader?.remove();
      } catch (e) {}
    });
  }

  static String limitString(String text,
      {int limit = 24, String hiddenText = "..."}) {
    return text.substring(0, min<int>(limit, text.length)) +
        (text.length > limit ? hiddenText : '');
  }

  static String getCreditCardNumber(String number) {
    String result = '';
    if (number != null && number.isNotEmpty && number.length == 16) {
      result = number.substring(0, 4);
      result += ' ' + number.substring(4, 8);
      result += ' ' + number.substring(8, 12);
      result += ' ' + number.substring(12, 16);
    }
    return result;
  }

  static String getCreditCardNumberHidden(String number) {
    String result = '';
    if (number != null && number.isNotEmpty && number.length == 16) {
      result = '****';
      result += ' ' + '****';
      result += ' ' + '****';
      result += ' ' + number.substring(12, 16);
    }
    return result;
  }

  static Uri getUri(String path) {
    String _path = Uri.parse(GlobalConfiguration().getString('base_url')).path;
    if (!_path.endsWith('/')) {
      _path += '/';
    }
    Uri uri = Uri(
        scheme: Uri.parse(GlobalConfiguration().getString('base_url')).scheme,
        host: Uri.parse(GlobalConfiguration().getString('base_url')).host,
        port: Uri.parse(GlobalConfiguration().getString('base_url')).port,
        path: _path + path);
    return uri;
  }

  Color getColorFromHex(String hex) {
    if (hex.contains('#')) {
      return Color(int.parse(hex.replaceAll("#", "0xFF")));
    } else {
      return Color(int.parse("0xFF" + hex));
    }
  }

  static BoxFit getBoxFit(String boxFit) {
    switch (boxFit) {
      case 'cover':
        return BoxFit.cover;
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'fit_height':
        return BoxFit.fitHeight;
      case 'fit_width':
        return BoxFit.fitWidth;
      case 'none':
        return BoxFit.none;
      case 'scale_down':
        return BoxFit.scaleDown;
      default:
        return BoxFit.cover;
    }
  }

  static AlignmentDirectional getAlignmentDirectional(
      String alignmentDirectional) {
    switch (alignmentDirectional) {
      case 'top_start':
        return AlignmentDirectional.topStart;
      case 'top_center':
        return AlignmentDirectional.topCenter;
      case 'top_end':
        return AlignmentDirectional.topEnd;
      case 'center_start':
        return AlignmentDirectional.centerStart;
      case 'center':
        return AlignmentDirectional.topCenter;
      case 'center_end':
        return AlignmentDirectional.centerEnd;
      case 'bottom_start':
        return AlignmentDirectional.bottomStart;
      case 'bottom_center':
        return AlignmentDirectional.bottomCenter;
      case 'bottom_end':
        return AlignmentDirectional.bottomEnd;
      default:
        return AlignmentDirectional.bottomEnd;
    }
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: S.of(context).tapAgainToLeave);
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  String trans(String text) {
    switch (text) {
      case "App\\Notifications\\StatusChangedOrder":
        return S.of(context).order_status_changed;
      case "App\\Notifications\\NewOrder":
        return S.of(context).new_order_from_client;
      case "km":
        return S.of(context).km;
      case "mi":
        return S.of(context).mi;
      default:
        return "";
    }
  }
}
