import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'resource/strings.dart';

///  Provide the hook for using dialog easily
///  There are two types dialog, alert and confirmation dialog.

DialogController useDialogController([List<Object> keys = const <dynamic>[]]) {
  return Hook.use(_DialogControllerHook(
    keys: keys,
  ));
}

class _DialogControllerHook extends Hook<DialogController> {
  _DialogControllerHook({List<Object> keys = const <dynamic>[]}) : super(keys: keys);

  @override
  HookState<DialogController, Hook<DialogController>> createState() {
    return _DialogControllerHookState();
  }
}

class _DialogControllerHookState
    extends HookState<DialogController, Hook<DialogController>> {
  DialogController value;

  @override
  DialogController build(BuildContext context) {
    if (value == null) {
      value = DialogController(context);
    }
    return value;
  }
}

class DialogController {
  final BuildContext context;
  BuildContext dialogContext;

  DialogController(this.context);

  dismissDialog([dynamic result]) {
    if (dialogContext != null) {
      Navigator.of(dialogContext).pop(result);
      dialogContext = null;
    }
  }

  ///  This is a dialog with one button. PositiveAction is the button.
  ///  We can set title, content and button.
  showAlertDialog({
    final Widget title,
    final Widget content,
    final Widget positiveAction,
    Function() onDisplay,
    Function() onDismissed,
  }) {
    WidgetsBinding.instance.scheduleFrameCallback((_) {
      if (dialogContext != null) {
        dismissDialog();
      }

      if (onDisplay != null) {
        onDisplay();
      }

      Widget dismissAction;
      if(positiveAction == null){
        dismissAction =  Text(Strings.dialogOkTitle.toUpperCase());
      } else {
        dismissAction = positiveAction;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context;
          return AlertDialog(
            title: title,
            content: content,
            actions: <Widget>[
              FlatButton(
                child: dismissAction,
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  dialogContext = null;
                  if (onDismissed != null) onDismissed();
                },
              ),
            ],
          );
        },
      );
    });
  }

  ///  This is a dialog with two buttons.
  ///  PositiveAction is the button on the right,negativeAction is on the left.
  ///  We can set title, content and  two button.
  showConfirmationDialog({
    final Widget title,
    final Widget content,
    final Widget positiveAction,
    final Widget negativeAction,
    Function onDisplay,
    Function onPositive,
    Function onNegative,
  }) {
    WidgetsBinding.instance.scheduleFrameCallback((_) {
      if (dialogContext != null) {
        dismissDialog();
      }

      if (onDisplay != null) {
        onDisplay();
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context;

          return AlertDialog(
            title: title,
            content: content,
            actions: <Widget>[
              FlatButton(
                child: negativeAction,
                onPressed: () {
                  Navigator.of(context).pop();
                  dialogContext = null;
                  if (onNegative != null) {
                    onNegative();
                  }
                },
              ),
              FlatButton(
                child: positiveAction,
                onPressed: () {
                  Navigator.of(context).pop();
                  dialogContext = null;
                  if (onPositive != null) {
                    onPositive();
                  }
                },
              ),
            ],
          );
        },
      );
    });
  }
}
