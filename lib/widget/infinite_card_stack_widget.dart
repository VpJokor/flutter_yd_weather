import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InfiniteCardStackWidget extends StatefulWidget {
  const InfiniteCardStackWidget({
    super.key,
    this.initialIndex = 0,
    required this.ratio,
    required this.itemHeight,
    required this.itemBuilder,
    required this.itemCount,
    this.width,
    this.direction = AxisDirection.right,
    this.scale = 0.8,
    this.showCount = 3,
    this.paddingLeft = 0,
    this.paddingRight = 0,
    this.borderRadius,
    this.blurRadius = 0,
    this.shadowColor,
    this.onIndexChanged,
    this.curve = Curves.linear,
    this.duration,
    this.enableMove = true,
    this.useOpacity = true,
    this.enterAnim = false,
    this.enterDuration,
    this.enterDelayDuration,
  });

  /// 初始化下标
  final int initialIndex;

  /// item构造器
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// 数据集数量
  final int itemCount;

  /// 卡片宽高比
  final double ratio;

  /// 卡片缩放比例
  final double scale;

  /// 卡片布局方向
  final AxisDirection direction;

  /// 卡片显示个数
  final int showCount;

  /// 组件所占宽度（默认MediaQuery.of(context).size.width）
  final double? width;

  /// 卡片高度（不包含阴影）
  final double itemHeight;

  /// 左边距
  final double paddingLeft;

  /// 右边距
  final double paddingRight;

  /// 卡片圆角
  final BorderRadiusGeometry? borderRadius;

  /// 卡片阴影
  final double blurRadius;

  /// 卡片阴影颜色
  final Color? shadowColor;

  /// 卡片移动之后的回调
  final void Function(int index, int moveIndex)? onIndexChanged;

  /// 动画曲线
  final Curve curve;

  /// 动画持续时间
  final Duration? duration;

  /// 卡片是否支持手势移动
  final bool enableMove;

  /// 堆叠卡片是否使用透明度
  final bool useOpacity;

  /// 是否使用进场动画
  final bool enterAnim;

  /// 进场动画时长
  final Duration? enterDuration;

  /// 进场动画延迟时长
  final Duration? enterDelayDuration;

  @override
  State<StatefulWidget> createState() => InfiniteCardStackWidgetState();
}

class InfiniteCardStackWidgetState extends State<InfiniteCardStackWidget>
    with SingleTickerProviderStateMixin {
  double _offset = 0;
  int _index = 0;
  int _moveIndex = 0;
  Rect? _outsideRect;
  final _showingTempRect = <Rect>[];
  final _showingRect = <Rect>[];
  final _showingOpacity = <double>[];
  final _showingTempOpacity = <double>[];
  final _enterSlideOffsetX = <int, double>{};
  double _downX = 0;
  Duration _duration = Duration.zero;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _moveIndex = _index = _fixedIndex(widget.initialIndex);
    _generate();
  }

  @override
  void didUpdateWidget(covariant InfiniteCardStackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemCount != oldWidget.itemCount ||
        widget.ratio != oldWidget.ratio ||
        widget.blurRadius != oldWidget.blurRadius ||
        widget.borderRadius != oldWidget.borderRadius ||
        widget.shadowColor != oldWidget.shadowColor ||
        widget.showCount != oldWidget.showCount ||
        widget.paddingLeft != oldWidget.paddingLeft ||
        widget.paddingRight != oldWidget.paddingRight ||
        widget.scale != oldWidget.scale ||
        widget.width != oldWidget.width ||
        widget.itemHeight != oldWidget.itemHeight) {
      _generate(init: false);
    }
  }

  void _generate({bool init = true}) {
    if (widget.itemCount <= 0 || widget.showCount <= 0) {
      _showingRect.clear();
      _showingTempRect.clear();
      _showingOpacity.clear();
      _showingTempOpacity.clear();
      setState(() {});
      return;
    }
    _post((_) {
      final itemWidth = widget.width ?? MediaQuery.of(context).size.width;
      final firstItemHeight = _getHeight() - 2 * widget.blurRadius;
      final firstItemWidth = firstItemHeight * widget.ratio;
      _offset = widget.showCount <= 1
          ? 0
          : (itemWidth -
          widget.paddingLeft -
          firstItemWidth -
          widget.paddingRight) /
          (widget.showCount - 1);
      _showingRect.clear();
      _showingTempRect.clear();
      _showingRect.addAll(
        List.generate(widget.showCount + 1, (index) {
          final newIndex = index == 0 ? 0 : index - 1;
          double height = firstItemHeight *
              pow(widget.scale, widget.showCount - 1 - newIndex);
          final width = height * widget.ratio;
          final left = itemWidth -
              widget.paddingRight -
              widget.blurRadius -
              width -
              _offset * newIndex;
          final top = (firstItemHeight - height) / 2;
          final right = left + 2 * widget.blurRadius + width;
          final bottom = top + 2 * widget.blurRadius + height;
          return Rect.fromLTRB(left, top, right, bottom);
        }),
      );
      _showingTempRect.addAll([..._showingRect]);

      _showingOpacity.clear();
      _showingTempOpacity.clear();
      _showingOpacity.addAll(
        List.generate(widget.showCount + 1, (index) {
          if (index == 0) {
            return 0;
          } else {
            return 1 / widget.showCount * index;
          }
        }),
      );
      _showingTempOpacity.addAll([..._showingOpacity]);
      _print(
          "firstItemHeight = $firstItemHeight _offset = $_offset _showingRect = $_showingRect _showingOpacity = $_showingOpacity");
      final rect = _showingTempRect[_showingTempRect.length - 1];
      _outsideRect = _moveIndex <= 0
          ? null
          : Rect.fromLTRB(
        -rect.width,
        rect.top,
        0,
        rect.bottom,
      );
      if (init && widget.enterAnim) {
        _enter();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount <= 0 ||
        widget.showCount <= 0 ||
        _showingRect.isEmpty ||
        (widget.useOpacity && _showingOpacity.isEmpty)) {
      return const SizedBox.shrink();
    }
    final showingIndexes = _currentShowingIndexes().reversed.toList();
    final children = _mapIndexed(showingIndexes, (showingIndex, index) {
      final rect = _getOrNull(_showingRect, index) ?? Rect.zero;
      final opacity =
      widget.useOpacity ? (_getOrNull(_showingOpacity, index) ?? 0) : 1.0;
      return _buildItem(context, rect, opacity, showingIndex,
          index == widget.showCount, opacity);
    });
    final outsideRect = _outsideRect;
    final outsideIndex = _getOutsideIndex();
    if (outsideRect != null && outsideIndex >= 0) {
      children.add(_buildItem(context, outsideRect, 1, outsideIndex, true, 1));
    }
    return Transform(
      transform:
      Matrix4.rotationY(widget.direction == AxisDirection.right ? 0 : pi),
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        height: _getHeight(),
        child: widget.enableMove
            ? GestureDetector(
          onHorizontalDragDown: _onHorizontalDragDown,
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: children,
            ),
          ),
        )
            : Stack(
          children: children,
        ),
      ),
    );
  }

  void _onHorizontalDragDown(DragDownDetails details) {
    if (_isAnimating) return;
    final position = details.localPosition;
    _downX = position.dx;
    _print("onHorizontalDragDown position = $position");
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_isAnimating) return;
    final position = details.localPosition;
    final delta = details.delta;
    final offsetX = position.dx - _downX;
    double percent =
        offsetX / _showingTempRect[_showingTempRect.length - 1].width;
    if (percent > 1) percent = 1;
    if (percent < -1) percent = -1;
    _print(
        "onHorizontalDragUpdate offsetX = $offsetX percent = $percent delta = $delta");
    setState(() {
      if (_duration != Duration.zero) {
        _duration = Duration.zero;
      }
      final outsideRect = _outsideRect;
      if (outsideRect != null && outsideRect.right >= 0 && offsetX > 0) {
        final tempOutsideRect = outsideRect.translate(delta.dx, 0);
        final rect = _showingTempRect[_showingTempRect.length - 1];
        if (tempOutsideRect.right > rect.right) {
          _outsideRect = Rect.fromLTRB(
            rect.left,
            rect.top,
            rect.right,
            rect.bottom,
          );
        } else if (tempOutsideRect.right < 0) {
          _outsideRect = Rect.fromLTRB(
            -rect.width,
            rect.top,
            0,
            rect.bottom,
          );
        } else {
          _outsideRect = _outsideRect?.translate(delta.dx, 0);
        }
        for (int i = _showingRect.length - 1; i >= 0; i--) {
          final nextRect = _showingTempRect[i - 1 >= 0 ? i - 1 : 0];
          final nextOpacity = _showingTempOpacity[i - 1 >= 0 ? i - 1 : 0];
          final newRect = Rect.fromLTRB(
            _showingTempRect[i].left +
                (nextRect.left - _showingTempRect[i].left) * percent,
            _showingTempRect[i].top +
                (nextRect.top - _showingTempRect[i].top) * percent,
            _showingTempRect[i].right +
                (nextRect.right - _showingTempRect[i].right) * percent,
            _showingTempRect[i].bottom +
                (nextRect.bottom - _showingTempRect[i].bottom) * percent,
          );
          if (newRect.right <= nextRect.right || widget.showCount == 1) {
            _showingRect[i] = newRect;
            _showingOpacity[i] = _fixPercent((_showingTempOpacity[i] +
                (nextOpacity - _showingTempOpacity[i]) * percent)
                .abs());
          }
        }
      } else {
        for (int i = _showingRect.length - 1; i >= 0; i--) {
          if (i == _showingRect.length - 1) {
            final newRect = _showingRect[i].translate(delta.dx, 0);
            if (newRect.right <= _showingTempRect[i].right) {
              _showingRect[i] = newRect;
            } else {
              _downX = position.dx;
            }
          } else {
            final preRect = _showingTempRect[i + 1];
            final preOpacity = _showingTempOpacity[i + 1];
            final newRect = Rect.fromLTRB(
              _showingTempRect[i].left +
                  (_showingTempRect[i].left - preRect.left) * percent,
              _showingTempRect[i].top +
                  (_showingTempRect[i].top - preRect.top) * percent,
              _showingTempRect[i].right +
                  (_showingTempRect[i].right - preRect.right) * percent,
              _showingTempRect[i].bottom +
                  (_showingTempRect[i].bottom - preRect.bottom) * percent,
            );
            if (newRect.right <= _showingTempRect[i].right) {
              _showingRect[i] = newRect;
              _showingOpacity[i] = _fixPercent((_showingTempOpacity[i] +
                  (_showingTempOpacity[i] - preOpacity) * percent)
                  .abs());
            }
          }
        }
      }
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final position = details.localPosition;
    final offsetX = position.dx - _downX;
    final tempRect = _showingTempRect[_showingTempRect.length - 1];
    final isSame = _outsideRect != null && offsetX > 0
        ? _outsideRect ==
        Rect.fromLTRB(
          -tempRect.width,
          tempRect.top,
          0,
          tempRect.bottom,
        )
        : _showingRect[_showingRect.length - 1] == tempRect;
    if (_isAnimating) {
      if (isSame) {
        _isAnimating = false;
      }
      return;
    }
    final primaryVelocity = details.primaryVelocity ?? 0;
    double percent =
        offsetX / _showingTempRect[_showingTempRect.length - 1].width;
    if (percent > 1) percent = 1;
    if (percent < -1) percent = -1;
    debugPrint(
        "onHorizontalDragEnd percent = $percent primaryVelocity = $primaryVelocity");
    setState(() {
      _duration = widget.duration ?? const Duration(milliseconds: 400);
      _isAnimating = true;
      int index = _index;
      int moveIndex = _moveIndex;
      final outsideRect = _outsideRect;
      if (outsideRect != null && outsideRect.right > 0) {
        final rect = _showingTempRect[_showingTempRect.length - 1];
        if (outsideRect.right > outsideRect.width * 0.25 ||
            primaryVelocity > 1000) {
          _outsideRect = Rect.fromLTRB(
            rect.left,
            rect.top,
            rect.right,
            rect.bottom,
          );
          if (index <= 0) {
            index = widget.itemCount - 1;
          } else {
            index--;
            index = _fixedIndex(index);
          }
          moveIndex--;
          if (moveIndex < 0) moveIndex = 0;
          for (int i = _showingRect.length - 1; i >= 0; i--) {
            _showingRect[i] = _showingTempRect[i - 1 >= 0 ? i - 1 : 0];
            _showingOpacity[i] = _showingTempOpacity[i - 1 >= 0 ? i - 1 : 0];
          }
        } else {
          _outsideRect = Rect.fromLTRB(
            -rect.width,
            rect.top,
            0,
            rect.bottom,
          );
          _showingRect.clear();
          _showingRect.addAll([..._showingTempRect]);
          _showingOpacity.clear();
          _showingOpacity.addAll([..._showingTempOpacity]);
        }
      } else {
        if (percent < -0.25 || primaryVelocity < -1000) {
          index++;
          index = _fixedIndex(index);
          moveIndex++;
          for (int i = _showingRect.length - 1; i >= 0; i--) {
            if (i == _showingRect.length - 1) {
              final tempRect = _showingTempRect[i];
              _showingRect[i] = Rect.fromLTRB(
                  -tempRect.width, tempRect.top, 0, tempRect.bottom);
            } else {
              _showingRect[i] = _showingTempRect[i + 1];
              _showingOpacity[i] = _showingTempOpacity[i + 1];
            }
          }
        } else {
          _showingRect.clear();
          _showingRect.addAll([..._showingTempRect]);
          _showingOpacity.clear();
          _showingOpacity.addAll([..._showingTempOpacity]);
        }
      }
      _resetState(index, moveIndex);
    });
  }

  void _resetState(int index, int moveIndex, {VoidCallback? computation}) {
    _postDelayed(
        delayMilliseconds:
        (widget.duration ?? const Duration(milliseconds: 400))
            .inMilliseconds, () {
      final rect = _showingRect[_showingRect.length - 1];
      final isInScreen = rect.left > 0;
      debugPrint(
          "isInScreen = $isInScreen index = $index moveIndex = $moveIndex");
      if (!isInScreen || _outsideRect != null) {
        final tempRect = _showingTempRect[_showingTempRect.length - 1];
        setState(() {
          _index = index;
          _moveIndex = moveIndex;
          _outsideRect = moveIndex <= 0
              ? null
              : Rect.fromLTRB(
            -tempRect.width,
            tempRect.top,
            0,
            tempRect.bottom,
          );
          _duration = Duration.zero;
          _showingRect.clear();
          _showingRect.addAll([..._showingTempRect]);
          _showingOpacity.clear();
          _showingOpacity.addAll([..._showingTempOpacity]);
        });
      }
      _post((_) {
        _isAnimating = false;
        widget.onIndexChanged?.call(_index, _moveIndex);
        computation?.call();
      });
    });
  }

  void animateNext({VoidCallback? computation}) {
    if (_isAnimating) return;
    setState(() {
      _duration = widget.duration ?? const Duration(milliseconds: 400);
      _isAnimating = true;
      int index = _index;
      int moveIndex = _moveIndex;
      index++;
      index = _fixedIndex(index);
      moveIndex++;
      for (int i = _showingRect.length - 1; i >= 0; i--) {
        if (i == _showingRect.length - 1) {
          final tempRect = _showingTempRect[i];
          _showingRect[i] =
              Rect.fromLTRB(-tempRect.width, tempRect.top, 0, tempRect.bottom);
        } else {
          _showingRect[i] = _showingTempRect[i + 1];
          _showingOpacity[i] = _showingTempOpacity[i + 1];
        }
      }
      _resetState(index, moveIndex, computation: computation);
    });
  }

  void animatePrevious({VoidCallback? computation}) {
    if (_isAnimating) return;
    if (_moveIndex <= 0) return;
    setState(() {
      _duration = widget.duration ?? const Duration(milliseconds: 400);
      _isAnimating = true;
      int index = _index;
      int moveIndex = _moveIndex;
      final rect = _showingTempRect[_showingTempRect.length - 1];
      _outsideRect = Rect.fromLTRB(
        rect.left,
        rect.top,
        rect.right,
        rect.bottom,
      );
      if (index <= 0) {
        index = widget.itemCount - 1;
      } else {
        index--;
        index = _fixedIndex(index);
      }
      moveIndex--;
      if (moveIndex < 0) moveIndex = 0;
      for (int i = _showingRect.length - 1; i >= 0; i--) {
        _showingRect[i] = _showingTempRect[i - 1 >= 0 ? i - 1 : 0];
        _showingOpacity[i] = _showingTempOpacity[i - 1 >= 0 ? i - 1 : 0];
      }
      _resetState(index, moveIndex, computation: computation);
    });
  }

  void _enter() {
    if (_showingRect.isEmpty) return;
    final itemWidth = widget.width ?? MediaQuery.of(context).size.width;
    final showingIndexes = _currentShowingIndexes().reversed.toList();
    _enterSlideOffsetX.clear();
    _forEachIndexed(showingIndexes, (showingIndex, index) {
      final rect = _showingRect[index];
      _enterSlideOffsetX[showingIndex] =
          (rect.width + (itemWidth - rect.right)) / rect.width;
    });
    _post((_) {
      final enterDuration =
          widget.enterDuration ?? const Duration(milliseconds: 400);
      final enterDelayDuration = widget.enterDelayDuration ??
          Duration(milliseconds: enterDuration.inMilliseconds ~/ 2);
      _forEachIndexed(showingIndexes, (showingIndex, index) {
        _postDelayed(
            delayMilliseconds: enterDelayDuration.inMilliseconds *
                (index == 0 ? 0 : (showingIndexes.length - index)), () {
          setState(() {
            _enterSlideOffsetX[showingIndex] = 0;
          });
          if (index == 1) {
            _enterSlideOffsetX.clear();
          }
        });
      });
    });
  }

  void exit({VoidCallback? completion}) {
    if (_showingRect.isEmpty) return;
    final itemWidth = widget.width ?? MediaQuery.of(context).size.width;
    final showingIndexes = _currentShowingIndexes().reversed.toList();
    _enterSlideOffsetX.clear();
    _forEachIndexed(showingIndexes, (showingIndex, index) {
      _enterSlideOffsetX[showingIndex] = 0;
    });
    _post((_) {
      final enterDuration =
          widget.enterDuration ?? const Duration(milliseconds: 400);
      final enterDelayDuration = widget.enterDelayDuration ??
          Duration(milliseconds: enterDuration.inMilliseconds ~/ 2);
      _forEachIndexed(showingIndexes, (showingIndex, index) {
        _postDelayed(
            delayMilliseconds: enterDelayDuration.inMilliseconds * index, () {
          setState(() {
            final rect = _showingRect[index];
            _enterSlideOffsetX[showingIndex] =
                (rect.width + (itemWidth - rect.right)) / rect.width;
          });
          if (index == showingIndexes.length - 1) {
            if (completion != null) {
              _postDelayed(delayMilliseconds: enterDuration.inMilliseconds, () {
                completion.call();
              });
            }
          }
        });
      });
    });
  }

  Widget _buildItem(
      BuildContext context,
      Rect rect,
      double opacity,
      int index,
      bool showShadow,
      double ratio,
      ) {
    final offsetX = _enterSlideOffsetX[index];
    return AnimatedPositioned.fromRect(
      rect: rect,
      duration: _duration,
      curve: widget.curve,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: _duration,
        child: AnimatedSlide(
          offset: Offset(offsetX ?? 0, 0),
          duration: widget.enterDuration ?? const Duration(milliseconds: 400),
          curve: widget.curve,
          child: Padding(
            padding: EdgeInsets.all(widget.blurRadius),
            child: AnimatedContainer(
              width: double.infinity,
              height: double.infinity,
              duration: const Duration(milliseconds: 800),
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                boxShadow: showShadow
                    ? (widget.blurRadius > 0
                    ? [
                  BoxShadow(
                    color: widget.shadowColor ?? Colors.transparent,
                    blurRadius: widget.blurRadius,
                  )
                ]
                    : null)
                    : null,
              ),
              clipBehavior: Clip.hardEdge,
              child: Transform(
                transform: Matrix4.rotationY(
                    widget.direction == AxisDirection.right ? 0 : pi),
                alignment: Alignment.center,
                child: widget.itemBuilder.call(context, index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _fixedIndex(int index) {
    if (index < 0 || index >= widget.itemCount) {
      return 0;
    }
    return index;
  }

  double _getHeight() {
    return widget.itemHeight + 2 * widget.blurRadius;
  }

  List<int> _currentShowingIndexes() {
    final showCount = widget.showCount + 1;
    if (_index + showCount <= widget.itemCount) {
      return List.generate(showCount, (index) {
        return _index + index;
      });
    } else {
      final first = <int>[];
      if (_index < widget.itemCount) {
        first.addAll(List.generate(widget.itemCount - _index, (index) {
          return widget.itemCount - 1 - index;
        }).reversed);
      }
      final count = showCount - first.length;
      first.addAll(List.generate(count, (index) {
        return index % widget.itemCount;
      }));
      return first;
    }
  }

  int _getOutsideIndex() {
    if (_moveIndex <= 0) return -1;
    if (_index == 0) return widget.itemCount - 1;
    return _index - 1;
  }

  void _post(FrameCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback(callback);
  }

  void _postDelayed(VoidCallback callback, {int delayMilliseconds = 0}) async {
    await Future.delayed(Duration(milliseconds: delayMilliseconds), callback);
  }

  List<T> _mapIndexed<T, E>(
      List<E>? list, T Function(E element, int index) action) {
    if (list == null || list.isEmpty) return <T>[];
    int index = 0;
    return list.map((e) => action(e, index++)).toList();
  }

  void _forEachIndexed<E>(
      List<E>? list, void Function(E element, int index) action) {
    if (list == null) return;
    int index = 0;
    for (E element in list) {
      action(element, index);
      index++;
    }
  }

  E? _getOrNull<E>(List<E>? list, int index) {
    if (list == null) return null;
    return index >= 0 && index <= list.length - 1 ? list[index] : null;
  }

  double _fixPercent(double? percent, {double defValue = 0}) {
    if (percent == null) return defValue;
    if (percent > 1) return 1;
    if (percent < 0) return 0;
    return percent;
  }

  void _print(String? message) {
    if (!kReleaseMode) {
      debugPrint(message);
    }
  }
}
