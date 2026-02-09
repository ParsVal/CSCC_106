import 'package:flutter/material.dart' ;
import 'package:otero_mandy_new/screens/loginScreen.dart';

class Dashboard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DashboardHome()
    );

  }

}

class DashboardHome extends StatefulWidget{
  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context)=>LoginScreen()
                  )
                );
              },
              icon: Icon(Icons.logout))
        ],
      ),
      drawer: Drawer(),
      body: Column(

      ),
    );

  }// ror
}
