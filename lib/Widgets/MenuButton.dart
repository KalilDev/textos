import 'package:flutter/material.dart';
import 'package:textos/Src/Constants.dart';

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'MenuButton',
      child: Tooltip(
          message: Constants.textTooltipDrawer,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
                customBorder: CircleBorder(),
                child:
                    Container(height: 60, width: 60, child: Icon(Icons.menu)),
                onTap: () => Scaffold.of(context).openDrawer()),
          )),
    );
  }
}
