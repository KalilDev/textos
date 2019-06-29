import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/providers.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class AuthorsView extends StatefulWidget {
  const AuthorsView({@required this.isVisible});
  final bool isVisible;

  @override
  _AuthorsViewState createState() => _AuthorsViewState();
}

class _AuthorsViewState extends State<AuthorsView> {
  Stream<Iterable<Map<String, dynamic>>> _tagStream;
  FirebaseUser user;
  bool isEditing = false;
  @override
  void initState() {
    _tagStream = Firestore.instance
        .collection('texts')
        .snapshots()
        .map<Iterable<Map<String, dynamic>>>((QuerySnapshot list) =>
            list.documents.map<Map<String, dynamic>>((DocumentSnapshot snap) {
              final Map<String, dynamic> data = snap.data;
              data['collection'] = snap.documentID;
              return snap.data;
            }));
    super.initState();
  }

  List<Map<String, dynamic>> _metadataList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: FutureBuilder<FirebaseUser>(
            future: Provider.of<AuthService>(context).getUser(),
            builder: (BuildContext context, AsyncSnapshot<FirebaseUser> user) {
              if (user.hasData && user?.data != null)
                this.user = user.data;
              return StreamBuilder<Iterable<Map<String, dynamic>>>(
                  stream: _tagStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<Iterable<Map<String, dynamic>>> snapshot) {
                    if (snapshot.hasData &&
                        (snapshot?.data?.isNotEmpty ?? false)) {
                      _metadataList = snapshot.data.toList();
                      bool shouldDisplayAdd = true;
                      if (_metadataList.any((Map<String, dynamic> data) =>
                          this.user?.uid == data['collection']))
                        shouldDisplayAdd = false;

                      return TransformerPageView(
                        itemCount: shouldDisplayAdd
                            ? (_metadataList.length + 1)
                            : _metadataList.length,
                        scrollDirection: Axis.vertical,
                        viewportFraction: 0.90,
                        curve: Curves.decelerate,
                        onPageChanged: (int page) {
                          if (page == _metadataList.length && shouldDisplayAdd)
                            return;
                          Provider.of<QueryInfoProvider>(context).currentPage =
                              page;
                          Provider.of<QueryInfoProvider>(context).collection =
                              _metadataList[page]['collection'];
                          Provider.of<QueryInfoProvider>(context).tag = null;
                          SystemSound.play(SystemSoundType.click);
                          HapticFeedback.lightImpact();
                        },
                        index:
                            Provider.of<QueryInfoProvider>(context).currentPage,
                        transformer: PageTransformerBuilder(
                            builder: (_, TransformInfo info) {
                          if (info.index == _metadataList.length &&
                              shouldDisplayAdd)
                            return const _AddPage();

                          final Map<String, dynamic> data =
                              _metadataList[info.index];

                          return Stack(
                            children: <Widget>[
                              AnimatedSwitcher(
                                duration: durationAnimationMedium,
                                child: (isEditing &&
                                        this?.user?.uid == data['collection'])
                                    ? _AddPage(data: data)
                                    : _AuthorPage(
                                        info: info,
                                        tags: data['tags'],
                                        title: data['title'],
                                        authorName: data['authorName']),
                              ),
                              if (this?.user?.uid == data['collection'])
                                Positioned(
                                    top: 10.0,
                                    right: 20.0,
                                    child: Material(
                                      clipBehavior: Clip.antiAlias,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(20.0)),
                                      color: Colors.transparent,
                                      child: IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () => setState(
                                              () => isEditing = !isEditing)),
                                    )),
                            ],
                          );
                        }),
                      );
                    } else if (snapshot.hasError ||
                        (snapshot.hasData &&
                            (snapshot?.data?.isEmpty ?? true))) {
                      return Center(
                        child: Text(textAppName,
                            style: Theme.of(context).accentTextTheme.display1),
                      );
                    } else {
                      return Container();
                    }
                  });
            }));
  }
}

class _AuthorPage extends StatefulWidget {
  const _AuthorPage(
      {@required this.info,
      this.tags = const <String>[],
      this.title = 'Textos do ',
      this.authorName = 'Kalil'});

  final TransformInfo info;
  final List<dynamic> tags;
  final String title;
  final String authorName;

  @override
  _AuthorPageState createState() => _AuthorPageState();
}

class _AuthorPageState extends State<_AuthorPage> {
  List<Widget> _buildButtons() {
    final List<Widget> widgets = <Widget>[];
    widgets.add(_CustomButton(
      isCurrent: widget.info.position.round() == 0.0,
      tag: textAllTag,
      index: 0.0,
      position: widget.info.position,
    ));

    for (dynamic tag in widget.tags) {
      widgets.add(_CustomButton(
        isCurrent: widget.info.position.round() == 0.0,
        tag: tag,
        index: widget.tags.indexOf(tag) + 1.0,
        position: widget.info.position,
      ));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          ElevatedContainer(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            elevation: 16 * widget.info.position.abs(),
            margin: const EdgeInsets.only(
                right: 20, top: 10, bottom: 10, left: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                margin: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ParallaxContainer(
                      axis: Axis.vertical,
                      position: -widget.info.position,
                      translationFactor: 100,
                      child: Text(
                        widget.title + widget.authorName,
                        style: Theme.of(context).accentTextTheme.display1,
                      ),
                    ),
                    ParallaxContainer(
                        axis: Axis.vertical,
                        position: -widget.info.position,
                        translationFactor: 150,
                        child: Text(textFilter,
                            style: Theme.of(context)
                                .accentTextTheme
                                .body1
                                .copyWith(
                                  color: getTextColor(0.60,
                                      bg: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      main: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                                ))),
                    Container(
                      margin: const EdgeInsets.only(left: 1.0),
                      child: RepaintBoundary(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _buildButtons()),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
    );
  }
}

class _CustomButton extends StatelessWidget {
  const _CustomButton(
      {Key key,
      @required this.tag,
      @required this.isCurrent,
      @required this.position,
      @required this.index})
      : super(key: key);

  final String tag;
  final bool isCurrent;
  final double position;
  final double index;

  @override
  Widget build(BuildContext context) {
    final String queryTag = tag == textAllTag ? null : tag;
    return ParallaxContainer(
      axis: Axis.vertical,
      position: -position,
      translationFactor: 150 + 50 * (index + 1),
      opacityFactor: -position.abs() * 1.2 + 1,
      child: AnimatedSwitcher(
          duration: durationAnimationMedium,
          switchOutCurve: Curves.easeInOut,
          switchInCurve: Curves.easeInOut,
          transitionBuilder: (Widget widget, Animation<double> animation) {
            return FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                child: widget);
          },
          child: isCurrent && tag == Provider.of<QueryInfoProvider>(context).tag
              ? FlatButton(
                  color: Theme.of(context).primaryColor,
                  highlightColor: Theme.of(context).accentColor,
                  child: Text(
                    '#' + tag,
                    style: Theme.of(context).accentTextTheme.button.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    Provider.of<QueryInfoProvider>(context).tag = queryTag;
                  })
              : OutlineButton(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  highlightColor: Theme.of(context).accentColor,
                  child: Text(
                    '#' + tag,
                    style: Theme.of(context).accentTextTheme.button.copyWith(
                        color: Color.alphaBlend(
                                Theme.of(context).primaryColor.withAlpha(120),
                                Theme.of(context).accentTextTheme.button.color)
                            .withAlpha(175)),
                  ),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    Provider.of<QueryInfoProvider>(context).tag = queryTag;
                  })),
    );
  }
}

class _AddPage extends StatefulWidget {
  const _AddPage({this.data});
  final Map<String, dynamic> data;
  @override
  __AddPageState createState() => __AddPageState();
}

class __AddPageState extends State<_AddPage> {
  bool _isCreating = false;
  String _title;
  String _authorName;
  final GlobalKey<__TagsBuilderState> _tagsBuilderKey = GlobalKey();
  TextEditingController _titleController;
  TextEditingController _authorNameController;

  @override
  void initState() {
    if (widget?.data?.isEmpty ?? true) {
      _isCreating = false;
      _titleController = TextEditingController();
      _authorNameController = TextEditingController();
    } else {
      _isCreating = true;
      _title = widget.data['title'].toString();
      if (_title.endsWith(' '))
        _title = _title.substring(0, _title.length - 1);
      _authorName = widget.data['authorName'];
      _titleController = TextEditingController(text: _title);
      _authorNameController = TextEditingController(text: _authorName);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildCreator() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '${_title ?? 'Textos do'} ${_authorName ?? 'Kalil'}',
                style: Theme.of(context).accentTextTheme.display1,
              ),
              TextField(
                  controller: _titleController,
                  onChanged: (String title) => setState(() => _title = title),
                  decoration:
                      InputDecoration(labelText: 'Titulo. Ex.: Textos do')),
              TextField(
                  controller: _authorNameController,
                  onChanged: (String authorName) =>
                      setState(() => _authorName = authorName),
                  decoration: InputDecoration(labelText: 'Nome do autor')),
              _TagsBuilder(key: _tagsBuilderKey, data: widget.data),
              if (widget?.data?.containsKey('collection') ?? false)
                RaisedButton(
                    color: Theme.of(context).colorScheme.error,
                    child: const Text('Remover autor'),
                    textColor: Theme.of(context).colorScheme.onError,
                    onPressed: () async {
                      final bool delete = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Apagar sua pagina'),
                                content: const Text(
                                    'Sua pagina será apagada, junto com TODOS os textos, sem possibilidade de recupera-los.'),
                                actions: <Widget>[
                                  FlatButton(
                                      child: const Text(textNo),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      }),
                                  FlatButton(
                                      child: const Text(textYes),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      })
                                ],
                              ));
                      if (delete)
                        Firestore.instance
                            .collection('texts')
                            .document(widget?.data['collection'])
                            .delete();
                    }),
              RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text(widget?.data == null
                      ? 'Adicionar autor'
                      : 'Salvar alterações'),
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  onPressed: () async {
                    final FirebaseUser user =
                        await Provider.of<AuthService>(context).getUser();
                    final DocumentReference document = Firestore.instance
                        .collection('texts')
                        .document(user.uid);
                    final DocumentSnapshot snap = await document.get();
                    if (!snap.exists) {
                      await document.setData(<String, dynamic>{
                        'authorName': _authorName,
                        'title': _title + ' ',
                        'tags': _tagsBuilderKey.currentState.tags,
                        'visible': false
                      });
                    } else {
                      await document.updateData(<String, dynamic>{
                        'authorName': _authorName,
                        'title': _title + ' ',
                        'tags': _tagsBuilderKey.currentState.tags,
                        'visible': false
                      });
                    }
                  }),
              if (widget.data == null)
                OutlineButton(
                    child: const Text('Voltar'),
                    onPressed: () => setState(() => _isCreating = false))
            ],
          ),
        ),
      );
    }

    return ElevatedContainer(
      elevation: 16.0,
      margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10, left: 10.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        child: _isCreating
            ? buildCreator()
            : InkWell(
                onTap: () => setState(() => _isCreating = true),
                child: Container(
                  child: Center(
                    child: IconButton(
                        icon: const Icon(Icons.add), onPressed: null),
                  ),
                ),
              ),
      ),
    );
  }
}

class _TagsBuilder extends StatefulWidget {
  _TagsBuilder({Key key, this.data}) : super(key: key);
  final Map<String, dynamic> data;
  @override
  __TagsBuilderState createState() => __TagsBuilderState();
}

class __TagsBuilderState extends State<_TagsBuilder> {
  List<String> tags = <String>[];
  final List<TextEditingController> _controllers = <TextEditingController>[];
  int get amountOfTags => tags.length + 1;
  @override
  void initState() {
    if (widget?.data?.isNotEmpty ?? false) {
      final List<dynamic> dataList = widget.data['tags'];
      for (dynamic tag in dataList) {
        tags.add(tag.toString());
        _controllers.add(TextEditingController(text: tag.toString()));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _getChildren() {
      final List<Widget> widgets = <Widget>[];
      int idx = 0;
      while (idx < amountOfTags) {
        final int i = idx;
        widgets.add(TextField(
            controller: _controllers.length <= i ? null : _controllers[i],
            onChanged: (String tag) {
              if (tags.length <= i) {
                setState(() => tags.add(tag));
              } else {
                if (tag.isEmpty && i == tags.length - 1)
                  setState(() => tags.removeAt(i));
                setState(() => tags[i] = tag);
              }
            },
            decoration: InputDecoration(labelText: 'Tag ' + i.toString())));
        idx++;
      }
      return widgets;
    }

    return Column(
      children: _getChildren(),
    );
  }
}
