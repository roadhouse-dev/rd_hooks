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
  /// This is a wrapper of FocusNode,
  /// You can go into FocusNode source code to get more information.

  /// The [debugLabel] is ignored on release builds.
  final String debugLabel;
  /// Called if this focus node receives a key event while focused
  final FocusOnKeyCallback onKey;
  /// If true, tells the focus traversal policy to skip over this node for
  /// purposes of the traversal algorithm.
  ///
  /// This may be used to place nodes in the focus tree that may be focused, but
  /// not traversed, allowing them to receive key events as part of the focus
  /// chain, but not be traversed to via focus traversal.
  ///
  final bool skipTraversal;
  /// If true, this focus node may request the primary focus.
  ///
  /// Defaults to true.  Set to false if you want this node to do nothing when
  /// [requestFocus] is called on it. Does not affect the children of this node,
  /// and [hasFocus] can still return true if this node is the ancestor of a
  /// node with primary focus.
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
