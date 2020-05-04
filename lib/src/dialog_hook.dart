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
  _DialogControllerHook({List<Object> keys = const <dynamic>[]})
      : super(keys: keys);

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

  /// Remove the dialog from screen.
  dismissDialog([dynamic result]) {
    if (dialogContext != null) {
      Navigator.of(dialogContext).pop(result);
      dialogContext = null;
    }
  }

  /// Creates and displays an alert dialog with a single button.
  /// [title], [content] can be null.
  /// [positiveAction] can be null, in which case an 'OK' text widget will be used.
  /// The [onDisplay] callback method is called just prior to the dialog being displayed.
  /// The [onDismissed] is called after then dialog is dismissed by the user, but just prior to it being removed from screen.
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
      if (positiveAction == null) {
        dismissAction = Text(Strings.dialogOkTitle.toUpperCase());
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

  /// Creates and displays an confirmation dialog with two buttons.
  /// [title], [content] can be null.
  /// [negativeAction] can be null, in which case an 'Cancel' text widget will be used.
  /// [positiveAction] can be null, in which case an 'OK' text widget will be used.
  /// The [onDisplay] callback method is called just prior to the dialog being displayed.
  ///   /// The [onNegative] is called after dialog is dismissed by the user select [negativeAction].
  /// The [onPositive] is called after dialog is dismissed by the user select [positiveAction].

  showConfirmationDialog({
    final Widget title,
    final Widget content,
    final Widget negativeAction,
    final Widget positiveAction,
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
                child: negativeAction != null
                    ? negativeAction
                    : Text(Strings.dialogCancelTitle.toUpperCase()),
                onPressed: () {
                  Navigator.of(context).pop();
                  dialogContext = null;
                  if (onNegative != null) {
                    onNegative();
                  }
                },
              ),
              FlatButton(
                child: positiveAction != null
                    ? positiveAction
                    : Text(Strings.dialogOkTitle.toUpperCase()),
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
