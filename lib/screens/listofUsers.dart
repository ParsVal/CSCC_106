import 'package:flutter/material.dart' ;
import 'package:otero_mandy_new/screens/dashboard.dart';
import 'package:otero_mandy_new/sqlDatabase/databaseHelper.dart';

class Listofusers extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListofusersHome(),
    );

  }
}

class ListofusersHome extends StatefulWidget{
  @override
  State<ListofusersHome> createState() => _ListofusersHomeState();
}

class _ListofusersHomeState extends State<ListofusersHome> {

  var students = [] ;

  void getAllStudents() async{
    final data = await DatabaseHelper().getAllStudents();
    setState(() {
      students = data ;
    });

    print(students.toString()) ;
  }

  void initState() {
    super.initState() ;
    getAllStudents() ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Users'),
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>Dashboard()));
            },
            icon: Icon(Icons.arrow_back)
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListView.builder(itemBuilder: (BuildContext context, index){
            var fullName = students[index]["fullName"];
            var username = students[index]["username"];
            var password = students[index]["password"];
            return ListTile(
              leading: Icon(Icons.supervised_user_circle),
              title: Text("$fullName"),
              subtitle: Text("$username"),

            );
          },
            itemCount: students.length,
            shrinkWrap: true,
          )

        ],
      ),
    );
  }
}