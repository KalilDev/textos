import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
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
  Stream<Map<String, dynamic>> _favoritesStream;
  Query _query;
  static Map<String, dynamic> favoritesData;
  final Firestore _db = Firestore.instance;
  List<Map<String, dynamic>> _slideList;
  bool _isAuthor = false;

  Stream<Iterable<Map<String, dynamic>>> get slidesStream => _query
      .snapshots()
      .map<Iterable<Map<String, dynamic>>>((QuerySnapshot list) =>
          list.documents.map<Map<String, dynamic>>((DocumentSnapshot doc) {
            final Map<String, dynamic> data = doc.data;
            data['path'] = doc.reference.path;
            data['favoriteCount'] = 0;
            return data;
          }));

  void _updateQuery() {
    final QueryInfoProvider queryInfo = Provider.of<QueryInfoProvider>(context);
    if (queryInfo.tag != textAllTag) {
      _query = _db
          .collection('texts')
          .document(queryInfo.collection)
          .collection('documents')
          .where('tags', arrayContains: queryInfo.tag)
          .orderBy('date', descending: true);
    } else {
      _query = _db
          .collection('texts')
          .document(queryInfo.collection)
          .collection('documents')
          .orderBy('date', descending: true);
    }
  }

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
    _favoritesStream = _db
        .collection('users')
        .document('_favorites_')
        .snapshots()
        .map((DocumentSnapshot documentSnapshot) => documentSnapshot.data);
  }

  @override
  Widget build(BuildContext context) {
    _updateQuery();
    return FutureBuilder<FirebaseUser>(
        future: Provider.of<AuthService>(context).getUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> user) {
          if (user?.data?.uid ==
              Provider.of<QueryInfoProvider>(context).collection)
            _isAuthor = true;

          return StreamBuilder<Iterable<Map<String, dynamic>>>(
              stream: slidesStream,
              builder: (BuildContext context,
                  AsyncSnapshot<Iterable<Map<String, dynamic>>> snap) {
                if (snap.hasData) {
                  if (snap.data.isNotEmpty) {
                    _slideList = snap.data.toList();
                    return StreamBuilder<Map<String, dynamic>>(
                      stream: _favoritesStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, dynamic>> favoritesSnap) {
                        if (favoritesSnap.hasData) {
                          favoritesData = favoritesSnap.data;
                          favoritesData
                              .forEach((String textPath, dynamic favoriteInt) {
                            final int targetIndex = _slideList.indexWhere(
                                (Map<String, dynamic> element) =>
                                    element['path'] ==
                                    textPath.toString().replaceAll('_', '/'));
                            if (targetIndex >= 0)
                              _slideList.elementAt(
                                  targetIndex)['favoriteCount'] = favoriteInt;
                          });
                        }

                        Widget listView() {
                          return ListView.builder(
                              itemCount:
                                  _slideList.length + (_isAuthor ? 2 : 1),
                              itemBuilder: (BuildContext context, int index) {
                                if (index == 0)
                                  return SizedBox(height: widget.spacerSize);

                                if (_isAuthor && index == _slideList.length + 1)
                                  return Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 12.0),
                                      height: 100.0,
                                      child: _AddItem());

                                final Content content =
                                    Content.fromData(_slideList[index - 1]);

                                return _ListItem(
                                    isAuthor: _isAuthor,
                                    content: content,
                                    isFavorite:
                                        Provider.of<FavoritesProvider>(context)
                                            .isFavorite(content.favorite),
                                    onFavorite: () =>
                                        Provider.of<FavoritesProvider>(context)
                                            .toggle(content.favorite));
                              });
                        }

                        return listView();
                      },
                    );
                  }
                }
                return _isAuthor
                    ? Padding(
                        padding: const EdgeInsets.all(20.0), child: _AddItem())
                    : _noTextsWidget();
              });
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
