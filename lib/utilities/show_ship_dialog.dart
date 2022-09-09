import 'package:amazone_clone/utilities/show_generic_alert.dart';
import 'package:flutter/cupertino.dart';

Future<bool> showShipDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Ship Item',
      content:
          'A ShopEz representative will arrive shortly to receive the package for delivery if you confirm',
      optionsBuilder: () =>
          {'Confirm': true, 'Cancel': false}).then((value) => value ?? false);
}
