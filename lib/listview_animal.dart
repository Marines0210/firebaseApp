import 'package:app_fire/animal.dart';
import 'package:app_fire/card_animal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  BuildContext context;

  MyApp(this.context);

  createState() => HomePageBody(this.context);
}

class HomePageBody extends State<MyApp> {
  final List<Animal> animals = [];
  final mainReference = FirebaseDatabase.instance.reference();
  BuildContext context;

  HomePageBody(this.context);

  @override
  void initState() {
    super.initState();
    mainReference.onChildAdded.listen(_onEntryAdded);
  }

  _onEntryAdded(Event event) {
    setState(() {
      animals.clear();
      loadData(event.snapshot);
    });
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
          animals.clear();
          loadData(snap.data.snapshot);
          return loadListView();
        });
  }

  loadListView() {
    return  Expanded(                         // wrap the ListView
        child:new ListView.builder(
        shrinkWrap: true,
        itemCount: animals.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Dismissible(
              key: ObjectKey(animals[index]),
              child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: CardAnimal(animals[index], context)),
              onDismissed: (direction) {
                deleteItem(index);
              });
        }));
  }

  void deleteItem(index) {
    setState(() {
      FirebaseDatabase.instance
          .reference()
          .child('animal')
          .child(animals[index].key)
          .remove();
      animals.removeAt(index);
    });
  }

  void undoDeletion(index, item) {
    /*
  This method accepts the parameters index and item and re-inserts the {item} at
  index {index}
  */
    setState(() {
      animals.insert(index, item);
    });
  }

  void loadData(DataSnapshot snap) async {
    print(snap.key);
    print(snap);
    final value = snap.value as Map;
    for (final key in value.keys) {
      Map<dynamic, dynamic> map = value[key];
      print("holaaaaaaaaa");
      print(map['name']);
      animals.add(new Animal(key, map['name'], map['specie'], map['age'],
          map['gender'], map['image']));
    }
  }
}
