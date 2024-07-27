import 'package:flutter/material.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';

class AnimatedListItem extends StatefulWidget {
  final Widget child;

  /// the index of this item in List etc.
  final int index;

  /// amount of all these items
  final int length;

  final int startIndex;
  final int endIndex;

  final AnimationController aniController;

  ///  animation curves
  final Curve curve;

  /// use fade-in effect or not
  final bool fadeIn;

  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    required this.length,
    required this.aniController,
    this.curve = Curves.linear,
    this.fadeIn = true,
    this.startIndex = 0,
    int? endIndex,
  }) : endIndex = (endIndex == null || endIndex < 0 || endIndex > length - 1)
            ? length - 1
            : endIndex;

  @override
  State<StatefulWidget> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with TickerProviderStateMixin {
  Animation<double> itemAnimation(double begin) {
    final length = (widget.startIndex - widget.endIndex).abs() + 1;
    final delay = (length - 1) / ((length + 1) * length);
    double start = delay * widget.index;
    double end = 1 - delay * (length - widget.index - 1);
    if (widget.startIndex > widget.endIndex) {
      start = (widget.index > widget.startIndex || widget.index < widget.endIndex) ? 0 : delay * (length - widget.index - 1);
      end = (widget.index > widget.startIndex || widget.index < widget.endIndex) ? 0 : 1 - delay * widget.index;
    } else {
      start = (widget.index < widget.startIndex || widget.index > widget.endIndex) ? 0 : delay * widget.index;
      end = (widget.index < widget.startIndex || widget.index > widget.endIndex) ? 0 : 1 - delay * (length - widget.index - 1);
    }

    return Tween<double>(begin: begin, end: 1).animate(CurvedAnimation(
      parent: widget.aniController,
      curve: Interval(
        start.fixPercent(),
        end.fixPercent(),
        curve: widget.curve,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: itemAnimation(0),
      builder: (BuildContext context, child) {
        if (widget.fadeIn) {
          child = FadeTransition(
            opacity: itemAnimation(0),
            child: child,
          );
        }
        return Transform.scale(
          alignment: Alignment.center,
          scale: itemAnimation(0.9).value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
