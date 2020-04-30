# RD Hooks

This is a flutter package that contains several hooks to speed up development.

## How to use

1. AppLifecycleHook: Get current state of you app.

    useAppLifecycle((event) {
      if (event == LifecycleEvent.onResume) {
        Fimber.d("App onResume");
      }
    });

