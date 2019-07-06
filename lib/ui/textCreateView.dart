import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textos/bloc/database_text_add/bloc.dart';
import 'package:textos/constants.dart';
import 'package:textos/model/content.dart';

import 'cardView.dart';
import 'kalilAppBar.dart';

class TextCreateView extends StatelessWidget {
  const TextCreateView({this.content});
  final Content content;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DatabaseTextAddBloc>(
      builder: (BuildContext context) =>
          DatabaseTextAddBloc.fromContent(content: content),
      child: _TextCreateView(
        content: content,
      ),
    );
  }
}

class _TextCreateView extends StatefulWidget {
  const _TextCreateView({this.content});
  final Content content;

  @override
  __TextCreateViewState createState() => __TextCreateViewState();
}

class __TextCreateViewState extends State<_TextCreateView> {
  TextEditingController _titleController;
  TextEditingController _textController;

  @override
  void initState() {
    if (widget.content != null) {
      _titleController = TextEditingController(text: widget.content.title);
      _textController = TextEditingController(text: widget.content.text);
    } else {
      _titleController = TextEditingController();
      _textController = TextEditingController();
    }
    super.initState();
  }

  Future<void> _selectDate() async {
    final DatabaseTextAddBloc bloc =
        BlocProvider.of<DatabaseTextAddBloc>(context);
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate:
          bloc.date != null ? DateTime.parse(bloc.date) : DateTime.now(),
      firstDate: DateTime(2016),
      lastDate: DateTime.now(),
      builder: (BuildContext dateContext, Widget child) {
        return Theme(
          data: Theme.of(context)
              .copyWith(primaryColorBrightness: Theme.of(context).brightness),
          child: child,
        );
      },
    );
    if (picked != null)
      bloc.dispatch(
          DateChanged(year: picked.year, month: picked.month, day: picked.day));
  }

  Future<File> _pickImage() async {
    final File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    return file;
  }

  Future<File> _pickMusic() async {
    final File file = await FilePicker.getFile(type: FileType.AUDIO);
    return file;
  }

  Future<void> _sendText() async {
    final DatabaseTextAddBloc bloc =
    BlocProvider.of<DatabaseTextAddBloc>(context);
    if (!bloc.canPop) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Aguarde!'),
                content: const Text('Aguarde o upload da foto ou da música'),
                actions: <Widget>[
                  FlatButton(
                      child: const Text(textOk),
                      onPressed: Navigator.of(context).pop)
                ],
              ));
      return;
    }
    if (bloc.date == null)
      await _selectDate();
    print(bloc.currentState);

    final bool shouldUpload = widget?.content == null
        ? await showDialog<bool>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Confirmação'),
                  content: Text(
                      'O texto será postado com as seguintes informações caso queira prossiguir: \nTitulo: ${bloc.title}\nData: ${bloc.date}\nTags: ${bloc.tags.toString()}\n${bloc.photoUrl != null ? 'Imagem anexada' : 'Nenhuma imagem'}\n${bloc.musicUrl != null ? 'Musica anexada\n' : 'Nenhuma musica'}'),
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
                ))
        : true;

    if (shouldUpload ?? false) {
      bloc.upload();
      Navigator.pop(context);
    }
  }

  Future<bool> _shouldPop() async {
    final DatabaseTextAddBloc bloc =
    BlocProvider.of<DatabaseTextAddBloc>(context);
    if (bloc.text != null) {
      final bool shouldPop = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Sair?'),
                content: const Text('Todo o progresso será perdido!'),
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
      return shouldPop;
    } else {
      return true;
    }
  }

  Widget _getTags() {
    final DatabaseTextAddBloc databaseBloc =
    BlocProvider.of<DatabaseTextAddBloc>(context);

    Widget buildItem(String item) => Material(
          elevation: 0.0,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(20.0),
            onTap: () => databaseBloc.tagManager.dispatch(ToggleTag(tag: item)),
            child: SizedBox(
              height: 56.0,
              child: Row(
                children: <Widget>[
                  Text('#' + item),
                  Spacer(),
                  Checkbox(
                      value: databaseBloc.tags.contains(item),
                      checkColor: Theme.of(context).colorScheme.onSecondary,
                      activeColor: Theme.of(context).accentColor,
                      onChanged: (_) => databaseBloc.tagManager
                          .dispatch(ToggleTag(tag: item)))
                ],
              ),
            ),
          ),
        );
    return BlocBuilder<TagManagerEvent, TagManagerState>(
        bloc: databaseBloc.tagManager,
        builder: (BuildContext context, TagManagerState state) {
          if (state is TagLoadingState &&
              (databaseBloc.tagManager.activeTags?.isEmpty ?? true))
            return const SizedBox(
                height: 56.0,
                width: 56.0,
                child: Center(child: CircularProgressIndicator()));
          return Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(20.0)),
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                children: <Widget>[
                  const Text('Tags'),
                  for (String tag in databaseBloc.tagManager?.allTags ?? databaseBloc.tags)
                    buildItem(tag),
                  if (state is TagLoadingState)
                    const SizedBox(
                        height: 56.0,
                        width: 56.0,
                        child: Center(child: CircularProgressIndicator()))
                ],
              ));
        });
  }

  Future<void> _maybeDelete() async {
    final bool delete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Deletar o texto'),
              content: const Text(
                  'O texto sera apagado, sem maneira de reverter o processo'),
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
      BlocProvider.of<DatabaseTextAddBloc>(context).delete();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseTextAddBloc bloc =
        BlocProvider.of<DatabaseTextAddBloc>(context);

    return WillPopScope(
      onWillPop: _shouldPop,
      child: Scaffold(
        appBar: const KalilAppBar(
          title: 'Editor de textos',
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Titulo'),
                    onChanged: (String title) =>
                        bloc.dispatch(TitleChanged(title: title)),
                    controller: _titleController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Texto'),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (String text) =>
                        bloc.dispatch(TextChanged(text: text)),
                    controller: _textController,
                  ),
                ],
              ),
              _getTags(),
              buildUploadButton(_FileType.image),
              buildUploadButton(_FileType.music),
              OutlineButton(
                onPressed: _selectDate,
                child: const Text('Selecionar Data'),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).colorScheme.onPrimary,
                onPressed: () {
                  Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                          builder: (_) => CardView(
                              heroTag: 'null', content: bloc.content)));
                },
                child: const Text('Visualizar o texto'),
              ),
              if (widget?.content?.textPath != null)
                RaisedButton(
                  color: Theme.of(context).colorScheme.error,
                  textColor: Theme.of(context).colorScheme.onError,
                  onPressed: _maybeDelete,
                  child: const Text('Deletar texto'),
                ),
              const SizedBox(height: 56.0)
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _sendText(),
          label: Text(
              widget?.content != null ? 'Atualizar texto' : 'Enviar texto'),
          icon: const Icon(Icons.check),
        ),
      ),
    );
  }

  Widget buildUploadButton(_FileType type) {
    String chooseString;
    String changeString;
    Function getFileFunction;
    UploadManagerBloc bloc;
    switch (type) {
      case _FileType.image:
        {
          chooseString = 'Escolher plano de fundo';
          changeString = 'Alterar plano de fundo';
          getFileFunction = _pickImage;
          bloc =
              BlocProvider.of<DatabaseTextAddBloc>(context).photoUploadManager;
          break;
        }
      case _FileType.music:
        {
          chooseString = 'Escolher música';
          changeString = 'Alterar música';
          getFileFunction = _pickMusic;
          bloc =
              BlocProvider.of<DatabaseTextAddBloc>(context).musicUploadManager;
          break;
        }
    }

    return BlocProvider<UploadManagerBloc>(
      builder: (BuildContext context) => bloc,
      child: UploadButton(
          chooseString: chooseString,
          changeString: changeString,
          getFileFunction: getFileFunction),
    );
  }
}

class UploadButton extends StatefulWidget {
  const UploadButton({
    Key key,
    @required this.chooseString,
    @required this.changeString,
    @required this.getFileFunction,
  }) : super(key: key);

  final String chooseString;
  final String changeString;
  final Function getFileFunction;

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) => BlocBuilder<UploadManagerEvent,
              UploadManagerState>(
          bloc: BlocProvider.of<UploadManagerBloc>(context),
          builder: (BuildContext context, UploadManagerState state) =>
              OutlineButton(
                  textColor: Theme.of(context).colorScheme.onBackground,
                  child: Row(
                    children: <Widget>[
                      if (state is Uploaded)
                        SizedBox(
                            height: 42.0,
                            width: 42.0,
                            child: IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () =>
                                  BlocProvider.of<UploadManagerBloc>(context)
                                      .dispatch(Delete()),
                            )),
                      Spacer(),
                      Text(state is ToUpload
                          ? widget.chooseString
                          : state is Uploading
                              ? 'Cancelar'
                              : widget.changeString),
                      Spacer(),
                      if (state is Uploading)
                        SizedBox(
                            height: 42.0,
                            width: 42.0,
                            child: Center(
                              child: CircularProgressIndicator(
                                  value: state.bytesTransferred /
                                      state.totalByteCount),
                            ))
                      else
                        if (state is Uploaded)
                          const SizedBox(
                              height: 42.0,
                              width: 42.0,
                              child: Icon(Icons.check))
                    ],
                  ),
                  onPressed: () async {
                    if (state is Uploading) {
                      BlocProvider.of<UploadManagerBloc>(context)
                          .dispatch(Cancel());
                    } else {
                      final File file = await widget.getFileFunction();
                      BlocProvider.of<UploadManagerBloc>(context)
                          .dispatch(Upload(file: file));
                    }
                  })),
    );
  }
}

enum _FileType { image, music }
