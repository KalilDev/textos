import 'package:flutter/material.dart';
import 'package:textos/ui/widgets.dart';
import 'package:transformer_page_view/parallax.dart';

class ImageBackground extends StatelessWidget {
  const ImageBackground({
    Key key,
    @required this.img,
    @required this.enabled,
    this.position = 0.0,
    this.height,
  }) : super(key: key);

  final String img;
  final bool enabled;
  final double position;
  final double height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constrains) {
      return Container(
          height: height != null ? height : constrains.maxHeight,
          width: constrains.maxWidth,
          child: BlurOverlay(
              child: img != 'null'
                  ? ParallaxImage.cachedNetwork(img, position: position)
                  : NullWidget(),
              radius: 20,
              enabled: enabled));
    });
  }
}
