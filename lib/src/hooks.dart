import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

TextEditingController useTextEditingController([String initialText]) {
  return useMemoized(() => _ExtendedTextEditingController(initialText));
}

useFocusNode({
  String debugLabel,
  FocusOnKeyCallback onKey,
  bool skipTraversal = false,
  bool canRequestFocus = true,
  List<Object> keys = const <dynamic>[],
}) {
  return Hook.use(_FocusNodeHook(
    debugLabel,
    onKey,
    skipTraversal,
    canRequestFocus,
    keys,
  ));
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

class _FocusNodeHook extends Hook<FocusNode> {
  final String debugLabel;
  final FocusOnKeyCallback onKey;
  final bool skipTraversal;
  final bool canRequestFocus;

  _FocusNodeHook(
      this.debugLabel,
      this.onKey,
      this.skipTraversal,
      this.canRequestFocus,
      List<Object> keys,
      ) : super(keys: keys);

  @override
  HookState<FocusNode, Hook<FocusNode>> createState() {
    return _FocusNodeHookState();
  }
}

class _FocusNodeHookState extends HookState<FocusNode, _FocusNodeHook> {
  FocusNode value;

  @override
  void initHook() {
    value = FocusNode(
      debugLabel: hook.debugLabel,
      onKey: hook.onKey,
      skipTraversal: hook.skipTraversal,
      canRequestFocus: hook.canRequestFocus,
    );
    super.initHook();
  }

  @override
  FocusNode build(BuildContext context) {
    return value;
  }

  @override
  void dispose() {
    value.dispose();
    super.dispose();
  }
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
