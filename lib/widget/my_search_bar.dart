import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';

import '../res/colours.dart';
import '../res/gaps.dart';
import '../utils/toast_utils.dart';
import 'load_asset_image.dart';

class MySearchBar extends StatefulWidget implements PreferredSizeWidget {
  const MySearchBar({
    super.key,
    this.backgroundColor,
    this.text = "",
    this.hintText = "",
    this.searchHintText = "",
    this.submittedHintText = "",
    this.showDivider = false,
    this.isSafeArea = true,
    this.autofocus = true,
    this.readOnly = false,
    this.enabled = true,
    this.enableInteractiveSelection,
    this.backImg,
    this.onSubmitted,
    this.onChanged,
    this.debounced = false,
    this.debouncedMill = 400,
    this.onTap,
  });

  final Color? backgroundColor;
  final String text;
  final String hintText;
  final String searchHintText;
  final Widget? backImg;
  final String submittedHintText;
  final bool showDivider;
  final bool isSafeArea;
  final bool autofocus;
  final bool readOnly;
  final bool enabled;

  /// 长按是否展示【剪切/复制/粘贴菜单LengthLimitingTextInputFormatter】
  final bool? enableInteractiveSelection;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final bool debounced;
  final int debouncedMill;
  final VoidCallback? onTap;

  @override
  State<StatefulWidget> createState() => _MySearchBarState();

  @override
  Size get preferredSize => Size.fromHeight(48.5.w);
}

class _MySearchBarState extends State<MySearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  late _DebouncedChange _debouncedChange;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.text;
    _debouncedChange = _DebouncedChange(duration: Duration(milliseconds: widget.debouncedMill));
  }

  @override
  Widget build(BuildContext context) {
    final Widget backWidget =
        widget.backImg == null || !Navigator.canPop(context)
            ? SizedBox(
                width: 16.w,
                height: 48.w,
              )
            : Semantics(
                label: '返回',
                child: SizedBox(
                  width: 48.w,
                  height: 48.w,
                  child: InkWell(
                    onTap: () {
                      _focus.unfocus();
                      Navigator.maybePop(context);
                    },
                    borderRadius: BorderRadius.circular(24.w),
                    child: Padding(
                      key: const Key('search_back'),
                      padding: const EdgeInsets.all(18.0),
                      child: widget.backImg,
                    ),
                  ),
                ),
              );

    final Widget textField = Expanded(
      child: Container(
        height: 32.w,
        decoration: BoxDecoration(
          color: context.cardColor02,
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: TextField(
          key: const Key('search_text_field'),
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          controller: _controller,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          focusNode: _focus,
          textInputAction: TextInputAction.search,
          textAlign: TextAlign.start,
          onSubmitted: (String val) {
            _focus.unfocus();
            if (val.isNullOrEmpty()) {
              Toast.show(widget.submittedHintText);
            } else {
              // 点击软键盘的动作按钮时的回调
              widget.onSubmitted?.call(val);
            }
          },
          onChanged: (val) {
            if (widget.debounced) {
              _debouncedChange.run(() {
                widget.onChanged?.call(val);
              });
            } else {
              widget.onChanged?.call(val);
            }
            setState(() {});
          },
          onTap: widget.onTap,
          style: TextStyle(fontSize: 14.sp, color: context.textColor01),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            icon: Padding(
              padding: EdgeInsets.only(top: 8.w, bottom: 8.w, left: 8.w),
              child: const LoadAssetImage(
                'ic_search_home',
                color: Colours.color999999,
              ),
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(fontSize: 14.sp, color: Colours.color999999),
            suffixIcon: widget.readOnly || _controller.text.isEmpty
                ? null
                : GestureDetector(
                    child: Semantics(
                      label: '清空',
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 16.w, top: 10.w, bottom: 10.w),
                        child: const LoadAssetImage(
                          'search_clear_normal',
                        ),
                      ),
                    ),
                    onTap: () {
                      _controller.text = '';
                      widget.onChanged?.call("");
                      setState(() {});
                    },
                  ),
          ),
        ),
      ),
    );

    final content = Row(
      children: <Widget>[
        backWidget,
        textField,
        Gaps.generateGap(width: 8.w),
        if (widget.backImg == null && Navigator.canPop(context))
          Semantics(
            label: '取消',
            child: SizedBox(
              width: 48.w,
              height: 48.w,
              child: InkWell(
                onTap: () {
                  _focus.unfocus();
                  Navigator.maybePop(context);
                },
                borderRadius: BorderRadius.circular(24.w),
                child: Center(
                  child: Text(
                    "取消",
                    style:
                        TextStyle(fontSize: 14.sp, color: Colours.color333333),
                  ),
                ),
              ),
            ),
          ),
        if (widget.backImg != null || !Navigator.canPop(context))
          Gaps.generateGap(width: 16.w),
      ],
    );

    final contentWidget = Column(
      children: [
        content,
        if (widget.showDivider)
          Gaps.generateDivider(
              height: 0.5.w, color: context.dividerThemeData.color),
      ],
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.systemUiOverlayStyle,
      child: Material(
        color: widget.backgroundColor,
        child: widget.isSafeArea
            ? SafeArea(
                child: contentWidget,
              )
            : contentWidget,
      ),
    );
  }
}

class _DebouncedChange {
  final Duration duration;
  Timer? _timer;

  _DebouncedChange({required this.duration});

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }
}
