# RD Hooks

This is a flutter package that contains several hooks to speed up development.

## How to use

1. _AppLifecycleHook: Get current state of your app.
```dart
    useAppLifecycle((event) {
      if (event == LifecycleEvent.onResume) {
        Fimber.d("App onResume");
      }
    });
```
2. _InternetConnectivityHook: Monitor connectivity status.
```dart
    useInternetConnectivity((result) {
      switch (result) {
        case ConnectivityResult.wifi:
          Fimber.d("Get connectivity - wifi");
          break;
        case ConnectivityResult.mobile:
          Fimber.d("Get connectivity - mobile");
          break;
        case ConnectivityResult.none:
          Fimber.d("No connectivity.");
          break;
        default:
          Fimber.d("Failed to get connectivity.");
          break;
      }
    });
```
3. _DialogControllerHook: Help you create pop up alert or confirmation dialog.

Alert dialog:
```dart
    final dialogController = useDialogController();
    dialogController.showAlertDialog(
      title: Text('Title'),
      content: Text('Content'),
    );
```
4. _ExtendedTextEditingController: TextField controller 

```dart
   final emailTextController = useTextEditingController();
   emailTextController.text = "email";
   TextField(controller: emailTextController)
```

5. _MemoizedHook:
```dart
    final recorderService = useMemoizedWithDispose<RecorderService>(
      () => RecorderService(),
      (item) {
        if (item.isRecording) {
          item.cancelRecording();
        }
      },
    );
```

6. _WakeLockControllerHook
```dart
    final wakeLockController = useWakeLockController();
    wakeLockController.startWakeLock();

```