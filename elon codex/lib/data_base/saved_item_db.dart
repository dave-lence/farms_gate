import 'dart:async';
import 'dart:convert';
import 'package:farms_gate_marketplace/model/product_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SavedItemDatabaseHelper {
  static Database? _database;
  static const String tableName = 'saved_item_tables';

  // Define the columns of the table
  static const columnId = '_id';
  static const columnProductId = 'productId';
  static const columnCategory = 'category';
  static const columnCreatedAt = 'created_at';
  static const columnDescription = 'description';
  static const columnFarmerId = 'farmerId';
  static const columnImages = 'images';
  static const columnInStock = 'inStock';
  static const columnIsMarketable = 'isMarketable';
  static const columnLocation = 'location';
  static const columnMarketPrice = 'marketPrice';
  static const columnName = 'name';
  static const columnUpdatedAt = 'updated_at';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), '$tableName.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            $columnId TEXT PRIMARY KEY,
            $columnProductId TEXT,
            $columnCategory TEXT,
            $columnCreatedAt TEXT,
            $columnDescription TEXT,
            $columnFarmerId TEXT,
            $columnImages TEXT,
            $columnInStock INTEGER,
            $columnIsMarketable INTEGER,
            $columnLocation TEXT,
            $columnMarketPrice REAL,
            $columnName TEXT,
            $columnUpdatedAt TEXT
          )
        ''');
      },
    );
  }

  // Insert a saved item (only add, no update)
  Future<int> insertSavedItem(ProductModel product) async {
    Database db = await database;

    // Insert a new saved item
    return await db.insert(
      tableName,
      {
        '_id': product.id,
        'productId': product.productId,
        'category': product.category,
        'created_at': product.createdAt,
        'description': product.description,
        'farmerId': product.farmerId,
        'images': jsonEncode(product.images),
        'inStock': product.inStock,
        'isMarketable': product.isMarketable,
        'location': product.location,
        'marketPrice': product.marketPrice,
        'name': product.name,
        'updated_at': product.updatedAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Check if a product exists in saved items
  Future<bool> productExistsInSavedItems(String productId) async {
    final db = await database;
    var result =
        await db.query(tableName, where: '_id = ?', whereArgs: [productId]);
    return result.isNotEmpty;
  }

  // Delete a saved item
  Future<void> deleteSavedItem(String productId) async {
    final db = await database;
    await db.delete(
      tableName,
      where: '_id = ?',
      whereArgs: [productId],
    );
  }

  // Delete all saved items
  Future<void> deleteAllSavedItems() async {
    final db = await database;
    await db.delete(tableName);
  }

  // Fetch all saved items
  Future<List<ProductModel>> getSavedItems() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (index) {
      return ProductModel.fromJson(maps[index]);
    });
  }
}
