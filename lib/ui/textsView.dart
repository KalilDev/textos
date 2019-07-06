import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/bloc/database_stream_manager/bloc.dart';
import 'package:textos/constants.dart';
import 'package:textos/model/content.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/cardView.dart';

import 'textCard.dart';
import 'textCreateView.dart';

class TextsView extends StatefulWidget {
  const TextsView({@required this.spacerSize});
  final double spacerSize;
  @override
  _TextsViewState createState() => _TextsViewState();
}

class _TextsViewState extends State<TextsView> {
  Stream<Map<String, int>> _favoritesStream;

  Widget _noTextsWidget() {
    return Material(
        color: Colors.transparent,
        elevation: 0.0,
        child: Center(
            child:
                Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
          Icon(Icons.error_outline, size: 72),
          Text(
            textNoTexts,
            textAlign: TextAlign.center,
          )
        ])));
  }

  @override
  void initState() {
    super.initState();
    _favoritesStream = Firestore.instance
        .collection('users')
        .document('_favorites_')
        .snapshots()
        .map<Map<String, int>>((DocumentSnapshot documentSnapshot) =>
            Map<String, int>.from(documentSnapshot.data));
    _favoritesStream.listen((Map<String, int> data) =>
        BlocProvider.of<DatabaseAuthorStreamManagerBloc>(context)
            .favoritesData = data);
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseAuthorStreamManagerBloc bloc =
        BlocProvider.of<DatabaseAuthorStreamManagerBloc>(context);
    return BlocBuilder<DatabaseAuthorStreamManagerEvent,
            DatabaseAuthorStreamManagerState>(
        bloc: BlocProvider.of<DatabaseAuthorStreamManagerBloc>(context),
        builder:
            (BuildContext context, DatabaseAuthorStreamManagerState state) {
          if (state is LoadedTextsStream)
            return StreamBuilder<Iterable<Content>>(
                stream:
                    BlocProvider.of<DatabaseAuthorStreamManagerBloc>(context)
                        .textsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<Iterable<Content>> snap) {
                  if (snap.hasData) {
                    if (snap.data.isNotEmpty) {
                      Widget listView() {
                        return ListView.builder(
                            itemCount:
                                snap.data.length + (bloc.canEdit ? 2 : 1),
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0)
                                return SizedBox(height: widget.spacerSize);

                              if (bloc.canEdit && index == snap.data.length + 1)
                                return Container(
                                    margin: const EdgeInsets.only(bottom: 12.0),
                                    height: 100.0,
                                    child: _AddItem());

                              return _ListItem(
                                  isAuthor: bloc.canEdit,
                                  content: snap.data.elementAt(index),
                                  isFavorite: Provider.of<FavoritesProvider>(
                                          context)
                                      .isFavorite(
                                          snap.data.elementAt(index).favorite),
                                  onFavorite: () =>
                                      Provider.of<FavoritesProvider>(context)
                                          .toggle(snap.data
                                              .elementAt(index)
                                              .favorite));
                            });
                      }

                      return listView();
                    } else {
                      return _noTextsWidget();
                    }
                  }
                  return bloc.canEdit
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: _AddItem())
                      : _noTextsWidget();
                });

          return Center(child:  CircularProgressIndicator());
        });
  }
}

class _AddItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      elevation: 8.0,
      child: InkWell(
        onTap: () => Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => const TextCreateView())),
        child: const Center(
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class _ListItem extends StatefulWidget {
  const _ListItem(
      {@required this.content,
      @required this.isFavorite,
      @required this.onFavorite,
      @required this.isAuthor});

  final VoidCallback onFavorite;
  final Content content;
  final bool isFavorite;
  final bool isAuthor;

  @override
  __ListItemState createState() => __ListItemState();
}

class __ListItemState extends State<_ListItem> {
  bool isExtended = false;

  @override
  Widget build(BuildContext context) {
    final String heroTag = 'listViewItem' + widget.content.textPath;
    final double height = isExtended ? 200.0 : 100.0;
    final EdgeInsets padding = isExtended
        ? const EdgeInsets.symmetric(horizontal: 16.0)
        : EdgeInsets.zero;

    return AnimatedElevatedContainer(
        duration: durationAnimationMedium,
        height: height,
        elevation: 4.0,
        margin: const EdgeInsets.only(bottom: 8.0),
        padding: padding,
        child: ContentCard.sliver(
            longPressCallBack: () {
              setState(() => isExtended = !isExtended);
            },
            content: widget.content,
            heroTag: heroTag,
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                        widget.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.isFavorite
                            ? Theme.of(context).accentColor
                            : null),
                    onPressed: widget.onFavorite),
                Text(widget.content.favoriteCount.toString())
              ],
            ),
            leading: widget.isAuthor
                ? IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) => TextCreateView(
                                  content: widget.content,
                                ))))
                : null,
            callBack: () {
              HapticFeedback.heavyImpact();
              Navigator.push(
                  context,
                  DurationMaterialPageRoute<void>(
                      builder: (BuildContext context) => CardView(
                            heroTag: heroTag,
                            content: widget.content,
                          )));
            }));
  }
}
