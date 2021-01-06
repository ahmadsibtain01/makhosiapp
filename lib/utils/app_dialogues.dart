import 'package:flutter/material.dart';
import 'package:makhosi_app/contracts/i_dialogue_button_clicked.dart';
import 'package:makhosi_app/ui/newfolder_popup.dart.dart';

class AppDialogues {
  static void showConfirmationDialogue({
    @required BuildContext context,
    @required String title,
    @required String label,
    @required String negativeButtonLabel,
    @required String positiveButtonLabel,
    @required IDialogueButtonClicked iDialogueButtonClicked,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(label),
        actions: [
          FlatButton(
            onPressed: () {
              iDialogueButtonClicked.onNegativeClicked();
            },
            child: Text(negativeButtonLabel),
          ),
          FlatButton(
            onPressed: () {
              iDialogueButtonClicked.onPositiveClicked();
            },
            child: Text(positiveButtonLabel),
          ),
        ],
      ),
    );
  }

  static showNewFolderPopup(context, controller, {onCreateFolder}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomNewFolderDialogBox(
          // formKey: formKey,
          folderNameController: controller,
          onCreateFolder: onCreateFolder,
        );
      },
    );
  }
}
