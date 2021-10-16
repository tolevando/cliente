import 'package:flutter/material.dart';
import 'package:markets/src/models/market.dart';
import 'package:markets/src/pages/bairrola.dart';
import 'package:markets/src/pages/facebook_login.dart';
import 'package:markets/src/pages/order_success_retirada.dart';
import 'package:markets/src/pages/pagarme.dart';
import 'package:markets/src/pages/pagarme_cartao_recusado.dart';
import 'package:markets/src/pages/pagarme_retirada.dart';
import 'package:markets/src/pages/payment_methods_pickup.dart';

import 'src/models/route_argument.dart';
import 'src/pages/cart.dart';
import 'src/pages/category.dart';
import 'src/pages/checkout.dart';
import 'src/pages/debug.dart';
import 'src/pages/delivery_addresses.dart';
import 'src/pages/delivery_pickup.dart';
import 'src/pages/details.dart';
import 'src/pages/forget_password.dart';
import 'src/pages/help.dart';
import 'src/pages/languages.dart';
import 'src/pages/login.dart';
import 'src/pages/menu_list.dart';
import 'src/pages/order_success.dart';
import 'src/pages/pages.dart';
import 'src/pages/payment_methods.dart';
import 'src/pages/paypal_payment.dart';
import 'src/pages/product.dart';
import 'src/pages/profile.dart';
import 'src/pages/razorpay_payment.dart';
import 'src/pages/reviews.dart';
import 'src/pages/settings.dart';
import 'src/pages/signup.dart';
import 'src/pages/splash_screen.dart';
import 'src/pages/tracking.dart';
import 'src/pages/select_brand.dart';

import 'package:markets/src/pages/cidadela.dart';
import 'package:markets/src/pages/cidadela2.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Debug':
        return MaterialPageRoute(
            builder: (_) => DebugWidget(routeArgument: args as RouteArgument));
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/SignUp':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/MobileVerification':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/MobileVerification2':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginWidget());
      case '/Profile':
        return MaterialPageRoute(builder: (_) => ProfileWidget());
      case '/ForgetPassword':
        return MaterialPageRoute(builder: (_) => ForgetPasswordWidget());
      case '/Pages':
        return MaterialPageRoute(builder: (_) => PagesWidget(currentTab: args));
      case '/Details':
        return MaterialPageRoute(
            builder: (_) => DetailsWidget(routeArgument: args));
      case '/Menu':
        return MaterialPageRoute(
            builder: (_) => MenuWidget(routeArgument: args as RouteArgument));
      case '/Product':
        return MaterialPageRoute(
            builder: (_) =>
                ProductWidget(routeArgument: args as RouteArgument));
      case '/Category':
        return MaterialPageRoute(
            builder: (_) =>
                CategoryWidget(routeArgument: args as RouteArgument));
      case '/Cart':
        return MaterialPageRoute(
            builder: (_) => CartWidget(routeArgument: args as RouteArgument));
      case '/SelectBrand':
        return MaterialPageRoute(
            builder: (_) =>
                SelectBrandWidget(routeArgument: args as RouteArgument));
      case '/Tracking':
        return MaterialPageRoute(
            builder: (_) =>
                TrackingWidget(routeArgument: args as RouteArgument));
      case '/Reviews':
        return MaterialPageRoute(
            builder: (_) =>
                ReviewsWidget(routeArgument: args as RouteArgument));
      case '/PaymentMethod':
        return MaterialPageRoute(builder: (_) => PaymentMethodsWidget());
      case '/DeliveryAddresses':
        return MaterialPageRoute(builder: (_) => DeliveryAddressesWidget());
      case '/DeliveryPickup':
        return MaterialPageRoute(
            builder: (_) =>
                DeliveryPickupWidget(routeArgument: args as RouteArgument));
      case '/Checkout':
        return MaterialPageRoute(builder: (_) => CheckoutWidget());
      case '/Pagarme':
        return MaterialPageRoute(builder: (_) => PagarmeWidget());
      case '/PagarmeRetirada':
        return MaterialPageRoute(builder: (_) => PagarmeRetiradaWidget());
      case '/CashOnDelivery':
        return MaterialPageRoute(
            builder: (_) => OrderSuccessWidget(
                routeArgument: RouteArgument(param: 'Dinheiro na Entrega')));
      case '/CreditCardOnDelivery':
        return MaterialPageRoute(
            builder: (_) => OrderSuccessWidget(
                routeArgument:
                    RouteArgument(param: 'Cartão de Crédito na Entrega')));
      case '/DebitCardOnDelivery':
        return MaterialPageRoute(
            builder: (_) => OrderSuccessWidget(
                routeArgument:
                    RouteArgument(param: 'Cartão de Débito na Entrega')));
      case '/CashOnRetirada':
        return MaterialPageRoute(
            builder: (_) => OrderSuccessRetiradaWidget(
                routeArgument: RouteArgument(param: 'Dinheiro na Retirada')));
      case '/CreditCardOnRetirada':
        return MaterialPageRoute(
            builder: (_) => OrderSuccessRetiradaWidget(
                routeArgument:
                    RouteArgument(param: 'Cartão de Crédito na Retirada')));
      case '/DebitCardOnRetirada':
        return MaterialPageRoute(
            builder: (_) => OrderSuccessRetiradaWidget(
                routeArgument:
                    RouteArgument(param: 'Cartão de Débito na Retirada')));
      case '/PayOnPickup':
        return MaterialPageRoute(
            builder: (_) => PaymentMethodsPickupWidget(
                routeArgument: args as RouteArgument));
      case '/PayPal':
        return MaterialPageRoute(
            builder: (_) =>
                PayPalPaymentWidget(routeArgument: args as RouteArgument));
      case '/RazorPay':
        return MaterialPageRoute(
            builder: (_) =>
                RazorPayPaymentWidget(routeArgument: args as RouteArgument));
      case '/OrderSuccess':
        return MaterialPageRoute(
            builder: (_) =>
                OrderSuccessWidget(routeArgument: args as RouteArgument));
      case '/OrderSuccessRetirada':
        return MaterialPageRoute(
            builder: (_) => OrderSuccessRetiradaWidget(
                routeArgument: args as RouteArgument));
      case '/Languages':
        return MaterialPageRoute(builder: (_) => LanguagesWidget());
      case '/Help':
        return MaterialPageRoute(builder: (_) => HelpWidget());
      case '/Settings':
        return MaterialPageRoute(builder: (_) => SettingsWidget());
      case '/Cidadela':
        return MaterialPageRoute(builder: (_) => CidadelaWidget());
      case '/CartaoRecusado':
        return MaterialPageRoute(builder: (_) => PagarmeCartaoRecusadoWidget());
      case '/Cidadela2':
        return MaterialPageRoute(builder: (_) => Cidadela2Widget());

      case '/FacebookLogin':
        return MaterialPageRoute(builder: (_) => FacebookLogin());

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(
            builder: (_) =>
                Scaffold(body: SafeArea(child: Text('Route Error'))));
    }
  }
}
