
import 'package:app_fire/classes/animal.dart';
import 'package:app_fire/pages/animal_form_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class CardAnimal extends StatelessWidget {
  Animal animal;
  BuildContext context;
  CardAnimal(this.animal,this.context);
  @override
  Widget build(BuildContext context) {
    return item(this.animal); //Error, How do i pass the arguments?
  }


  Widget item(Animal animal) {
    //InkWell click en cada cardview
    return InkWell(
        onTap: () {
          Navigator.push(
              this.context,
              MaterialPageRoute(
                //Enviamos a nuevo pero con el objeto lleno por lo cual detectara como ieditar
                  builder: (context) => FormAnimal(title: 'Nuevo animal',animal: animal)));
        },
      child: new Card(
      child: new Column(
        children: <Widget>[
          new Container(
              height: 144.0,
              width: 500.0,
              color: Colors.green,
              //Imagen por default o imagen de internet
              child: FadeInImage.assetNetwork(
                  placeholder: "img/cody.jpg",
                  image: animal.image,
                  height: 144.0,
                  width: 160.0
              )
          ),new Padding(
    padding: new EdgeInsets.all(7.0),
    child: new Text(
        animal.name,
        style: new TextStyle(fontSize: 18.0)
      )
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
                      animal.specie,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Icon(Icons.wc),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Text(animal.gender,
                        style: new TextStyle(fontSize: 18.0)),
                  ), new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Icon(Icons.cake),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Text(
                      animal.age,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ))
        ],
      ),
      ) );
  }
  }