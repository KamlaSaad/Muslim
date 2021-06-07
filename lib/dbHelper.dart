import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper.internal();

  factory DbHelper() => _instance;

  DbHelper.internal();
}

Future<Database> createDatabase() async {
  return await openDatabase(
    join(await getDatabasesPath(), 'moslim.db'),
    onCreate: (db, version) async {
      //create tables
      await db.execute(
          'CREATE TABLE MORNING(ID INTEGER PRIMARY KEY AUTOINCREMENT, ITEM TEXT, COUNT TEXT,AUDIO TEXT)');
      await db.execute(
          'CREATE TABLE EVENING(ID INTEGER PRIMARY KEY AUTOINCREMENT, ITEM TEXT, COUNT TEXT,AUDIO TEXT)');
      await db.execute(
          'CREATE TABLE WAKING(ID INTEGER PRIMARY KEY AUTOINCREMENT, ITEM TEXT, COUNT TEXT,AUDIO TEXT)');
      await db.execute(
          'CREATE TABLE SLEEPING(ID INTEGER PRIMARY KEY AUTOINCREMENT, ITEM TEXT, COUNT TEXT,AUDIO TEXT)');
      await db.execute(
          'CREATE TABLE PRAYERS(ID INTEGER PRIMARY KEY AUTOINCREMENT, ITEM TEXT)');
      await db.execute(
          'CREATE TABLE USER(ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME VARCHAR(50), EMAIL VARCHAR(50),PASSWORD VARCHAR(50))');
    },
    version: 1,
  );
}

Future<int> insert(
    String table, String item, String count, String audio) async {
  Database db = await createDatabase();
  return db.rawInsert(
      "INSERT INTO $table(ITEM,COUNT,AUDIO) VALUES('$item','$count','$audio')");
}

Future<int> addPrayers(String item) async {
  Database db = await createDatabase();
  return db.rawInsert("INSERT INTO PRAYERS(ITEM) VALUES('$item')");
}

Future<List> retreiveItems(String table) async {
  Database db = await createDatabase();
  return db.query(table);
}

Future<List> getId(String pass) async {
  Database db = await createDatabase();
  return db.rawQuery("SELECT ID FROM USER WHERE PASSWORD='$pass'");
}

Future<int> getCount(String table) async {
  Database db = await createDatabase();
  var x = await db.rawQuery('SELECT COUNT (*) from $table');
  int count = Sqflite.firstIntValue(x);
  return count;
}

Future<int> addUser(String name, String email, String pass) async {
  Database db = await createDatabase();
  return db.rawInsert(
      "INSERT INTO USER(NAME,EMAIL,PASSWORD)VALUES('$name','$email','$pass')");
}

Future<List> login(String name, String pass) async {
  Database db = await createDatabase();
  return db
      .rawQuery("select * from USER where name='$name' and password='$pass'");
}

Future<int> deleteUser(int id) async {
  Database db = await createDatabase();
  return db.delete('USER', where: 'ID = ?', whereArgs: [id]);
}

Future<int> delete(int id) async {
  Database db = await createDatabase();
  return db.delete('EVENING', where: 'ID = ?', whereArgs: [id]);
}

Future<int> updateUser(String pass, int id) async {
  Database db = await createDatabase();
  return await db.rawUpdate("UPDATE USER SET PASSWORD='$pass' WHERE ID='$id'");
}
