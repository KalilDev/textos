import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textos/constants.dart';
import 'package:textos/favorites.dart';
import 'package:textos/slideshow.dart';


void main() async {
  SystemChrome.setEnabledSystemUIOverlays([]);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('isDark') == true) {
    Constants().setDarkTheme();
  } else {
    Constants().setWhiteTheme();
  }
  runApp(new MyApp());
  FirestoreSlideshowState.favorites =
      prefs?.getStringList('favorites')?.toSet() ?? Set<String>();
  Constants.textInt =
      prefs?.getDouble('textSize') ?? 4.5;
}

class MyApp extends StatelessWidget {
  final PageController ctrl = PageController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldApp();
  }
}

class ScaffoldApp extends StatefulWidget {
  createState() => ScaffoldAppState();
}

class ScaffoldAppState extends State<ScaffoldApp> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
        appBar: Constants().appbarTransparent(),
        drawer: FavoritesDrawer(notifyParent: refresh),
        body: FirestoreSlideshow(notifyParent: refresh),
      ),
      theme: Constants.themeData,);
  }
}
