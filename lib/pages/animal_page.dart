import 'package:app_fire/classes/Auth.dart';
import 'package:app_fire/pages/animal_form_page.dart';
import 'package:app_fire/widgets/listview_animal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  HomePage({this.auth, this.onSignOut});
  final Auth auth;
  final VoidCallback onSignOut;
  @override
  Widget build(BuildContext context) {
    void _signOut() async {
      try {
        await auth.signOut();
        onSignOut();
      } catch (e) {
        print(e);
      }
    }
      return MaterialApp(
        home: Scaffold(
          //floating para crear usuario
      floatingActionButton: new FloatingActionButton(
          shape: StadiumBorder(),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FormAnimal(title: 'Nuevo animal')));
          },
          backgroundColor: Colors.redAccent,
          child: Icon(
            Icons.add,
            size: 20.0,
          )),
      body:  new ListViewAnimal(context)
          ,
      appBar: AppBar(title: const Text('Adopcion'),
          actions: <Widget>[   new FlatButton(
          onPressed: _signOut,
          child: new Text('Cerrar sesión', style: new TextStyle(fontSize: 17.0, color: Colors.white))
      )]),
    ));
  }
}

