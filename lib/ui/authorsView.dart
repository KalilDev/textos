import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/bloc/database_author_add/bloc.dart';
import 'package:textos/bloc/database_stream_manager/bloc.dart';
import 'package:textos/constants.dart';
import 'package:textos/model/author.dart';
import 'package:textos/src/providers.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class AuthorsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatabaseStreamManagerEvent, DatabaseStreamManagerState>(bloc: BlocProvider.of<DatabaseStreamManagerBloc>(context), builder: (BuildContext context, DatabaseStreamManagerState state) {
      final DatabaseStreamManagerBloc streamManagerBloc = BlocProvider.of<DatabaseStreamManagerBloc>(context);
      if (state is LoadedAuthorsStream) {

        return StreamBuilder<Iterable<Author>>(
            stream: streamManagerBloc.authorStream,
            builder: (BuildContext context,
                AsyncSnapshot<Iterable<Author>> snapshot) {
              final Iterable<Author> authorsData = snapshot.data ?? Iterable<Author>.empty();
              bool shouldDisplayAdd = true;
              if (authorsData.any((Author author) => author.canEdit))
                shouldDisplayAdd = false;

              return TransformerPageView(
                itemCount: shouldDisplayAdd
                    ? (authorsData.length + 1)
                    : authorsData.length,
                scrollDirection: Axis.vertical,
                viewportFraction: 0.90,
                curve: Curves.decelerate,
                onPageChanged: (int page) {
                  if (page == authorsData.length && shouldDisplayAdd)
                    return;
                  Provider.of<QueryInfoProvider>(context).currentPage =
                      page;
                  Provider.of<QueryInfoProvider>(context).collection =
              authorsData.elementAt(page).authorID;
                  Provider.of<QueryInfoProvider>(context).tag = null;
                  SystemSound.play(SystemSoundType.click);
                  HapticFeedback.lightImpact();
                },
                index: Provider.of<QueryInfoProvider>(context).currentPage,
                transformer: PageTransformerBuilder(
                    builder: (_, TransformInfo info) {
                      final Author data = authorsData.elementAt(info.index);
                      WidgetBuilder child;
                      bool hasBloc;
                      bool showEdit;
                      DatabaseAuthorAddBloc bloc;
                      if (data?.authorID != null) {
                        child = (BuildContext context) => _AuthorPage(info: info, author: data);
                        hasBloc = data.canEdit;
                        showEdit = hasBloc;
                        bloc = hasBloc
                            ? DatabaseAuthorAddBloc(author: data)
                            : null;
                      } else if (info.index == authorsData.length) {
                        bloc = DatabaseAuthorAddBloc();
                        child = (BuildContext context) => InkWell(
                          onTap: () {
                            final AuthorEditingBloc bloc = BlocProvider.of<AuthorEditingBloc>(context);
                            if (bloc.currentState is ShowingChild) {
                              bloc.dispatch(ShowEditing());
                            } else {
                              bloc.dispatch(ShowChild());
                            }
                          },
                          child: Container(
                            child: Center(
                              child: IconButton(
                                  icon: const Icon(Icons.add), onPressed: null),
                            ),
                          ),
                        );
                        hasBloc = true;
                        showEdit = false;
                      }

                      if (hasBloc) {
                        return BlocProviderTree(
                            blocProviders: [
                              BlocProvider<DatabaseAuthorAddBloc>(
                                builder: (BuildContext context) => bloc,
                              ),
                              BlocProvider<AuthorEditingBloc>(
                                builder: (BuildContext context) =>
                                    AuthorEditingBloc(),
                              )
                            ],
                            child: Stack(
                                children: <Widget>[
                                _AddPage(author: data, child: Builder(builder: child)),
                            if (showEdit)
                        Positioned(
                            top: 10.0,
                            right: 20.0,
                            child: Material(
                                clipBehavior: Clip.antiAlias,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20.0)),
                                color: Colors.transparent,
                                child: Builder(
                                  builder: (BuildContext context) =>
                                      BlocBuilder<AuthorEditingEvent,
                                          AuthorEditingState>(
                                        bloc: BlocProvider.of<
                                            AuthorEditingBloc>(
                                            context),
                                        builder: (BuildContext
                                        context,
                                            AuthorEditingState
                                            state) =>
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.edit),
                                              onPressed: () {
                                                print(bloc.hashCode);
                                                if (state
                                                is ShowingChild) {
                                                  BlocProvider.of<
                                                      AuthorEditingBloc>(
                                                      context)
                                                      .dispatch(
                                                      ShowEditing());
                                                } else {
                                                  BlocProvider.of<
                                                      AuthorEditingBloc>(
                                                      context)
                                                      .dispatch(
                                                      ShowChild());
                                                }
                                              },
                                            ),
                                      ),
                                ))),
                      ],
                      ));
                      } else {
                      return Builder(builder: child);
                      }
                    }),
              );
            });

      } else {
        return Center(child: const CircularProgressIndicator());
      }
    });

  }
}

class _AuthorPage extends StatefulWidget {
  const _AuthorPage({@required this.info, @required this.author});

  final TransformInfo info;
  final Author author;

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

    for (String tag in widget.author.tags) {
      widgets.add(_CustomButton(
        isCurrent: widget.info.position.round() == 0.0,
        tag: tag,
        index: widget.author.tags.indexOf(tag) + 1.0,
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
                        widget.author.title + widget.author.authorName,
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
  const _AddPage({this.author, this.child});
  final Author author;
  final Widget child;
  @override
  __AddPageState createState() => __AddPageState();
}

class __AddPageState extends State<_AddPage> {
  final GlobalKey<__TagsBuilderState> _tagsBuilderKey = GlobalKey();
  TextEditingController _titleController;
  TextEditingController _authorNameController;

  @override
  void initState() {
    if (widget?.author == null) {
      _titleController = TextEditingController();
      _authorNameController = TextEditingController();
    } else {
      final String title = widget.author.title.substring(0, widget.author.title.length - 2);
      _titleController = TextEditingController(text: widget.author.title);
      _authorNameController = TextEditingController(text: widget.author.authorName);
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
              BlocBuilder<TitleManagerEvent, TitleManagerState>(
                bloc: BlocProvider.of<DatabaseAuthorAddBloc>(context)
                    .titleManager,
                builder: (BuildContext context, TitleManagerState state) =>
                    Text(
                      '${BlocProvider.of<DatabaseAuthorAddBloc>(context).title ?? 'Textos do'} ${BlocProvider.of<DatabaseAuthorAddBloc>(context).authorName ?? 'Kalil'}',
                      style: Theme.of(context).accentTextTheme.display1,
                    ),
              ),
              TextField(
                  controller: _titleController,
                  onChanged: (String title) =>
                      BlocProvider.of<DatabaseAuthorAddBloc>(context)
                          .dispatch(AuthorTitleUpdate(title: title)),
                  decoration:
                      InputDecoration(labelText: 'Titulo. Ex.: Textos do')),
              TextField(
                  controller: _authorNameController,
                  onChanged: (String authorName) =>
                      BlocProvider.of<DatabaseAuthorAddBloc>(context)
                          .dispatch(AuthorNameUpdate(authorName: authorName)),
                  decoration: InputDecoration(labelText: 'Nome do autor')),
              _TagsBuilder(key: _tagsBuilderKey, initialTags: widget.author.tags),
              if (widget?.author?.authorID != null)
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
      BlocProvider.of<DatabaseAuthorAddBloc>(context)
          .dispatch(AuthorDelete());
                    }),
              RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text(widget?.author == null
                      ? 'Adicionar autor'
                      : 'Salvar alterações'),
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  onPressed: () => BlocProvider.of<DatabaseAuthorAddBloc>(context).dispatch(AuthorUpload())),
              if (widget.author == null)
                OutlineButton(
                    child: const Text('Voltar'),
                    onPressed: () {
                      if (BlocProvider.of<AuthorEditingBloc>(context)
                          .currentState is ShowingChild) {
                        BlocProvider.of<AuthorEditingBloc>(context)
                            .dispatch(ShowEditing());
                      } else {
                        BlocProvider.of<AuthorEditingBloc>(context)
                            .dispatch(ShowChild());
                      }
                    })
            ],
          ),
        ),
      );
    }

    return BlocBuilder<AuthorEditingEvent, AuthorEditingState>(
        bloc: BlocProvider.of<AuthorEditingBloc>(context),
        builder: (BuildContext context, AuthorEditingState state) {
          if (state is ShowingChild) {
            return widget.child;
          } else {
            return ElevatedContainer(
              elevation: 16.0,
              margin: const EdgeInsets.only(
                  right: 20, top: 10, bottom: 10, left: 10.0),
              child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.transparent,
                  child: buildCreator()),
            );
          }
        });
  }
}

class _TagsBuilder extends StatefulWidget {
  _TagsBuilder({Key key, this.initialTags}) : super(key: key);
  final List<String> initialTags;
  @override
  __TagsBuilderState createState() => __TagsBuilderState();
}

class __TagsBuilderState extends State<_TagsBuilder> {
  final List<TextEditingController> _controllers = <TextEditingController>[];
  @override
  void initState() {
    if (widget?.initialTags?.isNotEmpty ?? false) {
      for (String tag in widget.initialTags) {
        _controllers.add(TextEditingController(text: tag.toString()));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseAuthorAddBloc bloc = BlocProvider.of<DatabaseAuthorAddBloc>(context);
    print(bloc.tags);
    List<Widget> _getChildren() {
      final List<Widget> widgets = <Widget>[];
      int idx = 0;
      while (idx < bloc.tags.length + 1) {
        final int i = idx;
        widgets.add(TextField(
            controller: _controllers.length <= i ? null : _controllers[i],
            onChanged: (String tag) {
              if (bloc.tags.length <= i) {
                bloc.dispatch(AuthorTagAdd(tag));
              } else {
                if (tag.isEmpty && i == bloc.tags.length - 1)
                  bloc.dispatch(AuthorTagRemove(i));
                bloc.dispatch(AuthorTagModify(i, tag: tag));
              }
            },
            decoration: InputDecoration(labelText: 'Tag ' + i.toString())));
        idx++;
      }
      return widgets;
    }

    return BlocBuilder<DatabaseAuthorAddEvent, DatabaseAuthorAddState>(
      bloc: BlocProvider.of<DatabaseAuthorAddBloc>(context),
      builder: (BuildContext context, DatabaseAuthorAddState state) => Column(
        children: _getChildren(),
      ),
    );
  }
}
