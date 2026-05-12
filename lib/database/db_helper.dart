import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;
  DbHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'Aotppmt.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE User_Mst (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            U_Name TEXT,
            U_Mobile TEXT,
            U_City TEXT,
            U_Email TEXT,
            U_Reg_Date TEXT,
            U_Month INTEGER,
            U_Exp_Date TEXT,
            Pmt_Flag TEXT
          )
        ''');
        await _insertDefaultUser(db);
      },
    );
  }

  Future<void> _insertDefaultUser(Database db) async {
    String systemDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    await db.insert('User_Mst', {
      'U_Name': 'Test User',
      'U_Mobile': '9409273414',
      'U_City': 'Ahmedabad',
      'U_Email': 'jaymin1965@gmail.com',
      'U_Reg_Date': systemDate,
      'U_Month': 1,
      'U_Exp_Date': '15/07/1995',
      'Pmt_Flag': 'N'
    });
  }
}
