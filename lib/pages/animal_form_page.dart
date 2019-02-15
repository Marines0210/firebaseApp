import 'dart:io';
import 'dart:ui';

import 'package:app_fire/classes/animal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

//widgets tienen un identificador, y ese es el Key. Fácil.
class FormAnimal extends StatefulWidget {
  final String title;
  final Animal animal;

  FormAnimal({Key key, this.title,this.animal}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MyFormPageState(animal);
  }
}

class MyFormPageState extends State<FormAnimal> {

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  //Dos formas para obtener los widgent con cotroller y con key
  List<String> genders = <String>['', 'Macho', 'Hembra'];
  final nameController = TextEditingController();
  final specieController = TextEditingController();
  final ageController = TextEditingController();
  String genderValue = '';
  Animal animal;
  File galleryFile;
  String urlImage;
  final animalDb = FirebaseDatabase.instance.reference().child('animal');

  MyFormPageState(this.animal);

  @override
  void initState() {
    super.initState();
    //Detectamos si es editar llenamos todos los campos con los datos correspondientes
    if(animal!=null) {
      nameController.text = animal.name;
      specieController.text = animal.specie;
      ageController.text = animal.age;
      genderValue=animal.gender;
      displaySelectedFile();
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          //Crear dormulario
          child: new Form(
              key: formKey,
              autovalidate: true,
              //Lo agregamos a una lista
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
                    //Botton para agregar seleccionar una imagen
                  ), new RaisedButton(
                      padding: const EdgeInsets.all(8.0),
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: new RaisedButton(
                        child: new Text('Selecciona una imagen'),
                        onPressed: imageSelectorGallery,
                      )
                  ), displaySelectedFile(),
                  //Guardar
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

  //ImagePicker para seleccionar una imagen de la galeria hay dependencia "image_picker: 0.5.0+3"
  imageSelectorGallery() async {
    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800.0,
      maxWidth: 700.0,
    );
    setState(() {});
  }

  //Mostrar imagen seleccionada
  Widget displaySelectedFile() {
    return new SizedBox(
      child: (galleryFile == null)
          ?  new Text('Foto no seleccionada!!')
          : new Image.file(galleryFile),
    );
  }



  //Si es editar tenemos enviamos key para actualizar el elemento sino es crear
  void sendData() {
    if(animal!=null){
      animalDb.child(animal.key).set({
        'name': nameController.text,
        'specie': specieController.text,
        'age': ageController.text,
        'gender': genderValue,
        'image': (urlImage) != null ? urlImage : "",
      }).then((_) {
        //cerrar la ventana actual cerrar el contexto actual
        Navigator.pop(context);
      });
    }else {
      saveImageFirebase(nameController.text).then((_) {
        animalDb.push().set({
          'name': nameController.text,
          'specie': specieController.text,
          'age': ageController.text,
          'gender': genderValue,
          'image': (urlImage) != null ? urlImage : "",
        }).then((_) {
          //cerrar la ventana actual cerrar el contexto actual
          Navigator.pop(context);
        });
      });
    }

  }
  //Guardar imagen en firebase aqui hay que agregar dependencia "firebase_storage"
  Future<void> saveImageFirebase(String imageId) async {
    StorageReference ref = FirebaseStorage.instance.ref().child("pets").child(
        imageId);
    StorageUploadTask uploadTask = ref.putFile(galleryFile);
    final StorageTaskSnapshot downloadUrl =(await uploadTask.onComplete);
    urlImage = (await downloadUrl.ref.getDownloadURL());
    print('URL Is $urlImage');
  }
}
