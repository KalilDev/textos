import 'package:flutter/material.dart';

import 'constants.dart';

class DrawerSettings extends StatefulWidget {
  Widget header() {
    return Center(
        child: Text(
      'Configurações',
      style: Constants().textstyleText(),
    ));
  }

  createState() => DrawerSettingsState();
}

class DrawerSettingsState extends State<DrawerSettings> {
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
        IconButton(
          icon: Icon(
            Icons.arrow_downward,
            color: Constants.themeForeground,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_upward,
            color: Constants.themeForeground,
          ),
          onPressed: () {},
        )
      ],
    );
  }
}
