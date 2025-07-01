import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

enum ClothingType { shorttop,longtop, shortbottom, longbottom, shoes, jacket }

class DatabaseHelper {
  static const _dbName = 'app.db';
  static const _dbVersion = 1;
  static const _galleryTable = 'gallery_image';
  static const _outfitsTable = 'selected_outfits';

  Database? _database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final Directory docsDir = await getApplicationDocumentsDirectory();
    final path = join(docsDir.path, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 갤러리 이미지 테이블 생성
    await db.execute('''
      CREATE TABLE $_galleryTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        local_path TEXT NOT NULL,
        original_id TEXT,
        type INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    // 선택된 옷 테이블 생성
    await db.execute('''
      CREATE TABLE $_outfitsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        postid INTEGER NULL,
        top_path TEXT NOT NULL,
        bottom_path TEXT NOT NULL,
        jacket_path TEXT,
        shoes_path TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
  }
  Future<int> insertImage(
    String localPath,
    ClothingType type, {
    String? originalId,
  }) async {
    final db = await database;
    return await db.insert(
      _galleryTable,
      {
        'local_path': localPath,
        'original_id': originalId,
        'type': type.index,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<String>> getAllImagePaths(ClothingType type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _galleryTable,
      where: 'type = ?',
      whereArgs: [type.index],
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) => maps[i]['local_path'] as String);
  }

  Future<int> deleteImageByPath(String path) async {
    final db = await database;
    return await db.delete(
      _galleryTable,
      where: 'local_path = ?',
      whereArgs: [path],
    );
  }

  Future<Map<String, dynamic>?> getImageByPath(String path) async {
    final db = await database;
    final list = await db.query(
      _galleryTable,
      where: 'local_path = ?',
      whereArgs: [path],
      limit: 1,
    );
    return list.isNotEmpty ? list.first : null;
  }


  Future<int> insertOutfit({
    required String topPath,
    required String bottomPath,
    required String shoesPath,
    String? jacketPath,
    String status = 'Save',
  }) async {
    final db = await database;
    return await db.insert(
      _outfitsTable,
      {
        'top_path': topPath,
        'bottom_path': bottomPath,
        'jacket_path': jacketPath,
        'shoes_path': shoesPath,
        'status': status,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<int> insertLikedtOutfit({
    required String topPath,
    required String bottomPath,
    required String shoesPath,
    String? jacketPath,
    required int postid,
    String status = 'Like',
  }) async {
    final db = await database;
    return await db.insert(
      _outfitsTable,
      {
        'postid' : postid,
        'top_path': topPath,
        'bottom_path': bottomPath,
        'jacket_path': jacketPath,
        'shoes_path': shoesPath,
        'status': status,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<Map<String, dynamic>>> getOutfits({String? status}) async {
    final db = await database;
    return await db.query(
      _outfitsTable,
      where: status != null ? 'status = ?' : null,
      whereArgs: status != null ? [status] : null,
      orderBy: 'created_at DESC',
    );
  }
 Future<int> deleteOutfitById(int id) async {
    final db = await database;
    return await db.delete(
      _outfitsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
    _database = null;
  }
}