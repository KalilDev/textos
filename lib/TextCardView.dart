import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Constants.dart';
import 'package:textos/Drawer.dart';
import 'package:textos/SettingsHelper.dart';
import 'package:textos/Widgets/Widgets.dart';
import 'package:textos/main.dart';

class TextCardView extends StatelessWidget {
  // Declare a field that holds the data map, and a field that holds the index
  final Map map;
  final Store<AppStateMain> store;

  // In the constructor, require the data map and index
  TextCardView({@required this.map, this.store});

  @override
  Widget build(BuildContext context) {
    exit() {
      Navigator.pop(context);
    }

    return MaterialApp(
        theme: store.state.enableDarkMode
            ? Constants.themeDataDark
            : Constants.themeDataLight,
        home: new Scaffold(
            drawer: TextAppDrawer(store: store),
            body: new TextCard(map: map, store: store, exit: exit)));
  }
}

class TextCard extends StatelessWidget {
  const TextCard({
    Key key,
    @required this.map,
    @required this.store,
    @required this.exit,
  }) : super(key: key);

  final Map map;
  final Store<AppStateMain> store;
  final Function exit;

  @override
  Widget build(BuildContext context) {
    // Sanitize input
    final title = map['title'] ?? Constants.placeholderTitle;
    final text = map['text'] ?? Constants.placeholderText;
    final date = map['date'] ?? Constants.placeholderDate;
    final img = map['img'] ?? Constants.placeholderImg;

    final double blur = 30;
    final double offset = 10;

    return Stack(
      children: <Widget>[
        Dismissible(
          key: Key(title),
          movementDuration: Duration(milliseconds: 250),
          confirmDismiss: (callback) {
            if (callback == DismissDirection.startToEnd) {
              Scaffold.of(context).openDrawer();
            } else {
              exit();
            }
          },
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () => exit(),
                child: Hero(
                    tag: map['title'],
                    child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery
                              .of(context)
                              .padding
                              .top + 40,
                          bottom: 20,
                          right: 20,
                          left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme
                              .of(context)
                              .backgroundColor,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(img),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Theme
                                    .of(context)
                                    .primaryColor
                                    .withAlpha(125),
                                blurRadius: blur,
                                offset: Offset(offset, offset))
                          ]),
                      child: Material(
                          color: Colors.transparent,
                          child: BlurOverlay(
                            enabled: BlurSettings(store).getTextsBlur(),
                            radius: 20,
                            child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(20.0),
                                        child: SingleChildScrollView(
                                          child: Column(children: <Widget>[
                                            Text(title,
                                                textAlign: TextAlign.center,
                                                style: Constants()
                                                    .textstyleTitle(
                                                    store.state.textSize)),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(text,
                                                style: Constants()
                                                    .textstyleText(
                                                    store.state.textSize)),
                                            SizedBox(
                                              height: 55,
                                              child: Center(
                                                child: Text(date,
                                                    style: Constants()
                                                        .textstyleDate(store
                                                        .state.textSize)),
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          )),
                    )),
              ),
              Positioned(
                child: new FavoriteFAB(
                    store: store, title: title, id: 'stories/' + map['id']),
                right: 30,
                bottom: 30,
              ),
              Positioned(
                child: new TextSizeButton(store: store),
                left: 20,
                bottom: 33.5,
              ),
            ],
          ),
        ),
        Positioned(
          child: Tooltip(message: Constants.textTooltipDrawer,
              child: InkWell(customBorder: CircleBorder(),
                  child: Container(
                      height: 60, width: 60, child: Icon(Icons.menu)),
                  onTap: () => Scaffold.of(context).openDrawer())),
          top: MediaQuery
              .of(context)
              .padding
              .top - 2.5,
          left: -2.5,
        ),
      ],
    );
  }
}
