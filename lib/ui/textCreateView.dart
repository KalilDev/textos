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

  GlobalKey<FormState> _formKey = GlobalKey();

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2016),
        lastDate: DateTime.now());
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

  Future<String> _pickImage() async {
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    final dynamic result = await _uploadFile(image, _FileType.image);
    _imageUrl = result.toString();
    return result.toString();
  }

  Future<String> _pickMusic() async {
    final File file = await FilePicker.getFile(type: FileType.AUDIO);
    final dynamic result = await _uploadFile(file, _FileType.music);
    _musicUrl = result.toString();
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
    final reference = FirebaseStorage().ref();
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

  void _sendText() async {
    final bool shouldUpload = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Confirmação'),
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
    }
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
    return Scaffold(
      body: ListView(
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
                    onSaved: (String text) => _text = text),
                TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Tags (Separadas por vírgula)'),
                    onSaved: (String tags) => _tags = tags.split(',')),
              ],
            ),
          ),
          RaisedButton(
            onPressed: _imageLoading ? null : _pickImage,
            child: _imageLoading
                ? SizedBox(
                    height: 18.0,
                    width: 18.0,
                    child: CircularProgressIndicator())
                : Text('Escolher Plano de fundo'),
          ),
          RaisedButton(
            onPressed: _musicLoading ? null : _pickMusic,
            child: _musicLoading
                ? SizedBox(
                    height: 18.0,
                    width: 18.0,
                    child: CircularProgressIndicator())
                : Text('Escolher Musica'),
          ),
          RaisedButton(
            onPressed: _selectDate,
            child: Text('Escolher Data'),
          ),
          RaisedButton(
            onPressed: () {
              _formKey.currentState.save();
              Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          CardView(heroTag: 'null', content: textContent)));
            },
            child: Text('Visualizar'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _sendText,
        label: Text('Enviar texto'),
        icon: Icon(Icons.check),
      ),
    );
  }
}

enum _FileType { image, music }
