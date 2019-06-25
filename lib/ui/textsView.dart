import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/model/content.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/cardView.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

import 'textCard.dart';
import 'textCreateView.dart';

class TextsView extends StatefulWidget {
  const TextsView({@required this.spacerSize});
  final double spacerSize;
  @override
  _TextsViewState createState() => _TextsViewState();
}

class _TextsViewState extends State<TextsView> {
  IndexController _indexController;
  Stream<Map<String, dynamic>> _favoritesStream;
  Query _query;
  static Map<String, dynamic> favoritesData;
  final Firestore _db = Firestore.instance;
  List<Map<String, dynamic>> _slideList;
  bool _shouldDisplayAdd = false;

  Stream<Iterable<Map<String, dynamic>>> get slidesStream => _query
      .snapshots()
      .map<Iterable<Map<String, dynamic>>>((QuerySnapshot list) =>
          list.documents.map<Map<String, dynamic>>((DocumentSnapshot doc) {
            final Map<String, dynamic> data = doc.data;
            data['path'] = doc.reference.path;
            data['favoriteCount'] = 0;
            return data;
          }));

  void updateQuery() {
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

  @override
  void initState() {
    super.initState();
    _favoritesStream = _db
        .collection('users')
        .document('_favorites_')
        .snapshots()
        .map((DocumentSnapshot documentSnapshot) => documentSnapshot.data);
    _indexController = IndexController();
  }

  @override
  Widget build(BuildContext context) {
    updateQuery();
    return FutureBuilder<FirebaseUser>(
        future: Provider.of<AuthService>(context).getUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> user) {
          if (user?.data?.uid ==
              Provider.of<QueryInfoProvider>(context).collection)
            _shouldDisplayAdd = true;
          
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
                          return ListView.separated(
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                              itemCount: _slideList.length + (_shouldDisplayAdd ? 2 : 1),
                              itemBuilder: (BuildContext context, int index) {
                                if (index == 0)
                                  return SizedBox(height: widget.spacerSize);
                                if (_shouldDisplayAdd && index == _slideList.length + 1)
                                  return Container(height: 100.0 ,child: _AddItem());
                                final Content content =
                                    Content.fromData(_slideList[index - 1]);

                                final String heroTag =
                                    'listViewItem' + content.textPath;
                                final FavoritesProvider favProvider =
                                    Provider.of<FavoritesProvider>(context);
                                return Container(
                                    height: 100.0,
                                    child: ContentCard.sliver(
                                        content: content,
                                        heroTag: heroTag,
                                        trailing: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            IconButton(
                                                icon: Icon(
                                                    favProvider.isFavorite(
                                                            content.favorite)
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: favProvider
                                                            .isFavorite(content
                                                                .favorite)
                                                        ? Theme.of(context)
                                                            .accentColor
                                                        : null),
                                                onPressed: () => favProvider
                                                    .toggle(content.favorite)),
                                            Text(content.favoriteCount
                                                .toString())
                                          ],
                                        ),
                                        callBack: () {
                                          HapticFeedback.heavyImpact();
                                          Navigator.push(
                                              context,
                                              DurationMaterialPageRoute<void>(
                                                  builder:
                                                      (BuildContext context) =>
                                                          CardView(
                                                            heroTag: heroTag,
                                                            content: content,
                                                          )));
                                        }));
                              });
                        }

                        return AnimatedSwitcher(
                          duration: durationAnimationShort,
                          child: listView(),
                        );
                      },
                    );
                  }
                }
                return _shouldDisplayAdd ? Padding(padding: const EdgeInsets.all(20.0),child: _AddItem()) : Container(
                    child: Center(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                      Icon(Icons.error_outline, size: 72),
                      Text(
                        textNoTexts,
                        textAlign: TextAlign.center,
                      )
                    ])));
              });
        });
  }
}

class _AddItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      elevation: 16.0,
      child: Material(
        color: Colors.transparent,
        elevation: 0.0,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(20.0),
        child: InkWell(
            onTap: () => Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => TextCreateView())),
          child: Center(
            child: const Icon(
                Icons.add),
          ),
        ),
      ),
    );
  }
}
