import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

appMessage({
  required String text,
  required BuildContext context,
  bool success = true, // default to success
}) {
  var snackBar = SnackBar(
    elevation: 0,
    duration: const Duration(seconds: 2),
    behavior: SnackBarBehavior.fixed,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: text,
      message: '', // optional detail
      contentType: success ? ContentType.success : ContentType.failure,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
