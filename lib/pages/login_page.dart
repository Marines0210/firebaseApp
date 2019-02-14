import 'package:app_fire/classes/Auth.dart';
import 'package:app_fire/widgets/round_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.auth, this.onSignIn}) : super(key: key);

  final String title;
  final Auth auth;
  final VoidCallback onSignIn;

  @override
  LoginPageState createState() => new LoginPageState();
}

//Vamos a crear un conjunto de contastes que vamos a poder acceder a estas a travez de FormType
enum FormType {
  login,
  register
}

class LoginPageState extends State<LoginPage> {
  //variable para guardar y obteenr nuestro dormulario
  static final formKey = new GlobalKey<FormState>();

  //
  var email  = TextEditingController();
  var password = TextEditingController();

  //Inicialisamos con login
  FormType formType = FormType.login;


  //Creamos un metodo para especificar que hara nuestro boton
  void validateSubmit() async {
      try {
        //si el tipo es igual a login entonces iniciamos session sino creamos la cuenta
        String userId = formType == FormType.login
            ? await widget.auth.signIn(email.text, password.text)
            : await widget.auth.createUser(email.text, password.text);
        widget.onSignIn();
      }
      catch (e) {
        setState(() {
        print('Error al iniciar session ${e.toString()}');
        });
        print(e);
      }
  }

  void moveToRegister() {
    //reset el formulario y mostrar registrar
    formKey.currentState.reset();
    setState(() {
      formType = FormType.register;
    });
  }

  void moveToLogin() {
    //reset el formulario y mostrar login
    formKey.currentState.reset();
    setState(() {
      formType = FormType.login;
    });
  }

  //Creamos nuestro widget que tendra el usuario contraseña
  List<Widget> usernameAndPassword() {
    return [
      padded(child: new TextFormField(
        controller: email,
        decoration: new InputDecoration(labelText: 'Email'),
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'El correo no puede estar vacio.' : null,
      )),
      padded(child: new TextFormField(
        controller: password,
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'La contraseña no puede estar vacia.': null,
      )),
    ];
  }

  List<Widget> submitWidgets() {
    switch (formType) {
      //Verificamos que mostrar en el boton y text view si es tipo login o registrar
      case FormType.login:
        return [
          //llamamos nuestra clase RoundButton que creamos
          new RoundButton(
              text: 'Iniciar Sesisión',
              height: 44.0,
              onPressed: validateSubmit
          ),
          new FlatButton(
              child: new Text("No tienes una cuenta? Registrate"),
              onPressed: moveToRegister
          ),
        ];
        //Si es registrarse entonces mostramos el texto que corresponde
      case FormType.register:
        return [
          new RoundButton(
              text: 'Create cuenta',
              height: 44.0,
              onPressed: validateSubmit
          ),
          new FlatButton(
              child: new Text("Iniciar sesión"),
              //Al dar clic mostramos login
              onPressed: moveToLogin
          ),
        ];
    }
    return null;
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        backgroundColor: Colors.grey[300],
        body: new SingleChildScrollView(child: new Container(
            padding: const EdgeInsets.all(16.0),
            child: new Column(
                children: [
                  new Card(
                      child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Container(
                                padding: const EdgeInsets.all(16.0),
                                child: new Form(
                                    key: formKey,
                                    child: new Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: usernameAndPassword() + submitWidgets(),
                                    )
                                )
                            ),
                          ])
                  ),
                ]
            )
        ))
    );
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }


}



