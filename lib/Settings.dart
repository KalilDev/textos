import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class DrawerSettings extends StatefulWidget {
  final Function() notifyParent;

  DrawerSettings({Key key, this.notifyParent}) : super(key: key);

  Widget header() {
    return Center(
        child: Text(
          Constants.textConfigs,
          style: Constants().textstyleText(),
        ));
  }

  createState() => DrawerSettingsState(notifyParent: notifyParent);
}

class DrawerSettingsState extends State<DrawerSettings> {
  final Function() notifyParent;

  DrawerSettingsState({Key key, @required this.notifyParent});

  void updateText() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setDouble('textSize', Constants.textInt);
    });
  }

  Widget textButtons(int i) {
    if (i == 1) {
      return IconButton(
        icon: Icon(
          Icons.arrow_downward,
          color: Constants.themeForeground,
        ),
        onPressed: () {
          if (Constants.textInt > 0.6) {
            Constants.textInt = Constants.textInt - 0.5;
          }
          notifyParent();
          updateText();
        },
      );
    } else {
      return IconButton(
        icon: Icon(
          Icons.arrow_upward,
          color: Constants.themeForeground,
        ),
        onPressed: () {
          Constants.textInt = Constants.textInt + 0.5;
          notifyParent();
          updateText();
        },
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
          onPressed: () {},
        ),
        Spacer(),
        IconButton(
          icon: Icon(
            Icons.favorite_border,
            color: Constants.themeForeground,
          ),
          onPressed: () {},
        ),
        Spacer(),
        textButtons(1),
        textButtons(0)
      ],
    );
  }
}
