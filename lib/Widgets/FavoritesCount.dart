import 'package:flutter/material.dart';
import 'package:textos/Constants.dart';
import 'package:textos/Widgets/Widgets.dart';

class FavoritesCount extends StatelessWidget {
  const FavoritesCount({
    Key key,
    @required this.textSize,
    @required this.favorites,
    @required this.blurEnabled,
  }) : super(key: key);

  final double textSize;
  final int favorites;
  final bool blurEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        BlurOverlay(
          enabled: blurEnabled,
          radius: 90,
          child: Material(
            color: Colors.transparent,
            elevation: 15.0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.red.withAlpha(160),
                  borderRadius: BorderRadius.circular(200)),
              height: textSize * 8.0 + 10.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(width: 5.0),
                  Text(favorites.toString(),
                      style: Constants().textstyleTitle(textSize)),
                  Icon(
                    Icons.favorite,
                    size: textSize * 6.0,
                  ),
                  SizedBox(width: 5.0),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10.0)
      ],
    );
  }
}
