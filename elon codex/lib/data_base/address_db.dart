import 'package:farms_gate_marketplace/model/address_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AddressDatabaseHelper {
  static const String _dbName = 'users_address.db';
  static const int _dbVersion = 1;
  static const String _tableName = 'users_address';

  // Column names
  static const String columnId = 'id';
  static const String columnFirstName = 'firstName';
  static const String columnLastName = 'lastName';
  static const String columnPhoneNumber = 'phoneNumber';
  static const String columnAddress = 'deliveryAddress';
  static const String columnEmail = 'additionalPhoneNumber';
  static const String columnState = 'region';
  static const String columnCity = 'city';
  static const String columnIsDefault = 'defaultAddress'; 

  // Singleton instance
  static final AddressDatabaseHelper _instance =
      AddressDatabaseHelper._internal();
  factory AddressDatabaseHelper() => _instance;
  AddressDatabaseHelper._internal();

  static Database? _database;

  // Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  // Create table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnFirstName TEXT NOT NULL,
        $columnLastName TEXT NOT NULL,
        $columnPhoneNumber TEXT NOT NULL,
        $columnAddress TEXT NOT NULL,
        $columnEmail TEXT NOT NULL,
        $columnState TEXT NOT NULL,
        $columnCity TEXT NOT NULL,
        $columnIsDefault  INTEGER DEFAULT 0 CHECK (defaultAddress IN (0, 1))
      )
    ''');

    // Create trigger for default address logic
    db.execute('''
        CREATE TRIGGER set_unique_default
        BEFORE UPDATE OF defaultAddress ON $_tableName
        FOR EACH ROW
        WHEN NEW.defaultAddress = 1
        BEGIN
          UPDATE $_tableName SET defaultAddress = 0 WHERE id != NEW.id;
        END;
      ''');

    db.execute('''
        CREATE TRIGGER set_unique_default_on_insert
        BEFORE INSERT ON $_tableName
        FOR EACH ROW
        WHEN NEW.defaultAddress = 1
        BEGIN
          UPDATE $_tableName SET defaultAddress = 0;
        END;
      ''');
  }

  // Insert a new user record
  Future<int> insertAddress(AddressModel address) async {
    Database db = await database;

    return await db.insert(
      _tableName,
      address.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }


Future<void> updateAddressDefault(int id) async {
    Database db = await database;

    await db.update(
      _tableName,
      {columnIsDefault: 1},
      where: '$columnId = ?',
      whereArgs: [id],
    );

    await db.update(
      _tableName,
      {columnIsDefault: 0},
      where: '$columnId != ?',
      whereArgs: [id],
    );
  }


  // Retrieve all user records
  Future<List<AddressModel>> getAllAddress() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return maps.map((map) => AddressModel.fromMap(map)).toList();
  }

  // Update a user record
  Future<int> updateAddress(AddressModel address) async {
    Database db = await database;
    return await db.update(
      _tableName,
      address.toMap(),
      where: 'id = ?', 
      whereArgs: [address.id],
    );
  }

  // Delete a user record
  Future<int> deleteAddress(int id) async {
    Database db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
