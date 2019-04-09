import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textos/constants.dart';
import 'package:textos/favorites.dart';
import 'package:textos/slideshow.dart';


void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('isDark') == true) {
    Constants().setDarkTheme();
  } else {
    Constants().setWhiteTheme();
  }
  runApp(new MyApp());
  FirestoreSlideshowState.favorites =
      prefs?.getStringList('favorites')?.toSet() ?? Set<String>();
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
        drawer: FavoritesDrawer(),
        body: FirestoreSlideshow(notifyParent: refresh),
      ),
      theme: Constants.themeData,);
  }
}
