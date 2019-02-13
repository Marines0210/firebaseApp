
import 'package:app_fire/classes/Auth.dart';
import 'package:app_fire/model/login_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      //Agregamos el titulo de appbar
      title: "Animals",
      home: new RootPage(auth: new Auth()),

    );
  }

}
