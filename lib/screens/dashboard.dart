import 'package:flutter/material.dart' ;
import 'listofUsers.dart' ;
import 'loginScreen.dart' ;

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
      drawer: Drawer(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: 80.0),
              InkWell(
                child: ListTile(
                    leading: Icon(Icons.list),
                    title: Text('List of names'),
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>Listofusers()));
                },

              ),

            ],
        ),
      ),
      body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width/2,
                      height: MediaQuery.of(context).size.height/4,
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.supervised_user_circle, color: Colors.amber,),
                            Text('1'),
                            Text('Total Users')
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width/2,
                      height: MediaQuery.of(context).size.height/4,
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.verified_user, color: Colors.blue),
                            Text('1'),
                            Text('Total Users')
                          ],
                        ),
                      ),
                    )
                  ],
              ),

            ],
      ),
    );

  }// ror
}
