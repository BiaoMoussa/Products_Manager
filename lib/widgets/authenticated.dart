import 'package:article_mobile_app/widgets/homeController.dart';
import 'package:flutter/material.dart';
class Authenticated extends StatefulWidget {
  const Authenticated({Key? key}) : super(key: key);

  @override
  State<Authenticated> createState() => _AuthenticatedState();
}

class _AuthenticatedState extends State<Authenticated> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Authentification"),
      ),
      body: Form(
        key: key,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(80),
            child: Card(
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text('CONNEXION', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _loginController,
                      validator: (value){
                        print(value);
                        if( value!="admin")
                          return "login incorrect ";
                         return null;
                      },
                      decoration: const InputDecoration(
                      iconColor: Colors.pink,
                        labelText: 'Login',
                        prefixIcon: Icon(Icons.account_circle),
                        filled: false,
                      ),
                    ),
                    const SizedBox(height: 18,),
                    TextFormField(
                      controller: _passwordController,
                      validator:  (value){
                        if( value!="password")
                        return "mot de passe incorrect ";
                        return null;
                        },
                      decoration: const InputDecoration(
                        iconColor: Colors.pink,
                        labelText: 'Mot de passe',
                        prefixIcon: Icon(Icons.key),
                        filled: false,
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 10,),
                    ElevatedButton(onPressed: () {
                      if(key.currentState!.validate()){
                        setState(() {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeController(title: 'Welcome To Products Manager')));
                        });
                      }
                    }, child: Text('Connexion'))
                  ],
                ),
              ),
            ),
          ),
        )
      ),
    );
  }
}
