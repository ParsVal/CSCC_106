import 'package:flutter/material.dart';
import 'package:otero_mandy_new/screens/loginScreen.dart';
import 'package:awesome_dialog/awesome_dialog.dart' ;
import 'package:otero_mandy_new/sqlDatabase/databaseHelper.dart';

class Signupscreen extends StatefulWidget {
  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignupScreenHome(),
    );
  }
}

class SignupScreenHome extends StatefulWidget {
  @override
  State<SignupScreenHome> createState() => _SignupScreenHomeState();
}

class _SignupScreenHomeState extends State<SignupScreenHome> {
  //variables
  var showpass1 = true;
  var showpass2 = true;

  // var for controller
  var fullNameController = TextEditingController() ;
  var userNameController = TextEditingController() ;
  var passwordController = TextEditingController() ;
  var confirmPassController =  TextEditingController() ;

  //method
  void showPassword1() {
    if (showpass1 == true) {
      setState(() {
        showpass1 = false;
      });
    } else {
      setState(() {
        showpass1 = true;
      });
    }
  }

  void showPassword2() {
    if (showpass2 == true) {
      setState(() {
        showpass2 = false;
      });
    } else {
      setState(() {
        showpass2 = true;
      });
    }
  }

  void displayInputs() {
    var fullName = fullNameController.text;
    var userName = userNameController.text;
    var pass = passwordController.text;
    var confirmPass = confirmPassController.text;

    print("The full name is $fullName") ;
    print("The username si $userName") ;
    print("The password is $pass") ;
    print("The confirmed password is $confirmPass") ;
  }

  void inputValidation() async{
    if (fullNameController.text.isEmpty) {
      AwesomeDialog(
        width: 300.0,
        context: context,
        title: 'Error',
        desc: 'Full name is required',
        dialogType: DialogType.error,
        btnOkOnPress: (){}
      ).show();
    }else if (userNameController.text.isEmpty){
      AwesomeDialog(
          width: 300.0,
          context: context,
          title: 'Error',
          desc: 'Username is required',
          dialogType: DialogType.error,
          btnOkOnPress: (){}
      ).show();
    }else if (passwordController.text.isEmpty) {
      AwesomeDialog(
          width: 300.0,
          context: context,
          title: 'Error',
          desc: 'Password is required',
          dialogType: DialogType.error,
          btnOkOnPress: (){}
      ).show();
    }else if (confirmPassController.text != passwordController.text) {
      AwesomeDialog(
          width: 300.0,
          context: context,
          title: 'Error',
          desc: 'Confirmed password does not match!',
          dialogType: DialogType.error,
          btnOkOnPress: (){}
      ).show();
    }else {
      final result = await DatabaseHelper().insertStudent(fullNameController.text, userNameController.text, passwordController.text);
      if (result > 0) {
        AwesomeDialog(
            width: 300.0,
            context: context,
            title: 'Success',
            desc: 'User successfully registered!',
            dialogType: DialogType.success,
            btnOkOnPress: (){}
        ).show();
      } else {
        AwesomeDialog(
            width: 300.0,
            context: context,
            title: 'Error',
            desc: 'There is an error on adding user',
            dialogType: DialogType.error,
            btnOkOnPress: (){}
        ).show();
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('SKIBIDY 100')),
      drawer: Drawer(),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Card(
          elevation: 30.0,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'REGISTER',
                    style: TextStyle(
                      fontSize: 50.5,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 50, 25, 20),
                    ),
                  ),
                ),
                //textfield for fullname
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.supervised_user_circle),
                        label: Text('fullname'),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                      ),
                    ),
                  ),
                ),
            
                //textfield for username
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.supervised_user_circle),
                        label: Text('username'),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                      ),
                    ),
                  ),
                ),
            
                //textfield for password
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: showpass1,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: IconButton(
                          onPressed: () {
                            showPassword1();
                          },
                          icon: Icon(Icons.remove_red_eye),
                        ),
                        label: Text('Enter Password'),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                      ),
                    ),
                  ),
                ),
            
                //comfirm pass
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: confirmPassController,
                      obscureText: showpass2,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: IconButton(
                          onPressed: () {
                            showPassword2();
                          },
                          icon: Icon(Icons.remove_red_eye),
                        ),
                        label: Text('Confirm Password'),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                      ),
                    ),
                  ),
                ),
            
                //Signup button
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 18,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white70),
                    ),
                    onPressed: () {
                      displayInputs() ;
                      inputValidation();
                    },
                    child: Text('Signup'),
                  ),
                ),
                //Row for Signup Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Got an Account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
