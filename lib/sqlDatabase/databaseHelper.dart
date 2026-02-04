import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  //Initialize Variable for Database file
  static final _dbName = 'student.db' ;
  //Initialize private database connection link/nullable
  Database? _db ;
  //Create a private method to open the Database file
  Future<Database> _database() async {
    final existing = _db ;

    if(existing != null) return existing;
    //Get the path of the Database file
    final path = await getDatabasesPath(); //emulated/0/
    //Initialized variable to hold the returned value of the Database Configuration
    final db = await openDatabase(
      //Path of the Database
        '$path/$_dbName',
      //Version of the Database
      version: 1,
      //Property that will call the construction of Database TABLE
      onCreate: (db, version) async {
          //Query to Construct student table
          await db.execute("""
          CREATE TABLE IF NOT EXIST students(
          id INTEGER PRIMARY KEY AUTO INCREMENT,
          fullName TEXT,  
          username TEXT,
          password TEXT,
          dateAdded DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
          )
          """);
          // You can add another table construction below
      }
    ) ;

    _db = db;
    return db ;

  }

  //Method to insert data to students table CREATE
  Future<int> insertStudent(String fullName, String username, String password) async{
    //Initialize database Connection Link
    final db = await _database();
    //Prepare pair of data('columnName': sourceFromParameter)
    final data = {'fullName': fullName, 'username': username, 'password': password} ;
    return await db.insert('students', data) ;
  }

  //Method to Read Data from the Table - READ
  Future<List<Map<String, dynamic>>> getAllStudents() async {
    //Initialize database connection link
    final db= await _database();
    //Query to get all data from a student Table
    return await db.query('students') ;
  }

  //Method to upadate
  Future<int> updateStudent(int studentID, String fullName, String username, String password) async{
    //Initialize Database connection link
    final db = await _database();
    //Prepare update data
    final data = {'fullName': fullName, 'username': username, 'password': password};
    return await db.update('students', data, where: 'id = ?',  whereArgs: ['$studentID']);

  }

  //Method to delete student
  Future<int> deleteStudent(int id) async{
    //Initialize database connection link
    final db = await _database();
    return await db.delete('students', where: 'id = ?', whereArgs: ['$id']) ;
    //return await db.rawDelete("DELETE FROM students WHERE id = '$id'");
  }

  //Method to loginUser
  Future<List<Map<String, dynamic>>> loginUser(String username, String password) async{
    final db = await _database();


    return await db.query(
        'students',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password]) ;


  }

}