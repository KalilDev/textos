import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'constants.dart';
import 'main2.dart';

class DrawerSettings extends StatelessWidget {
  final Store<AppStateMain> store;

  DrawerSettings({Key key, @required this.store});

  Widget header() {
    return Center(
        child: Text(
          Constants.textConfigs,
          style: Constants().textstyleText(store.state.textSize),
        ));
  }

  Widget textButtons(int i) {
    if (i == 1) {
      return IconButton(
        icon: Icon(
          Icons.arrow_downward,
          color: Constants.themeForeground,
        ),
        onPressed: () {
          if (store.state.textSize > 0.6) {
            store.dispatch(UpdateTextSize(size: store.state.textSize - 0.5));
          }
        },
        tooltip: Constants.textTooltipTextSizeLess,
      );
    } else {
      return IconButton(
        icon: Icon(
          Icons.arrow_upward,
          color: Constants.themeForeground,
        ),
        onPressed: () {
          if (store.state.textSize > 0.6) {
            store.dispatch(UpdateTextSize(size: store.state.textSize + 0.5));
          }
        },
        tooltip: Constants.textTooltipTextSizePlus,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.color_lens,
            color: Constants.themeForeground,
          ),
          onPressed: () {
            store.dispatch(UpdateDarkMode(enable: !store.state.enableDarkMode));
          },
          tooltip: Constants.textTooltipTheme,
        ),
        Spacer(),
        IconButton(
          icon: Icon(
            Icons.delete_forever,
            color: Constants.themeForeground,
          ),
          onPressed: () {
            store.dispatch(UpdateFavorites(toClear: 1));
          },
          tooltip: Constants.textTooltipTrash,
        ),
        Spacer(),
        textButtons(1),
        textButtons(0)
      ],
    );
  }
}
