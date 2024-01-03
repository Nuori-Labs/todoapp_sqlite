import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper dbHelper = DBHelper._secretDBConstructor();
  static Database? _database;
  final String _dbName = 'todoapp_database.db';
  final String _tableName = 'todos';


  // _secretDBConstructor is a private named constructor within the 
  // DBHelper class. Its main purpose is to ensure that only one 
  // instance of the DBHelper class is created
  DBHelper._secretDBConstructor();

  // Get access to the SQLite database
  Future<Database> get dataBase async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;  
  }

  // Initialize SQLite database
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase, // callback when the db is created for first time
    );
  }

  void _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT
      )
    ''');
  }

  // Insert data into `todos` table
  Future<int> insertTodo(Map<String, dynamic> row) async {
    Database db = await dbHelper.dataBase;
    return db.insert(_tableName, row);
  }

  // Read data from `todos` table
  Future<List<Map<String, dynamic>>> readTodos() async {
    Database db = await dbHelper.dataBase;
    return db.query(_tableName);
  }

  // Update data in `todos` table
  Future<int> updateTodo(Map<String, dynamic> row) async {
    Database db = await dbHelper.dataBase;
    int id = row['id'];

    // "UPDATE TABLE <table_name> WHERE id = <provided_id>"
    return await db.update(_tableName, row, where: 'id = ?', whereArgs: [id]);
  }

  // Delete data from 'todos` table
  Future<int> deleteTodo(int id) async {
    Database db = await dbHelper.dataBase;

    // "DELETE FROM <table_name> WHERE id = <provided_id>"
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}