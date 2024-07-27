import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/utils/log.dart';
import '../res/colours.dart';

class MultipleStatusLayout extends StatelessWidget {
  const MultipleStatusLayout({
    super.key,
    required this.status,
    required this.content,
    this.onTap,
    this.title = "",
  }) : super();

  final int status;
  final VoidCallback? onTap;
  final Widget? content;
  final String title;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case LoadStatus.loading:
        return Container(
          alignment: Alignment.center,
          child: CupertinoActivityIndicator(
            animating: true,
            radius: 12.w,
          ),
        );
      case LoadStatus.error:
        return Container(
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colours.color999999,
            ),
          ),
        );
      case LoadStatus.success:
        return Container(
          alignment: Alignment.center,
          child: content,
        );
      default:
        return const Text("default");
    }
  }
}

class LoadStatus {
  static const int success = 1;
  static const int error = 2;
  static const int loading = 3;
}
