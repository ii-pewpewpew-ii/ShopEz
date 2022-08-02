import 'package:flutter/material.dart';

void showSnackBox({
  required BuildContext context,
  required String content,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content)
      )
    );
}
