import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/favoritesHelper.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/loginView.dart';
import 'package:textos/ui/mainView.dart';

import 'src/model/favorite.dart';

// TODO(KalilDev): Document the app
// TODO(KalilDev): Implement tutorial
// TODO(KalilDev): Implement Firebase analytics
// TODO(KalilDev): Let authors upload texts from the app
// TODO(KalilDev): Make tapping the notification open the respective text

void main() => runApp(
      ChangeNotifierProvider<AuthService>(
        child: MyApp(),
        builder: (BuildContext context) {
          return AuthService();
        },
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: Provider.of<AuthService>(context).getUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // log error to console
          if (snapshot.error != null) {
            return Text(snapshot.error.toString());
          }

          // redirect to the proper page
          return snapshot.hasData
              ? StateBuilder(snapshot.data)
              : MaterialApp(
                  theme: themeDataLight,
                  darkTheme: themeDataDark,
                  home: LoginView());
        } else {
          // show loading indicator
          return MaterialApp(
              theme: themeDataLight,
              darkTheme: themeDataDark,
              home: Scaffold(body: LoadingCircle()));
        }
      },
    );
  }
}

class LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: const CircularProgressIndicator(),
        alignment: const Alignment(0.0, 0.0),
      ),
    );
  }
}

class StateBuilder extends StatelessWidget {
  const StateBuilder(this.firebaseUser);
  final FirebaseUser firebaseUser;

  Future<List<dynamic>> getInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool _enableDarkMode = prefs?.getBool('isDark') ?? false;
    final List<String> _favoritesSettings =
        prefs?.getStringList('favorites') ?? <String>[];
    final double _textSize = prefs?.getDouble('textSize') ?? 4.5;
    final int _blurSettings = prefs?.getInt('blurSettings') ?? 1;
    final List<dynamic> result = <dynamic>[
      _enableDarkMode,
      _favoritesSettings,
      _textSize,
      _blurSettings
    ];
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: getInfo(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snap) {
          if (snap.hasData) {
            final Set<Favorite> _favoritesSet = <Favorite>{};
            for (String f in snap.data[1]) {
              _favoritesSet.add(Favorite(f));
            }
            final FavoritesHelper _helper =
                FavoritesHelper(userId: firebaseUser.uid);
            _helper.syncDatabase(_favoritesSet);
            return MultiProvider(
              providers: <ChangeNotifierProvider<dynamic>>[
                ChangeNotifierProvider<FavoritesProvider>(
                    builder: (_) => FavoritesProvider(_favoritesSet, _helper)),
                ChangeNotifierProvider<ThemeProvider>(
                    builder: (_) => ThemeProvider(snap.data[0])),
                ChangeNotifierProvider<BlurProvider>(
                    builder: (_) => BlurProvider(snap.data[3])),
                ChangeNotifierProvider<TextSizeProvider>(
                    builder: (_) => TextSizeProvider(snap.data[2])),
                ChangeNotifierProvider<QueryInfoProvider>(
                  builder: (_) => QueryInfoProvider(),
                )
              ],
              child: Builder(
                builder: (BuildContext context) {
                  ThemeData overrideTheme;
                  final ThemeData dark = themeDataDark;
                  final ThemeData light = themeDataLight;

                  if (Provider.of<ThemeProvider>(context).isDarkMode) {
                    overrideTheme = dark;
                  } else {
                    overrideTheme = light;
                  }
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    darkTheme: dark,
                    theme: overrideTheme,
                    home: MainView(),
                  );
                },
              ),
            );
          }
          return MultiProvider(
            providers: <Provider<dynamic>>[
              Provider<FavoritesProvider>(
                  builder: (_) => FavoritesProvider(<Favorite>{}, null)),
              Provider<ThemeProvider>(builder: (_) => ThemeProvider(false)),
              Provider<BlurProvider>(builder: (_) => BlurProvider(1)),
              Provider<TextSizeProvider>(builder: (_) => TextSizeProvider(4.5)),
              Provider<QueryInfoProvider>(
                builder: (_) => QueryInfoProvider(),
              )
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              darkTheme: themeDataDark,
              theme: themeDataLight,
              home: MainView(),
            ),
          );
        });
  }
}
