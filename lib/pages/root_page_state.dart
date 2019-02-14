import 'package:app_fire/classes/Auth.dart';
import 'package:app_fire/pages/animal_page.dart';
import 'package:app_fire/pages/login_page.dart';
import 'package:flutter/cupertino.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key, this.auth}) : super(key: key);
  final Auth auth;

  @override
  State<StatefulWidget> createState() => new RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}
class RootPageState extends State<RootPage> {

  AuthStatus authStatus = AuthStatus.notSignedIn;

  initState() {
    super.initState();
    //Verificamos
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus = userId != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
      });
    });
  }

  void updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Verificamos si el usuario esta logueado o no
    switch (authStatus) {
      //Sino ha iniciado session redireccionamos a la pagina de login
      case AuthStatus.notSignedIn:
        return new LoginPage(
          title: 'Login',
          auth: widget.auth,
          onSignIn: () => updateAuthStatus(AuthStatus.signedIn),
        );
        //Si inicio session entonces lo enviamos a la vista principal
      case AuthStatus.signedIn:
        return new HomePage(
            auth: widget.auth,
            onSignOut: () => updateAuthStatus(AuthStatus.notSignedIn)
        );
    }
  }
}