import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'favorites.dart';
import 'slideshow.dart';

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
    notifyParent();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setDouble('textSize', Constants.textInt);
    });
  }

  void updateTheme() {
    notifyParent();
    SharedPreferences.getInstance().then((pref) {
      var isDark = pref?.getBool('isDark') ?? false;
      pref.setBool('isDark', !isDark);
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
          updateText();
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
          Constants.textInt = Constants.textInt + 0.5;
          updateText();
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
            Constants().changeTheme();
            updateTheme();
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
            FirestoreSlideshowState.favorites = Set<String>();
            notifyParent();
            Favorites().updateFavorites();
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
