import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../init_dependencies.dart';
import '../view_models/base_view_model.dart';

class BaseView<T extends BaseViewModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Function(T model)? onModelReady;
  final Function(T model) refresh;
  final Function(T model)? onDispose;
  final Function(T model)? onEventOccur;
  final Function(T model)? onPopInvoked;
  final String? Function(T model)? getPopWarningMessage;
  final bool? isNestedView;

  const BaseView({
    super.key,
    required this.builder,
    this.onModelReady,
    required this.refresh,
    this.onDispose,
    this.onEventOccur,
    this.onPopInvoked,
    this.getPopWarningMessage,
    this.isNestedView,
  });

  @override
  BaseViewState<T> createState() => BaseViewState<T>();
}

class BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  late T model = locator<T>();


  @override
  void initState() {
    super.initState();
    if (widget.onModelReady != null && mounted) {
      widget.onModelReady!(model);
    }
  }

  @override
  void dispose() {
    if (widget.onDispose != null) {
      widget.onDispose!(model);
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
        create: (BuildContext context) => model,
        child: PopScope(child: Consumer<T>(builder: widget.builder)));
  }
}
