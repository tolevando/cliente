import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/address.dart' as model;
import '../models/payment_method.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'cart_controller.dart';

class DeliveryPickupController extends CartController {
  List<model.Address> addresses = <model.Address>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  model.Address deliveryAddress;
  PaymentMethodList list;
  //retirada nao pode cobrar taxa de entrega

  DeliveryPickupController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    super.listenForCarts();
    listenForDeliveryAddress();
    listenForAddresses();

    print(this.list);
    if (this.list != null) {
      print("to aqui");
    }

    print(settingRepo.deliveryAddress.value.toMap());
  }

  void listenForDeliveryAddress() async {
    this.deliveryAddress = settingRepo.deliveryAddress.value;
  }

  void addAddress(model.Address address) {
    userRepo.addAddress(address).then((value) {
      setState(() {
        settingRepo.deliveryAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).new_address_added_successfully),
      ));
    });
  }

  void updateAddress(model.Address address) {
    userRepo.updateAddress(address).then((value) {
      setState(() {
        settingRepo.deliveryAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).the_address_updated_successfully),
      ));
    });
  }

  PaymentMethod getPickUpMethod() {
    return list.pickupList.elementAt(0);
  }

  PaymentMethod getDeliveryMethod() {
    return list.pickupList.elementAt(1);
  }

  void toggleDelivery(isFirst) {
    list.pickupList.forEach((element) {
      if (element != getDeliveryMethod()) {
        element.selected = false;
      }
    });

    var isSelectedItem = false;

    addresses.forEach((elementAddress) {
      if (elementAddress.selected) {
        isSelectedItem = true;
      }
    });

    setState(() {
      getDeliveryMethod().selected = isSelectedItem;

      if (isFirst) {
        getDeliveryMethod().selected = !getDeliveryMethod().selected;
      }

      if (getDeliveryMethod().selected) {
        isRetirada = false;
      }
    });
  }

  void setSelectItem(id) {
    addresses.forEach((element) {
      element.selected = false;
      if (element.id == id) {
        this.updateAddress(element);
        element.selected = true;
      }
    });
  }

  void togglePickUp() {
    list.pickupList.forEach((element) {
      if (element != getPickUpMethod()) {
        element.selected = false;
      }
    });
    setState(() {
      getPickUpMethod().selected = !getPickUpMethod().selected;
      if (getPickUpMethod().selected) {
        isRetirada = true;
      } else {
        isRetirada = false;
      }
    });
  }

  PaymentMethod getSelectedMethod() {
    return list.pickupList.firstWhere((element) => element.selected);
  }

  @override
  void goCheckout(BuildContext context) {
    Navigator.of(context).pushNamed(getSelectedMethod().route);
  }

  void listenForAddresses({String message}) async {
    final Stream<model.Address> stream = await userRepo.getAddresses();
    stream.listen((model.Address _address) {
      setState(() {
        addresses.add(_address);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }
}
