import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/utils/color_utils.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import '../res/colours.dart';
import '../res/gaps.dart';
import 'load_asset_image.dart';
import 'opacity_layout.dart';

/// 自定义AppBar
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    this.backgroundColor,
    this.title = '',
    this.centerTitle = '',
    this.centerText,
    this.titleColor = Colours.black,
    this.backImg = 'ic_close_icon',
    this.backImgColor,
    this.onBackPressed,
    this.rightIcon1,
    this.rightIcon2,
    this.rightIconColor,
    this.rightAction1,
    this.rightAction2,
    this.rightAction1Enabled = true,
    this.rightAction2Enabled = true,
    this.rightActionColor,
    this.onPressed,
    this.onRightIcon1Pressed,
    this.onRightIcon2Pressed,
    this.onRightAction1Pressed,
    this.onRightAction2Pressed,
    this.isBack = true,
    this.isBackEnabled = true,
    this.overlayStyle,
    this.needOverlayStyle = true,
    this.height,
  });

  final Color? backgroundColor;
  final String title;
  final Color titleColor;
  final String centerTitle;
  final Widget? centerText;
  final String backImg;
  final Color? backImgColor;
  final VoidCallback? onBackPressed;
  final String? rightIcon1;
  final String? rightIcon2;
  final Color? rightIconColor;
  final String? rightAction1;
  final String? rightAction2;
  final bool rightAction1Enabled;
  final bool rightAction2Enabled;
  final Color? rightActionColor;
  final VoidCallback? onPressed;
  final VoidCallback? onRightIcon1Pressed;
  final VoidCallback? onRightIcon2Pressed;
  final VoidCallback? onRightAction1Pressed;
  final VoidCallback? onRightAction2Pressed;
  final bool isBack;
  final bool isBackEnabled;
  final SystemUiOverlayStyle? overlayStyle;
  final bool needOverlayStyle;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = backgroundColor ?? Colours.white;

    final rightIcons = Positioned(
        right: 8.w,
        child: Row(
          children: [
            if (rightIcon2.isNotNullOrEmpty())
              IconButton(
                onPressed: onRightIcon2Pressed,
                tooltip: rightIcon2,
                padding: const EdgeInsets.all(12.0),
                icon: LoadAssetImage(
                  rightIcon2 ?? "",
                  color: rightIconColor ?? context.black,
                  width: 20.w,
                  height: 20.w,
                ),
              ),
            if (rightIcon1.isNotNullOrEmpty())
              IconButton(
                onPressed: onRightIcon1Pressed,
                tooltip: rightIcon1,
                padding: const EdgeInsets.all(12.0),
                icon: LoadAssetImage(
                  rightIcon1 ?? "",
                  color: rightIconColor ?? context.black,
                  width: 20.w,
                  height: 20.w,
                ),
              ),
          ],
        ));

    final rightActions = (rightAction1.isNotNullOrEmpty() ||
            rightAction2.isNotNullOrEmpty())
        ? Positioned(
            right: 0,
            child: Row(
              children: [
                if (rightAction2.isNotNullOrEmpty())
                  Tooltip(
                    message: rightAction2,
                    child: OpacityLayout(
                      onPressed:
                          rightAction2Enabled ? onRightAction2Pressed : null,
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Text(
                          rightAction2 ?? "",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: rightAction2Enabled
                                ? (rightActionColor ?? context.black)
                                : ColorUtils.adjustAlpha(
                                    rightActionColor ?? context.black, 0.2),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (rightAction1.isNotNullOrEmpty())
                  Tooltip(
                    message: rightAction1,
                    child: OpacityLayout(
                      onPressed:
                          rightAction1Enabled ? onRightAction1Pressed : null,
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Text(
                          rightAction1 ?? "",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: rightAction1Enabled
                                ? (rightActionColor ?? context.black)
                                : ColorUtils.adjustAlpha(
                                    rightActionColor ?? context.black, 0.2),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )
        : Gaps.empty;

    final Widget back = isBack
        ? IconButton(
            onPressed: isBackEnabled
                ? onBackPressed ??
                    () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      final isBack = await Navigator.maybePop(context);
                      if (!isBack) {
                        await SystemNavigator.pop();
                      }
                    }
                : null,
            tooltip: 'Back',
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            icon: LoadAssetImage(
              backImg,
              color: isBackEnabled
                  ? (backImgColor ?? context.black)
                  : ColorUtils.adjustAlpha(backImgColor ?? context.black, 0.2),
              width: 22.w,
              height: 22.w,
            ),
          )
        : Gaps.empty;

    final Widget titleWidget = Semantics(
      namesRoute: true,
      header: true,
      child: Container(
        alignment: centerTitle.isEmpty && centerText == null
            ? Alignment.centerLeft
            : Alignment.center,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: centerText ??
            Text(
              title.isEmpty ? centerTitle : title,
              style: TextStyle(
                fontSize: 18.sp,
                color: titleColor,
              ),
            ),
      ),
    );

    final content = Material(
      color: bgColor,
      child: SafeArea(
        bottom: false,
        child: height == null
            ? Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  titleWidget,
                  back,
                  rightIcons,
                  rightActions,
                ],
              )
            : SizedBox(
                height: height,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    titleWidget,
                    back,
                    rightIcons,
                    rightActions,
                  ],
                ),
              ),
      ),
    );
    return needOverlayStyle
        ? AnnotatedRegion<SystemUiOverlayStyle>(
            value: overlayStyle ??
                (ThemeData.estimateBrightnessForColor(bgColor) ==
                        Brightness.dark
                    ? SystemUiOverlayStyle.light
                    : SystemUiOverlayStyle.dark),
            child: content,
          )
        : content;
  }

  @override
  Size get preferredSize => Size.fromHeight(48.w);
}
