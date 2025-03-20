import 'package:finance_app/models/finance_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('finance.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      onCreate: _createDB,
      version: 2,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE finance ADD COLUMN due_date TEXT");
      await db.execute("ALTER TABLE finance ADD COLUMN status TEXT NOT NULL DEFAULT 'Paid'");
    }
  }


  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE finance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        due_date TEXT,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'Paid' -- 'Paid' or 'Due'
      )
    ''');
  }

  Future<int> addTransaction(Finance finance) async {
    final db = await instance.database;
    return await db.insert('finance', finance.toJson());
  }

  Future<List<Finance>> getAllTransactions() async {
    final db = await instance.database;
    final result = await db.query('finance');
    return result.map((json) => Finance.fromJson(json)).toList();
  }

  Future<int> updateFinance(Finance finance, int id) async {
    final db = await instance.database;
    return await db.update(
      'finance',
      finance.toJson(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteFinance(int id) async {
    final db = await instance.database;
    return await db.delete(
      'finance', // Fixed table name
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
