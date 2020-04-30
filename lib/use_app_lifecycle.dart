import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Provides access to a callback that triggers whenever the lifecycle state
/// changes. This will always trigger the first time with Lifecycle.onResume.
///
/// This hook will also return the the current app lifecycle state.
///
/// useAppLifecycle((event) => <do something with event>);
LifecycleEvent useAppLifecycle(Function(LifecycleEvent event) lifecycleCallback,
    [List<Object> keys = const <dynamic>[]]) {
  return Hook.use(_AppLifecycleHook(
    lifecycleCallback,
    keys: keys,
  ));
}

class _AppLifecycleHook extends Hook<LifecycleEvent> {
  final Function(LifecycleEvent event) lifecycleCallback;

  const _AppLifecycleHook(this.lifecycleCallback,
      {List<Object> keys = const <dynamic>[]})
      : assert(lifecycleCallback != null),
        assert(keys != null),
        super(keys: keys);

  @override
  HookState<LifecycleEvent, _AppLifecycleHook> createState() {
    return _AppLifecycleHookState();
  }

}

class _AppLifecycleHookState
    extends HookState<LifecycleEvent, _AppLifecycleHook>
    with WidgetsBindingObserver {
  LifecycleEvent currentEvent;

  @override
  void initHook() {
    super.initHook();
    WidgetsBinding.instance.addObserver(this);
    currentEvent = LifecycleEvent.onResume;
    hook.lifecycleCallback(currentEvent);
  }

  @override
  LifecycleEvent build(BuildContext context) {
    return currentEvent;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if(currentEvent != LifecycleEvent.onResume) {
          currentEvent = LifecycleEvent.onResume;
          hook.lifecycleCallback(LifecycleEvent.onResume);
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        if(currentEvent != LifecycleEvent.onPause) {
          currentEvent = LifecycleEvent.onPause;
          hook.lifecycleCallback(LifecycleEvent.onPause);
        }
        break;
      case AppLifecycleState.detached:
        break;
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

}

enum LifecycleEvent {
  onPause,
  onResume,
}