import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart' ;
import 'package:otero_mandy_new/screens/signupScreen.dart';
import 'package:otero_mandy_new/sqlDatabase/databaseHelper.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreenHome()
    );
  }
}

class LoginScreenHome extends StatefulWidget {
  @override
  State<LoginScreenHome> createState() => _LoginScreenHomeState();
}

class _LoginScreenHomeState extends State<LoginScreenHome> {

  //declare var
  bool hidePassword = true ;
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();


  //methods
  void showHidePassword(){
    if(hidePassword == true) {
      setState(() {
        hidePassword = false;
      });

    } else{
      setState(() {
        hidePassword = true;
      });

    }
  }

  void validateInputs() async{
    if(usernameController.text.isEmpty){
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error',
        desc: 'Username is empty',
        btnOkOnPress: (){},
      ).show();

  }else if(passwordController.text.isEmpty){
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error',
        desc: 'Password is empty',
        btnOkOnPress: (){},
      ).show();
  }else {
      //Execute the Login Algorithmns
      final users = await DatabaseHelper().loginUser(usernameController.text, passwordController.text);
      if (users.isEmpty){
        AwesomeDialog(
          context: context,
          title: 'Invalid Username or Password',
          dialogType: DialogType.error,
          desc: 'User not found in the Database',
          btnOkOnPress: (){}
        ).show;
      }else {
          //Navigate to Dashboard
      }
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SKIBIDY 100'),
      ),
      drawer: Drawer(),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Card(
          elevation: 30.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Text('67🫩',
                    style: TextStyle(
                        fontSize: 50.5,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 50, 25, 20)
                    ),)
              ),
              //textfield for username
              SizedBox(
                width: MediaQuery.of(context).size.width/2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.supervised_user_circle),
                      label: Text('Username'),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.teal
                        )
                      )
                    ),
                  )
                ),
              ),
              //textfield for password
              SizedBox(
                width: MediaQuery.of(context).size.width/2,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: IconButton(
                              onPressed: (){
                                showHidePassword();
                              },
                              icon: Icon(Icons.remove_red_eye)),
                          label: Text('Password'),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.teal
                              )
                          )
                      ),
                    )
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width/2,
                height: MediaQuery.of(context).size.height/18,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white70 )
                    ),
                    onPressed: (){},
                    child: Text('Login')),
              ),
              //Row for Signup Navigation
              Row (
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text (' No Account?'),
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>Signupscreen()));
                      },
                      child: Text('Signup')
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}