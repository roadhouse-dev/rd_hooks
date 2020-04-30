import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:wakelock/wakelock.dart';

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

class WakeLockController {
  startWakeLock() async {
    if (!(await Wakelock.isEnabled)) {
      Wakelock.enable();
    }
  }

  stopWakeLock() async {
    if (await Wakelock.isEnabled) {
      Wakelock.disable();
    }
  }
}
