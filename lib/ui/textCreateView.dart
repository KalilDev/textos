import 'dart:io';

import 'package:flutter/material.dart';
import 'package:textos/src/model/content.dart';

import 'cardView.dart';

class TextCreateView extends StatefulWidget {
  @override
  _TextCreateViewState createState() => _TextCreateViewState();
}

class _TextCreateViewState extends State<TextCreateView> {
  String _title;
  String _text;
  String _date;
  List<String> _tags;

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

  void _pickImage() {

  }

  void _pickMusic() {

  }

  void _uploadFile(File file) {
    return;
  }

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
            onPressed: _pickImage,
            child: Text('Escolher Plano de fundo'),
          ),
          RaisedButton(
            onPressed: _pickMusic,
            child: Text('Escolher Musica'),
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
                      builder: (_) => CardView(
                          heroTag: 'null',
                          content: Content(
                              text: _text,
                              date: _date,
                              imgUrl: null,
                              title: _title))));
            },
            child: Text('Visualizar'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: null,
        label: Text('Enviar texto'),
        icon: Icon(Icons.check),
      ),
    );
  }
}
