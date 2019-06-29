import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
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
  String _imageUrl;
  String _musicUrl;
  List<String> _tags = <String>[];
  TextEditingController _titleController;
  TextEditingController _textController;

  final GlobalKey<FormState> _formKey = GlobalKey();

  StorageUploadTask _musicUploadTask;
  StorageUploadTask _imageUploadTask;

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

  Future<void> _pickImage() async {
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    await _uploadFile(image, _FileType.image);
  }

  Future<void> _pickMusic() async {
    final File file = await FilePicker.getFile(type: FileType.AUDIO);
    await _uploadFile(file, _FileType.music);
  }

  Future<void> _uploadFile(File file, _FileType type) async {
    if (file == null) return;

    final String fileName =
        file.path.split('/')[file.path.split('/').length - 1];
    final StorageReference reference = FirebaseStorage().ref();
    final StorageUploadTask uploadTask =
        reference.child(fileName).putFile(file);

    switch (type) {
      case _FileType.image:
        setState(() => _imageUploadTask = uploadTask);
        break;
      case _FileType.music:
        setState(() => _musicUploadTask = uploadTask);
        break;
    }
  }

  Future<void> _sendText() async {
    _formKey.currentState.save();
    if (_imageUploadTask != null || _musicUploadTask != null) {
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
                      'O texto será postado com as seguintes informações caso queira prossiguir: \nTitulo: ${_title}\nData: ${_date}\nTags: ${_tags.toString()}\n${_imageUrl != null ? 'Imagem anexada' : 'Nenhuma imagem'}\n${_musicUrl != null ? 'Musica anexada\n' : 'Nenhuma musica'}'),
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
    if (_text != null ||
        (_imageUrl != null || _imageUploadTask != null) ||
        (_musicUrl != null || _musicUploadTask != null)) {
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
      rawImgUrl: _imageUrl,
      music: _musicUrl,
      title: _title,
      tags: _tags);

  set textContent(Content content) {
    final List<String> stringList = <String>[];
    for (dynamic tag in content.tags) {
      stringList.add(tag.toString());
    }
    _text = content.text?.replaceAll('^NL', '\n');
    _date = content.rawDate;
    _imageUrl = content.rawImgUrl;
    _musicUrl = content.music;
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
                          builder: (_) => CardView(
                              heroTag: 'null', content: textContent)));
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

  Widget imageWidget() {
    return _imageUploadTask == null
        ? OutlineButton(
            onPressed: _pickImage,
            child: const Text('Escolher Plano de fundo'),
          )
        : _UploadButton(
            uploadTask: _imageUploadTask,
          );
  }

  Widget buildUploadButton(_FileType type) {
    bool urlIsNull;
    String chooseString;
    String changeString;
    VoidCallback nullifyURL;
    StorageUploadTask uploadTask;
    StringCallback setUrl;
    switch (type) {
      case _FileType.image:
        {
          urlIsNull = _imageUrl == null;
          chooseString = 'Escolher plano de fundo';
          changeString = 'Alterar plano de fundo';
          nullifyURL = () => _imageUrl = null;
          uploadTask = _imageUploadTask;
          setUrl = (String s) {
            _imageUrl = s;
            _imageUploadTask = null;
          };
          break;
        }
      case _FileType.music:
        {
          urlIsNull = _musicUrl == null;
          chooseString = 'Escolher música';
          changeString = 'Alterar música';
          nullifyURL = () => _musicUrl = null;
          uploadTask = _musicUploadTask;
          setUrl = (String s) {
            _musicUrl = s;
            _musicUploadTask = null;
            print(s.toString());
          };
          break;
        }
    }

    return uploadTask == null
        ? Row(children: <Widget>[
            if (!urlIsNull)
              IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () => setState(nullifyURL)),
            Expanded(
                child: OutlineButton(
                    onPressed: _pickMusic,
                    child: Text(urlIsNull ? chooseString : changeString)))
          ])
        : _UploadButton(
            uploadTask: uploadTask,
            onFinish: () async {
              if (uploadTask?.lastSnapshot?.storageMetadata == null)
                return setState(() => setUrl(null));

              final String url = await FirebaseStorage()
                  .ref()
                  .child(uploadTask.lastSnapshot.storageMetadata.path)
                  .getDownloadURL();
              if (mounted) {
                setState(() {
                  setUrl(url);
                });
              } else {
                setUrl(url);
              }
            });
  }
}

class _UploadButton extends StatefulWidget {
  const _UploadButton({this.uploadTask, this.onFinish, this.text});
  final StorageUploadTask uploadTask;
  final VoidCallback onFinish;
  final String text;

  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<_UploadButton> {
  StorageTaskSnapshot snapshot;

  @override
  void initState() {
    snapshot = widget.uploadTask.lastSnapshot;
    widget.uploadTask.events
      ..listen((StorageTaskEvent event) {
        if (mounted)
          setState(() => snapshot = event.snapshot);
        if (event.type == StorageTaskEventType.success) widget.onFinish();
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      onPressed: () {
        widget.uploadTask.cancel();
        widget.onFinish();
      },
      child: SizedBox(
        height: 36.0,
        child: Stack(
          children: <Widget>[
            Align(
                child: LinearProgressIndicator(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryVariant,
                    value: (snapshot?.bytesTransferred ?? 0.0) /
                        (snapshot?.totalByteCount ?? 1.0)),
                alignment: Alignment.bottomCenter),
            Center(
              child: const Text('Cancelar'),
            )
          ],
        ),
      ),
    );
  }
}

typedef StringCallback = void Function(String s);

enum _FileType { image, music }
