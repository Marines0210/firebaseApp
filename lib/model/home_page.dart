import 'package:app_fire/model/form_page.dart';
import 'package:app_fire/planets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      floatingActionButton: new FloatingActionButton(
          shape: StadiumBorder(),
          onPressed: () {
            HomePageBody.stream = HomePageBody.newStream();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FormPage(title: 'Nuevo animal')));
          },
          backgroundColor: Colors.redAccent,
          child: Icon(
            Icons.add,
            size: 20.0,
          )),
      body: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new MyApp(),
          ],
        ),
      ),
      appBar: AppBar(title: const Text('Adopcion')),
    ));
  }
}
class MyApp extends StatefulWidget {
  createState() => HomePageBody();
}
class HomePageBody extends State<MyApp> {
  final List<Planet> planets = [];
  final List<Widget> planetRow = [];
  final mainReference = FirebaseDatabase.instance.reference();
  static var stream; // state variable

  @override
  void initState() {
    super.initState();
    stream = newStream(); // initial stream
  }

  static Stream<String> newStream() =>
      Stream.periodic(Duration(seconds: 1), (i) => "$i");

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child('animal').onValue,
        builder: (context, snap) {
          if (snap.hasError) return new Text('Error: ${snap.error}');
          if (snap.data == null)
            return new Center(
              child: new CircularProgressIndicator(),
            );
          loadListView();
          loadData(snap.data.snapshot);
          return loadListView();
        });
  }


  loadListView() {
    return new ListView.builder(
        shrinkWrap: true,
        itemCount: planets.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Dismissible(
              key: ObjectKey(planets[index]),
              child: Container(
                  padding: EdgeInsets.all(20.0), child: item(planets[index])),
              onDismissed: (direction) {
                deleteItem(index);
              });

        });
  }
  void deleteItem(index){

    setState((){
      FirebaseDatabase.instance.reference().child('animal').child(planets[index].key).remove();
      planets.removeAt(index);
    });
  }

  void undoDeletion(index, item){
    /*
  This method accepts the parameters index and item and re-inserts the {item} at
  index {index}
  */
    setState((){
      planets.insert(index, item);
    });
  }
  Widget item(Planet planet) {
    return new Card(
      child: new Column(
        children: <Widget>[
          new Container(
            height: 144.0,
            width: 500.0,
            color: Colors.green,
            child: new Image.asset("img/cody.jpg", height: 144.0, width: 160.0),
          ),
          new Padding(
              padding: new EdgeInsets.all(7.0),
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Icon(Icons.pets),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Text(
                      planet.specie,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Icon(Icons.wc ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Text(planet.gender,
                        style: new TextStyle(fontSize: 18.0)),
                  ),new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Icon(Icons.cake),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Text(
                      planet.age,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  void loadData(DataSnapshot snap) async {
    print(snap.key);
    print(snap);
    final value = snap.value as Map;
    for (final key in value.keys) {
      Map<dynamic, dynamic> map = value[key];
      print("holaaaaaaaaa");
      print(map['name']);
      planets.add(
          new Planet(key,map['name'], map['specie'], map['age'], map['gender']));
    }
  }
}
