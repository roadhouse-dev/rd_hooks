import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:wakelock/wakelock.dart';

///Creates a wake lock controller which can be used to stop the screen from
///going to sleep. Any wake locks will automatically be removed when the view
///is disposed.
WakeLockController useWakeLockController(
    [List<Object> keys = const <dynamic>[]]) {
  return Hook.use(_WakeLockControllerHook(keys: keys));
}

class _WakeLockControllerHook extends Hook<WakeLockController> {
  _WakeLockControllerHook({List<Object> keys}) : super(keys: keys);

  @override
  HookState<WakeLockController, _WakeLockControllerHook> createState() {
    return _WakeLockControllerHookState();
  }
}

class _WakeLockControllerHookState
    extends HookState<WakeLockController, _WakeLockControllerHook> {
  WakeLockController _wakeLockController;

  @override
  void initHook() {
    _wakeLockController = WakeLockController();
    super.initHook();
  }

  @override
  WakeLockController build(BuildContext context) {
    return _wakeLockController;
  }

  @override
  void dispose() {

    _wakeLockController.stopWakeLock();
    super.dispose();
  }
}

///Provides the ability to enable and disable a wake lock which will stop the
///screen from going to sleep.
class WakeLockController {

  ///Starts a wake lock disabling the auto sleep functionality of the device. If
  ///a wake lock is already in place this call will be ignored.
  startWakeLock() async {
    if (!(await Wakelock.isEnabled)) {
      Wakelock.enable();
    }
  }

  ///Removes an existing wake lock. If a wake lock is not already in place, this
  ///call will be ignored.
  stopWakeLock() async {
    if (await Wakelock.isEnabled) {
      Wakelock.disable();
    }
  }
}
