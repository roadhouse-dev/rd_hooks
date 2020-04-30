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
2. _InternetConnectivityHook: 
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