import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:connectivity/connectivity.dart';

///
/// This hook will also return the the current app internet state.
///
/// useInternetConnectivity((result) => <do something with event>);
ConnectivityResult useInternetConnectivity(Function(ConnectivityResult result) lifecycleCallback,
    [List<Object> keys = const <dynamic>[]]) {
  return Hook.use(_InternetConnectivityHook(
    lifecycleCallback,
    keys: keys,
  ));
}

class _InternetConnectivityHook extends Hook<ConnectivityResult> {
  final Function(ConnectivityResult event) lifecycleCallback;

  const _InternetConnectivityHook(this.lifecycleCallback,
      {List<Object> keys = const <dynamic>[]})
      : assert(lifecycleCallback != null),
        assert(keys != null),
        super(keys: keys);

  @override
  HookState<ConnectivityResult, _InternetConnectivityHook> createState() {
    return _InternetConnectivityHookState();
  }

}

class _InternetConnectivityHookState
    extends HookState<ConnectivityResult, _InternetConnectivityHook>
    with WidgetsBindingObserver {
  ConnectivityResult newConnectivityResult;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initHook() {
    super.initHook();
    WidgetsBinding.instance.addObserver(this);
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
          newConnectivityResult = result;
          hook.lifecycleCallback(newConnectivityResult);
        });
  }

  @override
  ConnectivityResult build(BuildContext context) {
    //Fimber.d("ConnectivityResult build");

    return newConnectivityResult;
  }

  Future<void> _initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      print(e.toString());
    }
    newConnectivityResult = result;
    hook.lifecycleCallback(newConnectivityResult);
    return;
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

}