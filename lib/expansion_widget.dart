library expansion_widget;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const Duration _kExpand = Duration(milliseconds: 200);

/// A widget with a customizable title that can expands or collapses
/// the widget to reveal or hide the [content].
class ExpansionWidget extends StatefulWidget {
  /// Creates a  widget with a customizable title that can expands or collapses
  /// the widget to reveal or hide the [content].
  const ExpansionWidget({
    Key? key,
    required this.titleBuilder,
    this.onExpansionChanged,
    required this.content,
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.expandedAlignment,
    this.onSaveState,
    this.onRestoreState,
  }) : super(key: key);

  /// The builder of title.
  ///
  /// Typically a [Button] widget that call [toogleFunction] when pressed.
  final Widget Function(double animationValue, double easeInValue,
      bool isExpaned, Function({bool animated}) toogleFunction) titleBuilder;

  final void Function(bool isExpanded)? onSaveState;
  final bool? Function()? onRestoreState;

  /// Called when the widget expands or collapses.
  ///
  /// When the widget starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final void Function(bool)? onExpansionChanged;

  /// The widget that are displayed when the expansionWidget expands.
  final Widget content;

  /// Specifies if the expansionWidget is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  /// Specifies whether the state of the content is maintained when the expansionWidget expands and collapses.
  ///
  /// When true, the content are kept in the tree while the expansionWidget is collapsed.
  /// When false (default), the content are removed from the tree when the expansionWidget is
  /// collapsed and recreated upon expansion.
  final bool maintainState;

  /// Specifies the alignment of [content], which are arranged in a column when
  /// the expansionWidget is expanded.
  ///
  /// The internals of the expanded expansionWidget make use of a [Column] widget for
  /// [content], and [Align] widget to align the column. The `expandedAlignment`
  /// parameter is passed directly into the [Align].
  ///
  /// Modifying this property controls the alignment of the column within the
  /// expanded expansionWidget.
  ///
  /// When the value is null, the value of `expandedAlignment` is [Alignment.center].
  final Alignment? expandedAlignment;

  @override
  _ExpansionWidgetState createState() => _ExpansionWidgetState();
}

class _ExpansionWidgetState extends State<ExpansionWidget>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  late AnimationController _controller;
  late Animation<double> _heightFactor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);

    _isExpanded = widget.onRestoreState?.call() ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void expand() {
    _setExpanded(true, true);
  }

  void collapse() {
    _setExpanded(false, true);
  }

  void toggle({bool animated = true}) {
    _setExpanded(!_isExpanded, animated);
  }

  void _setExpanded(bool isExpanded, bool animated) {
    if (_isExpanded == isExpanded) {
      return;
    }
    setState(() {
      _isExpanded = isExpanded;
      if (animated) {
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse().then<void>((value) {
            setState(() {
              // Rebuild without widget.children.
            });
          });
        }
      } else {
        if (_isExpanded) {
          _controller.value = 1.0;
        } else {
          _controller.value = 0.0;
        }
      }
      widget.onSaveState?.call(_isExpanded);
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        widget.titleBuilder(
            _controller.value, _heightFactor.value, _isExpanded, toggle),
        ClipRect(
          child: Align(
            alignment: widget.expandedAlignment ?? Alignment.center,
            heightFactor: _heightFactor.value,
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(ExpansionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final expand = widget.onRestoreState?.call();
    if (expand != null && expand != _isExpanded) {
      toggle();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final expand = widget.onRestoreState?.call();
    if (expand != null && expand != _isExpanded) {
      toggle();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
        child: TickerMode(
          child: widget.content,
          enabled: !closed,
        ),
        offstage: closed);

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}
