import 'package:amazone_clone/utilities/show_generic_alert.dart';
import 'package:flutter/cupertino.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog(
          context: context,
          title: 'Log Out',
          content: 'Are you sure you want to Logout?',
          optionsBuilder: () => {'Log Out': true, 'Cancel': false})
      .then((value) => value ?? false);
}
