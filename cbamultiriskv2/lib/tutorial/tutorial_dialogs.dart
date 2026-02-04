import 'package:flutter/material.dart';
import 'package:cbamultiriskv2/widgets/speechBubble.dart';
import 'package:cbamultiriskv2/widgets/avatar.dart';
import 'package:provider/provider.dart';

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