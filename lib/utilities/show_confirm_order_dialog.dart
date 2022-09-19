import 'package:amazone_clone/utilities/show_generic_alert.dart';
import 'package:flutter/cupertino.dart';

Future<bool?> showConfirmOrderDialog(BuildContext context) {
  return showGenericDialog(
          context: context,
          title: "Confirm Order",
          content: "Are you sure you want to confirm order",
          optionsBuilder: () => {'Yes': true, 'Cancel': false})
      .then((value) => value ?? false);
}
