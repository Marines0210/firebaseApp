import 'package:app_fire/animal.dart';
import 'package:flutter/material.dart';

class AnimalRow extends StatelessWidget {

  final Animal animal;
  AnimalRow(this.animal);

  @override
  Widget build(BuildContext context) {

    print('Connected to second database and planet vista ${animal.name}');

    final baseTextStyle = const TextStyle(
        fontFamily: 'Poppins'
    );
    final regularTextStyle = baseTextStyle.copyWith(
        color: const Color(0xffb6b2df),
        fontSize: 9.0,
        fontWeight: FontWeight.w400
    );
    final subHeaderTextStyle = regularTextStyle.copyWith(
        fontSize: 12.0
    );
    final headerTextStyle = baseTextStyle.copyWith(
        color: Colors.black87,
        fontSize: 20.0,
        fontWeight: FontWeight.w600
    );

    Widget _planetValue({String value, String image}) {
      return new Row(
          children: <Widget>[
            new Image.asset(image, height: 12.0),
            new Container(width: 8.0),
            new Text(animal.specie, style: regularTextStyle),
          ]
      );
    }


    final planetCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      color: new Color(0xFFFFFFFF),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 4.0),
          new Image.asset("", height: 100.0,fit: BoxFit.fitWidth),
          new Text(animal.name, style: headerTextStyle),
          new Container(height: 10.0),
          new Text(animal.specie, style: subHeaderTextStyle),
          new RaisedButton(
            padding: const EdgeInsets.all(8.0),
            textColor: Colors.white,
            color: Colors.blue,
            child: new Text("Add"),
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                  child: _planetValue(
                      value: animal.gender,
                      image: 'img/ic_distance.png')

              ),
              new Expanded(
                  child: _planetValue(
                      value: animal.specie,
                      image: 'img/ic_gravity.png')
              )
            ],
          ),
        ],
      ),
    );



    //agregar marguen solo en un lado  --> margin: new EdgeInsets.only(left: 46.0),

    final planetCard = new Container(
      child: planetCardContent,
      height: 700.0,
      decoration: new BoxDecoration(
        color: new Color(0xFF455A64),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
    );


    return new Container(

        height: 200.0,
      width: double.infinity,
        margin: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 10.0,
        ),
        child: new Stack(
          children: <Widget>[
            planetCard,
          ],
        )
    );
  }


}