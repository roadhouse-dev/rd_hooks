import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

TextEditingController useExtendedEditingController([String initialText]) {
  return useMemoized(() => _ExtendedTextEditingController(initialText));
}

T useMemoizedWithDispose<T>(
    T Function() valueBuilder, Function(T value) onDispose,
    [List<Object> keys = const <dynamic>[]]) {
  return Hook.use(_MemoizedHook(
    valueBuilder,
    onDispose,
    keys: keys,
  ));
}

class _ExtendedTextEditingController extends TextEditingController {
  _ExtendedTextEditingController([String initialText])
      : super(text: initialText);

  @override
  set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
    }
  }
}

class _MemoizedHook<T> extends Hook<T> {
  final T Function() valueBuilder;
  final T Function(T value) onDispose;

  const _MemoizedHook(this.valueBuilder, this.onDispose,
      {List<Object> keys = const <dynamic>[]})
      : assert(valueBuilder != null),
        assert(keys != null),
        super(keys: keys);

  @override
  _MemoizedHookState<T> createState() => _MemoizedHookState<T>();
}

class _MemoizedHookState<T> extends HookState<T, _MemoizedHook<T>> {
  T value;

  @override
  void initHook() {
    super.initHook();
    value = hook.valueBuilder();
  }

  @override
  T build(BuildContext context) {
    return value;
  }

  @override
  void dispose() {
    hook.onDispose(value);
    super.dispose();
  }
}
