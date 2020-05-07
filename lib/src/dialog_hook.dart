import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'resource/strings.dart';

/// Creates a DialogController which can be used to build and display dialogs.
/// The dialogs are displayed on the next frame so it is safe to show dialogs
/// within a build method.
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

///Provides an easy way to show and dismiss dialogs. The dialogs are shown
///on the next frame so it's safe to show then from within a build method.
class DialogController {
  final BuildContext context;
  BuildContext dialogContext;

  DialogController(this.context);

  ///Removes a visible dialog from the screen. If a dialog is not currently visible, 
  ///this method will do nothing.
  dismissDialog([dynamic result]) {
    if (dialogContext != null) {
      Navigator.of(dialogContext).pop(result);
      dialogContext = null;
    }
  }

  ///Builds and displays an alert dialog (single action).
  ///[title] and [content] can be null. In which case nothing will be displayed
  ///in their respective area
  ///[positiveAction] can be null. In which case an OK Text widget will be used.
  ///[onDisplay] is a callback which is invoked prior to the dialog being displayed
  ///[onDismissed] is a callback which is invoked on user dismissal, just prior to
  ///the dialog being removed from screen.
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

  ///  Builds and displays a dialog with two actions [positiveAction] and
  ///  [negativeAction]
  ///  [title] and [content] can be null. In which case nothing will be displayed
  ///  in their respective area
  ///  [positiveAction] and [negativeAction] must be provided and cannot be null.
  ///  [onDisplay] is a callback which is invoked prior to the dialog being displayed
  ///  [onPositive] is a callback which is invoked on a positive action, just prior to
  ///  the dialog being removed from screen.
  ///  [onNegative] is a callback which is invoked on a negative action, just prior to
  ///  the dialog being removed from screen.
  showConfirmationDialog({
    final Widget title,
    final Widget content,
    @required final Widget negativeAction,
    @required final Widget positiveAction,
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
