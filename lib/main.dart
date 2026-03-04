import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart' ;
import 'screens/loginScreen.dart' ;
import 'classActivity.dart' ;
import 'backends/ComplexDataTypes.dart' ;

int addition(num1, num2) {
  return (num1 + num2);
}

int subtraction(num1, num2) {
  return (num1 - num2) ;
}

int multiplication(num1, num2) {
  return (num1 * num2) ;
}

double division(num1, num2) {
  return (num1 / num2) ;
}



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //print full name
  runApp(LoginScreen()) ;
  print("Mandy Otero") ;

  //for loop

  int even = 0;
  int odd = 0;

  for (int i = 0; i < 100; i++) {
    if (i % 2 == 0) {
      even += i ;
    } else {
      odd += i ;
    }
  }

  print("Sum of even number is $even");
  print("Sum of odd numbers is $odd");

  //for loop decrement counter 100 to 1

  for (int i = 100; i > 0; i--) {
    print (i);
  }

  //print the age by getting the difference between currentYear and birthYear

  int currentYear = 2025 ;
  int birthYear = 2003 ;

  print("My current age is ${currentYear - birthYear}") ;

  //create an arithmetic calculator using four func
  int tiger = 2;
  int cat = 20;

  int add = addition(cat, tiger);
  int sub = subtraction(cat, tiger);
  int mult = multiplication(cat, tiger);
  double div = division(cat, tiger);

  print("Value of addition is $add, for subtraction is $sub, for multiplication is $mult, and for division is $div") ;

  ClassLesson().displayName();
  Complexdatatypes().displayGrade();
  int ybirth = ClassLesson().displayAge(currentYear, birthYear) ;
  print("Age of bro is $ybirth") ;
  var user = Complexdatatypes().userAccounts ;
  for(int i = 0; i < user.length ; i++) {
    var id = user[i]['id'] ;
    var name = user[i]['username'] ;
    var pass = user[i]['password'] ;

    print("ID: $id, Name: $name, Password: $pass");
  }

}