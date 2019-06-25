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

class TextCreateView extends StatefulWidget {
  @override
  _TextCreateViewState createState() => _TextCreateViewState();
}

class _TextCreateViewState extends State<TextCreateView> {
  String _title;
  String _text;
  String _date;
  String _imageUrl;
  String _musicUrl;
  bool _imageLoading = false;
  bool _musicLoading = false;
  List<String> _tags = <String>[];

  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2016),
        lastDate: DateTime.now(),
      builder: (BuildContext dateContext, Widget child) {
        return Theme(
          data: Theme.of(context).copyWith(primaryColorBrightness: Theme.of(context).brightness),
          child: child,
        );
      },);
    if (picked != null) {
      String normalize(int date) {
        if (date < 10)
          return '0' + date.toString();
        return date.toString();
      }

      _date = picked.year.toString() +
          normalize(picked.month) +
          normalize(picked.day);
    }
  }

  Future<String> _pickImage() async {
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    final dynamic result = await _uploadFile(image, _FileType.image);
    setState(() => _imageUrl = result.toString());
    return result.toString();
  }

  Future<String> _pickMusic() async {
    final File file = await FilePicker.getFile(type: FileType.AUDIO);
    final dynamic result = await _uploadFile(file, _FileType.music);
    setState(() => _musicUrl = result.toString());
    return result.toString();
  }

  Future<dynamic> _uploadFile(File file, _FileType type) async {
    final String fileName =
        file.path.split('/')[file.path.split('/').length - 1];
    setState(() {
      switch (type) {
        case _FileType.image:
          _imageLoading = true;
          break;
        case _FileType.music:
          _musicLoading = true;
          break;
      }
    });
    final StorageReference reference = FirebaseStorage().ref();
    final StorageUploadTask uploadTask =
        reference.child(fileName).putFile(file);
    while (uploadTask.isInProgress == true)
      await Future<void>.delayed(Duration(milliseconds: 200));
    setState(() {
      switch (type) {
        case _FileType.image:
          _imageLoading = false;
          break;
        case _FileType.music:
          _musicLoading = false;
          break;
      }
    });
    return await reference.child(fileName).getDownloadURL();
  }

  Future<void> _sendText() async {
    if (_imageLoading || _musicLoading) {
      showDialog<void>(context: context, builder: (BuildContext context) => AlertDialog(
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
    if (_date == null)
      await _selectDate();

    final bool shouldUpload = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Confirmação'),
              content: Text('O texto será postado com as seguintes informações caso queira prossiguir: \nTitulo: ${_title}\nData: ${_date}\nTags: ${_tags.toString()}\n${_imageUrl != null ? 'Imagem anexada' : 'Nenhuma imagem'}\n${_musicUrl != null ? 'Musica anexada\n' : 'Nenhuma musica'}'),
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

    if (shouldUpload) {
      final FirebaseUser user = await Provider.of<AuthService>(context).getUser();
      Firestore.instance.collection('texts').document(user.uid).collection('documents').add(textContent.toData());
      Navigator.pop(context);
    }
  }

  Future<bool> _shouldPop() async {
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
  }

  Content get textContent => Content(
      text: _text,
      date: _date,
      imgUrl: _imageUrl,
      music: _musicUrl,
      title: _title,
      tags: _tags);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _shouldPop,
      child: Scaffold(
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
                        onSaved: (String title) => _title = title),
                    TextFormField(
                        decoration: InputDecoration(labelText: 'Texto'),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onSaved: (String text) => _text = text),
                    TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Tags (Separadas por vírgula)'),
                        onSaved: (String tags) => _tags = tags.split(',')),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlineButton(
                      onPressed: _imageLoading ? null : _pickImage,
                      child: _imageLoading
                          ? const SizedBox(
                              height: 18.0,
                              width: 18.0,
                              child: CircularProgressIndicator())
                          : const Text('Escolher Plano de fundo'),
                    ),
                  ),
                  _imageUrl != null ? const Padding(padding: EdgeInsets.symmetric(horizontal: 4.0),child: Icon(Icons.check)) : const SizedBox()
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlineButton(
                      onPressed: _musicLoading ? null : _pickMusic,
                      child: _musicLoading
                          ? const SizedBox(
                              height: 18.0,
                              width: 18.0,
                              child: CircularProgressIndicator())
                          : const Text('Escolher Musica'),
                    ),
                  ),
                  _musicUrl != null ? const Padding(padding: EdgeInsets.symmetric(horizontal: 4.0),child: Icon(Icons.check)) : const SizedBox()
                ],
              ),
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
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _sendText,
          label: const Text('Enviar texto'),
          icon: const Icon(Icons.check),
        ),
      ),
    );
  }
}

enum _FileType { image, music }
