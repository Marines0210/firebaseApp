import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:app_fire/planets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

//widgets tienen un identificador, y ese es el Key. Fácil.
class FormPage extends StatefulWidget {
  final String title;
  final Planet planet;

  FormPage({Key key, this.title,this.planet}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MyFormPageState(planet);
  }
}

class MyFormPageState extends State<FormPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> genders = <String>['', 'Macho', 'Hembra'];
  final nameController = TextEditingController();
  final specieController = TextEditingController();
  final ageController = TextEditingController();
  final imageController = TextEditingController();
  String genderValue = '';
  Planet planet;

  final animalDb = FirebaseDatabase.instance.reference().child('animal');

  MyFormPageState(this.planet);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.account_box),
                      hintText: 'Cual es el nombre del animal',
                      labelText: 'Nombre',
                    ),
                  ),
                  new TextFormField(
                    controller: specieController,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.merge_type),
                      hintText: 'Es un perro, gato, iguana, etc',
                      labelText: 'Especie',
                    ),
                  ),
                  new TextFormField(
                    controller: ageController,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.date_range),
                      hintText: 'Especificar los años',
                      labelText: 'Edad',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      //Que vamos a permitir en nuestras cajas de texto
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                  ),new RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: photoOption ,
                    child: new Text("Add"),
                  ),
                  new FormField(
                    builder: (FormFieldState state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          icon: const Icon(Icons.accessibility),
                          labelText: 'Sexo',
                        ),
                        isEmpty: genderValue == '',
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton(
                            value: genderValue,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                genderValue = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: genders.map((String value) {
                              return new DropdownMenuItem(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  new Container(
                      padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                      child: new RaisedButton(
                        child: const Text('Guardar'),
                        onPressed: () {
                          sendData();
                        },
                      )),
                ],
              ))),
    );

  }
  Future<String> photoOption() async {
    try {

      PictureRecorder recorder = new PictureRecorder();
      DateTime now = new DateTime.now();
      var datestamp = new DateFormat("yyyyMMdd'T'HHmmss");
      String currentdate = datestamp.format(now);
      File _videoGallery = await ImagePicker.pickImage(source: ImageSource.gallery);

      final picture = recorder.endRecording();
      final img = picture.toImage(640, 360);
      final pngBytes = await img.toByteData(format: ImageByteFormat.png);
      Uint8List finalImage = Uint8List.view(pngBytes.buffer);

      final Directory systemTempDir = Directory.systemTemp;
      final File file = await new File('${systemTempDir.path}/foo.png').create();
      file.writeAsBytes(finalImage);
      final StorageReference ref = FirebaseStorage.instance.ref().child('images').child("$currentdate.jpg");
      final StorageUploadTask uploadTask = ref.putFile(file);

      String url = await ref.getDownloadURL() as String;
      this.planet.image = url;

      print(url);

    } catch (error) {
      print(error);
    }
  }
  void sendData() {
    animalDb.push().set({
      'name': nameController.text,
      'specie': specieController.text,
      'age': ageController.text,
      'gender': genderValue,
    }).then((_) {
      //cerrar la ventana actual cerrar el contexto actual
      Navigator.pop(context);
    });
  }
}
