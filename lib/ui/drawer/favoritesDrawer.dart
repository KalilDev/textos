import 'package:flutter/material.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:textos/src/providers.dart';

class FavoritesDrawer extends StatelessWidget {
  Widget buildFavoritesItem(BuildContext context, String favorite) {
    final favoriteTitle = favorite.split(';')[0];

    Widget txt;
    if (favoriteTitle.length > 20) {
      txt = Container(
          child: Marquee(
              text: favoriteTitle,
              style: Theme
                  .of(context)
                  .textTheme
                  .display2,
              blankSpace: 25,
              pauseAfterRound: Duration(seconds: 1),
              velocity: 60.0),
          height: 60.0);
    } else {
      txt = Text(
        favoriteTitle,
        style: Theme
            .of(context)
            .textTheme
            .display2,
        textAlign: TextAlign.center,
      );
    }
    return Dismissible(
        key: Key('Dismissible-' + favoriteTitle),
        background: Container(
          child: Row(
            children: <Widget>[
              Container(child: Icon(Icons.delete), width: 90),
              Spacer()
            ],
          ),
        ),
        secondaryBackground: Container(
          child: Row(
            children: <Widget>[
              Spacer(),
              Container(
                child: Icon(Icons.delete),
                width: 90,
              ),
            ],
          ),
        ),
        onDismissed: (direction) =>
            Provider.of<FavoritesProvider>(context).remove(favorite),
        child: LayoutBuilder(
          builder: (context, constraints) =>
          Provider
              .of<BlurProvider>(context)
              .drawerBlur
              ? ListTile(
              title: txt,
              onTap: () {
                Provider.of<FavoritesProvider>(context).open(favorite, context);
              })
              : ElevatedContainer(
            elevation: 4.0,
            width: constraints.maxWidth,
            margin: EdgeInsets.fromLTRB(3, 6, 3, 3),
            borderRadius: BorderRadius.circular(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 7.0),
                        child: txt),
                    onTap: () {
                      Provider.of<FavoritesProvider>(context).open(
                          favorite, context);
                    }),
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new ListView.separated(
        itemCount:
        Provider
            .of<FavoritesProvider>(context)
            .favoritesList
            .length + 1,
        itemBuilder: (BuildContext context, int index) =>
        index == 0
            ? Provider
            .of<BlurProvider>(context)
            .drawerBlur ? Divider() : SizedBox(height: 12.5)
            : buildFavoritesItem(context,
            Provider
                .of<FavoritesProvider>(context)
                .favoritesList[index - 1]),
          separatorBuilder: (BuildContext context, int index) {
            return (index == 0 || !Provider
                .of<BlurProvider>(context)
                .drawerBlur) ? SizedBox() : Divider();
          }
      ),
    );
  }
}
