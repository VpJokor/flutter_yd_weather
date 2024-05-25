import 'package:flutter/cupertino.dart';

import '../utils/image_utils.dart';

class LoadAssetImage extends StatelessWidget {
  const LoadAssetImage(this.image,
      {super.key,
      this.width,
      this.height,
      this.fit,
      this.format = 'webp',
      this.color,
      this.gaplessPlayback = false})
      : super();

  final String image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final String format;
  final Color? color;
  final bool gaplessPlayback;

  @override
  Widget build(BuildContext context) {
    return Image.asset(ImageUtils.getImgPath(image, format: format),
        height: height,
        width: width,
        fit: fit,
        color: color,
        gaplessPlayback: gaplessPlayback);
  }
}
