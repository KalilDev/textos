import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:textos/bloc/bloc.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/model/content.dart';
import 'package:textos/src/providers.dart';

import 'cardView.dart';
import 'kalilAppBar.dart';

class TextCreateView extends StatefulWidget {
  const TextCreateView({this.content});
  final Content content;

  @override
  _TextCreateViewState createState() => _TextCreateViewState();
}

class _TextCreateViewState extends State<TextCreateView> {
  String _title;
  String _text;
  String _date;
  List<String> _tags = <String>[];
  TextEditingController _titleController;
  TextEditingController _textController;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<_UploadButtonState> _imageKey = GlobalKey();
  final GlobalKey<_UploadButtonState> _musicKey = GlobalKey();

  @override
  void initState() {
    if (widget.content != null) {
      textContent = widget.content;
      _titleController = TextEditingController(text: _title);
      _textController = TextEditingController(text: _text);
    } else {
      _titleController = TextEditingController();
      _textController = TextEditingController();
    }
    super.initState();
  }

  Future<void> _selectDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date != null ? DateTime.parse(_date) : DateTime.now(),
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
    if (picked != null) {
      String normalize(int date) {
        if (date < 10) return '0' + date.toString();
        return date.toString();
      }

      _date = picked.year.toString() +
          normalize(picked.month) +
          normalize(picked.day);
    }
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
    _formKey.currentState.save();
    if (!_imageKey.currentState.canPop && !_musicKey.currentState.canPop) {
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
    if (_date == null) await _selectDate();

    final bool shouldUpload = widget?.content == null
        ? await showDialog<bool>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Confirmação'),
                  content: Text(
                      'O texto será postado com as seguintes informações caso queira prossiguir: \nTitulo: ${_title}\nData: ${_date}\nTags: ${_tags.toString()}\n${_imageKey.currentState.fileUrl != null ? 'Imagem anexada' : 'Nenhuma imagem'}\n${_musicKey.currentState.fileUrl != null ? 'Musica anexada\n' : 'Nenhuma musica'}'),
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

    if (shouldUpload) {
      final FirebaseUser user =
          await Provider.of<AuthService>(context).getUser();
      if (widget?.content?.textPath != null) {
        Firestore.instance
            .document(widget.content.textPath)
            .updateData(textContent.toData());
      } else {
        Firestore.instance
            .collection('texts')
            .document(user.uid)
            .collection('documents')
            .add(textContent.toData());
      }
      Navigator.pop(context);
    }
  }

  Future<bool> _shouldPop() async {
    if (_text != null) {
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
    Future<List<dynamic>> _fetchFromDB() async {
      final FirebaseUser user =
          await Provider.of<AuthService>(context).getUser();
      return Firestore.instance
          .collection('texts')
          .document(user.uid)
          .get()
          .then<List<dynamic>>((DocumentSnapshot snap) => snap.data['tags']);
    }

    List<Widget> _buildList(List<dynamic> list) {
      Widget buildItem(String item) => Material(
            elevation: 0.0,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(20.0),
              onTap: () => setState(() {
                    if (_tags.contains(item)) {
                      _tags.remove(item);
                    } else {
                      _tags.add(item);
                    }
                  }),
              child: SizedBox(
                height: 56.0,
                child: Row(
                  children: <Widget>[
                    Text('#' + item),
                    Spacer(),
                    Checkbox(
                        value: _tags.contains(item),
                        checkColor: Theme.of(context).colorScheme.onSecondary,
                        activeColor: Theme.of(context).accentColor,
                        onChanged: (_) {
                          setState(() {
                            if (_tags.contains(item)) {
                              _tags.remove(item);
                            } else {
                              _tags.add(item);
                            }
                          });
                        })
                  ],
                ),
              ),
            ),
          );

      final List<Widget> widgets = <Widget>[];
      for (dynamic element in list) {
        widgets.add(buildItem(element.toString()));
      }
      return widgets;
    }

    return FutureBuilder<List<dynamic>>(
        future: _fetchFromDB(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData && (snapshot?.data?.isNotEmpty ?? false))
            return Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(20.0)),
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  children: <Widget>[
                    const Text('Tags'),
                    ..._buildList(snapshot.data)
                  ],
                ));

          return const SizedBox();
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
    if (delete) Firestore.instance.document(widget.content.textPath).delete();
    Navigator.of(context).pop();
  }

  Content get textContent => Content(
      text: _text,
      rawDate: _date,
      rawImgUrl: _imageKey.currentState.fileUrl,
      music: _musicKey.currentState.fileUrl,
      title: _title,
      tags: _tags);

  set textContent(Content content) {
    final List<String> stringList = <String>[];
    for (dynamic tag in content.tags) {
      stringList.add(tag.toString());
    }
    _text = content.text?.replaceAll('^NL', '\n');
    _date = content.rawDate;
    _title = content.title;
    _tags = stringList;
  }

  @override
  Widget build(BuildContext context) {
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
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Titulo'),
                      onSaved: (String title) => _title = title,
                      controller: _titleController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Texto'),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onSaved: (String text) => _text = text,
                      controller: _textController,
                    ),
                  ],
                ),
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
                  _formKey.currentState.save();
                  Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                          builder: (_) =>
                              CardView(heroTag: 'null', content: textContent)));
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
          onPressed: _sendText,
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
    GlobalKey<_UploadButtonState> key;
    switch (type) {
      case _FileType.image:
        {
          chooseString = 'Escolher plano de fundo';
          changeString = 'Alterar plano de fundo';
          getFileFunction = _pickImage;
          key = _imageKey;
          break;
        }
      case _FileType.music:
        {
          chooseString = 'Escolher música';
          changeString = 'Alterar música';
          getFileFunction = _pickMusic;
          key = _musicKey;
          break;
        }
    }

    return BlocProvider<UploadManagerBloc>(
      builder: (BuildContext context) =>
          UploadManagerBloc(fileUrl: widget?.content?.music),
      child: UploadButton(chooseString: chooseString, changeString: changeString, getFileFunction: getFileFunction, key: key),
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
  String get fileUrl => BlocProvider.of<UploadManagerBloc>(context).fileUrl;
  bool get canPop => !(BlocProvider.of<UploadManagerBloc>(context).currentState is Uploading);

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
                          : state is Uploading ? 'Cancelar' : widget.changeString),
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
