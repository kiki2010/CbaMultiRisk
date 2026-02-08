/*
Tutorial Dialogs
Last Edit: 08/02/2026
Change: Comments were added.
*/

//We imported the necessary libraries and widgets.
import 'package:flutter/material.dart';
import 'package:cbamultiriskv2/widgets/speechBubble.dart';
import 'package:cbamultiriskv2/widgets/avatar.dart';

//The Tutorial Dialog
Future<void> showTutorialDialog({
  required BuildContext context,
  required String message,
  required VoidCallback onNext,
  int suquiPose = 1,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          speechBubble(title: message),
          const SizedBox(height: 10),
          SuquiAvatar(
            posIndex: suquiPose,
            height: 200,
            onTap: onNext,
          )
        ],
      ),
    ),
  );
}