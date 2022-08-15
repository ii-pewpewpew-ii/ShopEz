import 'package:flutter/material.dart';

typedef DialogueBoxBuilder<T> = Map<String, dynamic> Function();

Future<T?> showGenericDialog<T>(
    {required BuildContext context,
    required String title,
    required String content,
    required DialogueBoxBuilder<T> optionsBuilder}) {
  final options = optionsBuilder();
  return showDialog(
    context: context,
    builder: ((context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys
            .map(
              (optionsTitle) => TextButton(
                child: Text(optionsTitle),
                onPressed: () {
                  final optionValue = options[optionsTitle];
                  if (optionValue != null) {
                    Navigator.of(context).pop(optionValue);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
            )
            .toList(),
      );
    }),
  );
}
