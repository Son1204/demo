import 'package:flutter/material.dart';

Future<bool> confirm(
    BuildContext context, {
      Widget? title,
      Widget? content,
      Widget? textOK,
      Widget? textCancel,
    }) async {
  final bool? isConfirm = await showDialog<bool>(
    context: context,
    builder: (_) => WillPopScope(
      child: AlertDialog(
        title: title,
        content: content ?? const Text(''),
        actions: <Widget>[
          TextButton(
            child: textCancel ?? const Text('Hủy'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: textOK ?? const Text('Đồng ý'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
      onWillPop: () async {
        Navigator.pop(context, false);
        return true;
      },
    ),
  );

  return isConfirm ?? false;
}