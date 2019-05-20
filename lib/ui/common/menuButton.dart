import 'package:flutter/material.dart';
import 'package:textos/constants.dart';

class MenuButton extends StatelessWidget {
  final data;
  final BuildContext exitContext;

  MenuButton({this.data, this.exitContext});

  @override
  Widget build(BuildContext context) {
    final canPop = data != null && Navigator.of(exitContext).canPop();
    pop() => Navigator.of(exitContext).pop(data);
    openDrawer() => Scaffold.of(context).openDrawer();

    return Hero(
      tag: 'MenuButton',
      child: Tooltip(
          message: canPop ? Constants.textBack : Constants.textTooltipDrawer,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
                customBorder: CircleBorder(),
                child:
                Container(height: 60,
                    width: 60,
                    child: Icon(canPop ? Icons.arrow_back : Icons.menu)),
                onTap: () => canPop ? pop() : openDrawer()),
          )),
    );
  }
}
