import 'package:amazone_clone/utilities/show_generic_alert.dart';
import 'package:flutter/cupertino.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Delete Item',
      content:
          'Are you sure you want to delete this item from your ShopEz listing',
      optionsBuilder: () =>
          {'Delete': true, 'Cancel': false}).then((value) => value ?? false);
}
