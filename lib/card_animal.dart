
import 'package:app_fire/animal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardAnimal extends StatelessWidget {
  Animal animal;
  CardAnimal(this.animal);
  @override
  Widget build(BuildContext context) {
    return item(this.animal); //Error, How do i pass the arguments?
  }


  Widget item(Animal animal) {
    return new Card(
      child: new Column(
        children: <Widget>[
          new Container(
              height: 144.0,
              width: 500.0,
              color: Colors.green,
              child: FadeInImage.assetNetwork(
                  placeholder: "img/cody.jpg",
                  image: animal.image,
                  height: 144.0,
                  width: 160.0
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
    );
  }
}