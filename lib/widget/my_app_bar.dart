import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import '../res/colours.dart';
import '../res/gaps.dart';
import 'load_asset_image.dart';

/// 自定义AppBar
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    this.backgroundColor,
    this.title = '',
    this.centerTitle = '',
    this.titleColor = Colours.black,
    this.backImg = 'ic_close_icon',
    this.backImgColor,
    this.rightIcon1,
    this.rightIcon2,
    this.rightIconColor,
    this.onPressed,
    this.onRightIcon1Pressed,
    this.onRightIcon2Pressed,
    this.isBack = true,
    this.overlayStyle,
    this.height,
  });

  final Color? backgroundColor;
  final String title;
  final Color titleColor;
  final String centerTitle;
  final String backImg;
  final Color? backImgColor;
  final String? rightIcon1;
  final String? rightIcon2;
  final Color? rightIconColor;
  final VoidCallback? onPressed;
  final VoidCallback? onRightIcon1Pressed;
  final VoidCallback? onRightIcon2Pressed;
  final bool isBack;
  final SystemUiOverlayStyle? overlayStyle;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = backgroundColor ?? Colours.white;

    final SystemUiOverlayStyle overlayStyle = this.overlayStyle ??
        (ThemeData.estimateBrightnessForColor(bgColor) == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark);

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

    final Widget back = isBack
        ? IconButton(
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              final isBack = await Navigator.maybePop(context);
              if (!isBack) {
                await SystemNavigator.pop();
              }
            },
            tooltip: 'Back',
            padding: EdgeInsets.symmetric(horizontal:  24.w),
            icon: LoadAssetImage(
              backImg,
              color: backImgColor ?? context.black,
              width: 22.w,
              height: 22.w,
            ),
          )
        : Gaps.empty;

    final Widget titleWidget = Semantics(
      namesRoute: true,
      header: true,
      child: Container(
        alignment:
            centerTitle.isEmpty ? Alignment.centerLeft : Alignment.center,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Text(
          title.isEmpty ? centerTitle : title,
          style: TextStyle(
            fontSize: 18.sp,
            color: titleColor,
          ),
        ),
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Material(
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
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(48.w);
}
