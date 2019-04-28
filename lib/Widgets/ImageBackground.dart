import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:textos/Widgets/Widgets.dart';

class ImageBackground extends StatelessWidget {
  const ImageBackground({
    Key key,
    @required this.img,
    @required this.enabled,
  }) : super(key: key);

  final String img;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constrains) {
      return Container(
          height: constrains.maxHeight,
          width: constrains.maxWidth,
          child: BlurOverlay(
              child: img != 'null'
                  ? CachedNetworkImage(
                      imageUrl: img,
                      fit: BoxFit.cover,
                    )
                  : null,
              radius: 20,
              enabled: enabled));
    });
  }
}
