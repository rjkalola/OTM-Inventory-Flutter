import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/common/listener/DialogButtonClickListener.dart';


class AlertDialogHelper {
  static showAlertDialog(
      String title,
      String message,
      String textPositiveButton,
      String textNegativeButton,
      String textOtherButton,
      bool isCancelable,
      final DialogButtonClickListener? buttonClickListener,
      final String dialogIdentifier) {
    // set up the buttons
    List<Widget> listButtons = [];
    if (textNegativeButton.isNotEmpty) {
      Widget cancelButton = TextButton(
        child: Text(textNegativeButton),
        onPressed: () {
          if (buttonClickListener == null) {
            // Navigator.of(context).pop(); // dismis
            Get.back();// s dialog
          } else {
            buttonClickListener.onNegativeButtonClicked(dialogIdentifier);
          }
        },
      );
      listButtons.add(cancelButton);
    }

    if (textPositiveButton.isNotEmpty) {
      Widget positiveButton = TextButton(
        child: Text(textPositiveButton),
        onPressed: () {
          if (buttonClickListener == null) {
            // Navigator.of(context).pop(); //
            Get.back();
            // dismiss dialog
          } else {
            buttonClickListener.onPositiveButtonClicked(dialogIdentifier);
          }
        },
      );
      listButtons.add(positiveButton);
    }

    if (textOtherButton.isNotEmpty) {
      Widget otherButton = TextButton(
        child: Text(textOtherButton),
        onPressed: () {
          if (buttonClickListener == null) {
            // Navigator.of(context).pop(); // dismiss dialog
            Get.back();
          } else {
            buttonClickListener.onOtherButtonClicked(dialogIdentifier);
          }
        },
      );
      listButtons.add(otherButton);
    }
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: title.isNotEmpty?Text(title):null,
      content: message.isNotEmpty?Text(message):null,
      actions: listButtons,
    );
    // show the dialog

    Get.dialog(barrierDismissible: isCancelable,alert);
  }
}
