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
    //evnto para recargar la lista cuando se reciba push de firebase
    mainReference.onChildAdded.listen(onEntryAdded);
  }

  onEntryAdded(Event event) {
    setState(() {
      //limpiar la lista para actualizar
      animals.clear();
      loadData(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    //obtener la lista de registros en firebase
    DatabaseReference bd=  FirebaseDatabase.instance.reference().child('animal');
    bd.once().then((DataSnapshot snapshot){
      animals.clear();
      loadData(snapshot);
    });
    return loadListView();
  }

  //Widget list
  loadListView() {
    //builder para detectar cambios y actualizar
    return  new ListView.builder(
        shrinkWrap: true,
        itemCount: animals.length,
        itemBuilder: (BuildContext ctxt, int index) {
          //Dismissible swipe para eliminar
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

  //Eliminar item de firebase y de la lista
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


  //Obtener datos de firebase y guardarlos en un objeto animal y la lista animals
  void loadData(DataSnapshot snap) async {
    print(snap.key);
    print(snap);
    //Obtenermos las llaves ya que no pueden ser agregadas al crear es el id de cada elemento
    final value = snap.value as Map;
    for (final key in value.keys) {
      //de las llaves obtenemos los elementos
      Map<dynamic, dynamic> map = value[key];
      //agregamos cada elemento al objeto y a la lista
      animals.add(new Animal(key, map['name'], map['specie'], map['age'],
          map['gender'], map['image']));
    }
  }
}
