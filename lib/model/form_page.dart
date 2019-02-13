import 'dart:io';
import 'dart:ui';

import 'package:app_fire/animal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

//widgets tienen un identificador, y ese es el Key. Fácil.
class FormPage extends StatefulWidget {
  final String title;
  final Animal animal;

  FormPage({Key key, this.title,this.animal}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MyFormPageState(animal);
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
  Animal animal;
  File galleryFile;
  String urlImage;
  final animalDb = FirebaseDatabase.instance.reference().child('animal');

  MyFormPageState(this.animal);

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
                  ), new RaisedButton(
                      padding: const EdgeInsets.all(8.0),
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: new RaisedButton(
                        child: new Text('Selecciona una imagen'),
                        onPressed: imageSelectorGallery,
                      )
                  ), displaySelectedFile(),
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

  imageSelectorGallery() async {
    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800.0,
      maxWidth: 700.0,
    );
    print("Imagen seleccionada : " + galleryFile.path);
    setState(() {});
  }

  Widget displaySelectedFile() {
    return new SizedBox(
//child: new Card(child: new Text(''+galleryFile.toString())),
//child: new Image.file(galleryFile),
      child: galleryFile == null
          ? new Text('Foto no seleccionada!!')
          : new Image.file(galleryFile),
    );
  }


  void sendData() {
    saveImageFirebase(nameController.text).then((_){
      animalDb.push().set({
        'name': nameController.text,
        'specie': specieController.text,
        'age': ageController.text,
        'gender': genderValue,
        'image': (urlImage)!=null?urlImage:"",
      }).then((_) {
        //cerrar la ventana actual cerrar el contexto actual
        Navigator.pop(context);
      });
    });

  }
  Future<void> saveImageFirebase(String imageId) async {
    StorageReference ref = FirebaseStorage.instance.ref().child("pets").child(
        imageId);
    StorageUploadTask uploadTask = ref.putFile(galleryFile);
    final StorageTaskSnapshot downloadUrl =(await uploadTask.onComplete);
    urlImage = (await downloadUrl.ref.getDownloadURL());
    print('URL Is $urlImage');
  }
}
