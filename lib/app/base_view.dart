import 'package:college_management/views/helper_classes/error_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../init_dependencies.dart';
import '../view_models/base_view_model.dart';
//
// class BaseView<T extends BaseViewModel> extends StatefulWidget {
//   final Widget Function(BuildContext context, T model, Widget? child) builder;
//   final Function(T model)? onModelReady;
//   final Function(T model) refresh;
//   final Function(T model)? onDispose;
//   final Function(T model)? onEventOccur;
//   final Function(T model)? onPopInvoked;
//   final String? Function(T model)? getPopWarningMessage;
//   final bool? isNestedView;
//
//   const BaseView({
//     super.key,
//     required this.builder,
//     this.onModelReady,
//     required this.refresh,
//     this.onDispose,
//     this.onEventOccur,
//     this.onPopInvoked,
//     this.getPopWarningMessage,
//     this.isNestedView,
//   });
//
//   @override
//   BaseViewState<T> createState() => BaseViewState<T>();
// }
//
// class BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
//   late T model = locator<T>();
//
//
//   @override
//   void initState() {
//     super.initState();
//     model.addListener(_eventListener);
//     if (widget.onModelReady != null && mounted) {
//       widget.onModelReady!(model);
//     }
//   }
//
//   @override
//   void dispose() {
//     if (widget.onDispose != null) {
//       widget.onDispose!(model);
//     }
//     super.dispose();
//   }
//
//   _eventListener() {
//     if (model.exception != null) {
//       _showErrorWarning();
//     }
//   }
//
//   _showErrorWarning() {
//     WidgetsBinding.instance.addPostFrameCallback(
//       (_) {
//         showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               contentPadding: EdgeInsets.zero,
//               content: ErrorView.showErrorView(
//                   context: context,
//                   retryMethod: () {
//                     model.retryMethod!();
//                   }),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<T>(
//         create: (BuildContext context) => model,
//         child: Consumer<T>(builder: widget.builder));
//   }
// }
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
  bool _isDialogOpen = false; // Track if dialog is open

  @override
  void initState() {
    super.initState();
    model.addListener(_eventListener);
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

  _eventListener() {
    if (model.exception != null) {
      _showErrorWarning();
    }
  }

  _showErrorWarning() {
    if (_isDialogOpen) return; // Prevent multiple dialogs

    _isDialogOpen = true;

    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: ErrorView.showErrorView(
                context: context,
                retryMethod: () {
                  model.retryMethod?.call();
                },
              ),
            );
          },
        ).then((_) {
          _isDialogOpen = false; // Reset when dialog is closed
          model.showException(error: null, retryMethod: () {}); // Clear exception
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // We handle back press manually
      onPopInvoked: (didPop) {
        if (didPop) return; // Prevent double pop

        if (_isDialogOpen) {
          Navigator.of(context).pop(); // Close dialog
        } else {
          // Check if it's the Home or Login screen
          bool isHomeOrLogin = ModalRoute.of(context)?.settings.name == "/home" ||
              ModalRoute.of(context)?.settings.name == "/login";

          if (!isHomeOrLogin) {
            Navigator.of(context).pop(); // Pop the current screen
          }
        }
      },
      child: ChangeNotifierProvider<T>(
        create: (BuildContext context) => model,
        child: Consumer<T>(builder: widget.builder),
      ),
    );
  }
}
