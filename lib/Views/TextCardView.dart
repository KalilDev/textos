import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Src/BlurSettings.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Widgets/Widgets.dart';
import 'package:textos/main.dart';

class TextCardView extends StatelessWidget {
  // Declare a field that holds the data map, and a field that holds the index
  final Map data;
  final Store<AppStateMain> store;

  // In the constructor, require the data map and index
  TextCardView({@required this.data, this.store});

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
            body: new TextCard(data: data, store: store, exit: exit)));
  }
}

class TextCard extends StatelessWidget {
  const TextCard({
    Key key,
    @required this.data,
    @required this.store,
    @required this.exit,
  }) : super(key: key);

  final Map data;
  final Store<AppStateMain> store;
  final Function exit;

  @override
  Widget build(BuildContext context) {
    // Sanitize input
    final title = data['title'] ?? Constants.placeholderTitle;
    final text = data['text'] ?? Constants.placeholderText;
    final date = data['date'] ?? Constants.placeholderDate;
    final img = data['img'] ?? Constants.placeholderImg;

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
          child: GestureDetector(
            onTap: () => exit(),
            child: Stack(
              children: <Widget>[
                Hero(
                    tag: 'image' + data['id'],
                    child: ImageBackground(
                        img: img,
                        enabled: false,
                        key: Key('image' + data['id']))),
                Hero(
                  tag: 'body' + data['id'],
                  child: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: BlurOverlay(
                          enabled: BlurSettingsParser(
                              blurSettings: store.state.blurSettings)
                              .getTextsBlur(),
                          radius: 20,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: SingleChildScrollView(
                                    child: Column(children: <Widget>[
                                      Text(title,
                                          textAlign: TextAlign.center,
                                          style: Constants().textstyleTitle(
                                              store.state.textSize)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(text,
                                          style: Constants().textstyleText(
                                              store.state.textSize)),
                                      SizedBox(
                                        height: 55,
                                        child: Center(
                                          child: Text(date,
                                              style: Constants().textstyleDate(
                                                  store.state.textSize)),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
                Positioned(
                  child: new FavoriteFAB(
                      store: store,
                      title: title,
                      id: Constants.authorCollections[store.state.author] +
                          '/' +
                          data['id']),
                  right: 10,
                  bottom: 10,
                ),
                Positioned(
                  child: new TextSizeButton(store: store),
                  left: 10,
                  bottom: 13.5,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          child: Tooltip(
              message: Constants.textTooltipDrawer,
              child: InkWell(
                  customBorder: CircleBorder(),
                  child:
                  Container(height: 60, width: 60, child: Icon(Icons.menu)),
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
