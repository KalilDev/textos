import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/providers.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _userCreateKey = GlobalKey<FormState>();
  String _password;
  String _email;
  String _firstName;
  String _lastName;
  bool _isCreatingUser = false;

  Widget buildButton(bool enabled, {VoidCallback onPressed, Widget child}) {
    return AnimatedSwitcher(
      duration: durationAnimationShort,
      child: enabled
          ? RaisedButton(
              child: Container(
                  width: double.infinity, child: Center(child: child)),
              onPressed: onPressed,
            )
          : OutlineButton(
              child: Container(
                  width: double.infinity, child: Center(child: child)),
              onPressed: () =>
                  setState(() => _isCreatingUser = !_isCreatingUser)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Color.alphaBlend(
        Theme.of(context).primaryColor.withAlpha(80),
        Theme.of(context).backgroundColor);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).primaryColor,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white.withAlpha(100),
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
        appBar: AppBar(
          title: Text(
            textAppName,
            style: Theme.of(context).accentTextTheme.title.copyWith(
              fontWeight: FontWeight.bold,
                color: getTextColor(0.87,
                    bg: Theme.of(context).backgroundColor,
                    main: Theme.of(context).colorScheme.onSurface)),
          ),
          backgroundColor: color,
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  const SizedBox(height: 20.0),
                  Text(
                    textLogin,
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      onSaved: (String value) => _email = value,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          InputDecoration(labelText: textEmail)),
                  TextFormField(
                      onSaved: (String value) => _password = value,
                      obscureText: true,
                      decoration: InputDecoration(labelText: textPassword)),
                  if (_isCreatingUser)
                    AnimatedSwitcher(
                      duration: durationAnimationShort,
                      child: Form(
                          key: _userCreateKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextFormField(
                                  onSaved: (String value) => _firstName = value,
                                  decoration:
                                      InputDecoration(labelText: textName)),
                              TextFormField(
                                  onSaved: (String value) => _lastName = value,
                                  decoration:
                                      InputDecoration(labelText: textSurname)),
                            ],
                          )),
                    ),
                  const SizedBox(height: 20.0),
                  buildButton(
                    !_isCreatingUser,
                    child: const Text(textLogin),
                    onPressed: () async {
                      // save the fields..
                      final FormState form = _formKey.currentState;
                      form.save();

                      // Validate will return true if is valid, or false if invalid.
                      if (form.validate()) {
                        try {
                          await Provider.of<AuthService>(context)
                              .loginUser(email: _email, password: _password);
                        } on AuthException catch (error) {
                          return _buildErrorDialog(context, error.message);
                        } on Exception catch (error) {
                          return _buildErrorDialog(context, error.toString());
                        }
                      }
                    },
                  ),
                  buildButton(
                    _isCreatingUser,
                    child: const Text(textNewUser),
                    onPressed: () async {
                      // save the fields..
                      final FormState form = _formKey.currentState;
                      form.save();
                      final FormState userForm = _userCreateKey.currentState;
                      userForm.save();

                      // Validate will return true if is valid, or false if invalid.
                      if (form.validate() && userForm.validate()) {
                        try {
                          await Provider.of<AuthService>(context).createUser(
                              email: _email,
                              password: _password,
                              firstName: _firstName,
                              lastName: _lastName);
                          await Provider.of<AuthService>(context)
                              .loginUser(email: _email, password: _password);
                        } on AuthException catch (error) {
                          return _buildErrorDialog(context, error.message);
                        } on Exception catch (error) {
                          return _buildErrorDialog(context, error.toString());
                        }
                      }
                    },
                  ),
                  OutlineButton(
                      child: Container(
                          width: double.infinity,
                          child:
                              Center(child: const Text(textLoginAnonymously))),
                      onPressed: () => _buildConfirmationDialog(context, textAnonyConsequences)
                              .then<bool>((bool b) async {
                            if (b)
                              try {
                                await Provider.of<AuthService>(context)
                                    .anonymouslyLogin();
                              } on AuthException catch (error) {
                                return _buildErrorDialog(
                                    context, error.message);
                              } on Exception catch (error) {
                                return _buildErrorDialog(
                                    context, error.toString());
                              }
                          })),
                  OutlineButton(
                      child: Container(
                          width: double.infinity,
                          child: Stack(
                            children: <Widget>[
                              Center(
                                  child:
                                      const Text(textLoginWithGoogle)),
                            ],
                          )),
                      onPressed: () async {
                        try {
                          await Provider.of<AuthService>(context).googleLogin();
                        } on AuthException catch (error) {
                          return _buildErrorDialog(context, error.message);
                        } on Exception catch (error) {
                          return _buildErrorDialog(context, error.toString());
                        }
                      }),
                ]))));
  }

  Future<bool> _buildErrorDialog(BuildContext context, String _message) {
    return showDialog<bool>(
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(textError),
          content: Text(_message.replaceAll('Exception: ', '')),
          actions: <Widget>[
            FlatButton(
                child: const Text(textOk),
                onPressed: () {
                  Navigator.of(context).pop(true);
                })
          ],
        );
      },
      context: context,
    );
  }

  Future<bool> _buildConfirmationDialog(BuildContext context, String _message) {
    return showDialog<bool>(
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(textConfirm),
          content: Text(_message),
          actions: <Widget>[
            FlatButton(
                child: const Text(textYes),
                onPressed: () {
                  Navigator.of(context).pop(true);
                }),
            FlatButton(
                child: const Text(textNo),
                onPressed: () {
                  Navigator.of(context).pop(false);
                })
          ],
        );
      },
      context: context,
    );
  }
}
