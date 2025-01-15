import 'dart:async';
import 'dart:convert';
import 'package:farms_gate_marketplace/model/product_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CartDatabaseHelper {
  static Database? _database;
  static const String tableName = 'cart_table_item';

  // Define the columns of the table 
  static const columnId = '_id';
  static const columnProductId = 'productId';
  static const columnCategory = 'category';
  static const columnCreatedAt = 'created_at';
  static const columnDescription = 'description';
  static const columnFarmerId = 'farmerId';
  static const columnFarmerName = 'farmName';
  static const columnImages = 'images';
  static const columnInStock = 'inStock';
  static const columnIsMarketable = 'isMarketable';
  static const columnLocation = 'location';
  static const columnMarketPrice = 'marketPrice';
  static const columnName = 'name';
  static const columnUpdatedAt = 'updated_at';
  static const columnQuantity = 'quantity';

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
    $columnFarmerName TEXT,
    $columnImages TEXT,
    $columnInStock INTEGER,
    $columnIsMarketable INTEGER,
    $columnLocation TEXT,
    $columnMarketPrice REAL,
    $columnName TEXT,
    $columnUpdatedAt TEXT,
    $columnQuantity INTEGER
  )
        ''');
      },
    );
  }

  Future<int> insertCartInfo(ProductModel product, String qty) async {
    Database db = await database;
    // return await db.insert(tableName, {...product.toJson(), 'quantity': qty});
    //  Database db = await database;
    // return await db.insert(tableName, {
    //   ...product.toJson(),
    //   'quantity': int.parse(qty),
    // });
    final existingProduct = await db.query(
      tableName,
      where: 'productId = ?',
      whereArgs: [product.productId],
    );

    if (existingProduct.isNotEmpty) {
      // If the product exists, update the quantity
      return await db.update(
        tableName,
        {'quantity': qty},
        where: 'productId = ?',
        whereArgs: [product.productId],
      );
    } else {
      final data = {
        '_id': product.id,
        'productId': product.productId,
        'category': product.category,
        'created_at': product.createdAt,
        'description': product.description,
        'farmerId': product.farmerId,
        'farmName': product.farmName,
        'images': jsonEncode(product.images),
        'inStock': product.inStock,
        'isMarketable': product.isMarketable,
        'location': product.location,
        'marketPrice': product.marketPrice,
        'name': product.name,
        'updated_at': product.updatedAt,  
      };

      return await db.insert(
        tableName,
        {
          ...data,
          'quantity': qty,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
    }
    
  }

  Future<bool> productExistsInCart(String productId) async {
    final db = await database;
    var result =
        await db.query(tableName, where: 'productId = ?', whereArgs: [productId]);
    return result.isNotEmpty;
  }

  Future<void> deleteProductFromCart(String productId) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  Future<void> deleteAllProductFromCart() async {
    // final db = await database;
    await _database!.delete(tableName);
  }

  Future<void> updateCartQuantity(String productId, int newQuantity) async {
    final db = await database;
    await db.update(
      tableName,
      {'quantity': newQuantity},
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

 
  Future<List<Map<ProductModel, int>>> getCartInfos() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableName);

    return maps.map((map) {
      final product = ProductModel.fromJson(map);
      final quantity = (map['quantity'] as int?) ?? 1; 
    
      return {product: quantity};
    }).toList();
  }

}
