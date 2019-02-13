import 'package:app_fire/classes/animal.dart';
import 'package:app_fire/widgets/card_animal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListViewAnimal extends StatefulWidget {
  BuildContext context;

  ListViewAnimal(this.context);

  createState() => ListViewAnimalState(this.context);
}

class ListViewAnimalState extends State<ListViewAnimal> {
  final List<Animal> animals = [];
  final mainReference = FirebaseDatabase.instance.reference();
  BuildContext context;

  ListViewAnimalState(this.context);

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

  @override
  Widget build(BuildContext context) {
    DatabaseReference bd=  FirebaseDatabase.instance.reference().child('animal');
    bd.once().then((DataSnapshot snapshot){
      animals.clear();
      loadData(snapshot);
    });
    return loadListView();
  }

  loadListView() {
    return  new ListView.builder(
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
        });
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
