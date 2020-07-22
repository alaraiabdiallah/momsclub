import 'package:momsclub/models/favorite_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

String _favTable = "favorites";

Future<Database> dbInstance() async{
  return openDatabase(
    join(await getDatabasesPath(), 'momsclub.db'),
    onCreate: (db, version) {
        return db.execute("CREATE TABLE ${_favTable}(id TEXT PRIMARY KEY)");
    },
    version: 1,
  );
}

Future<void> deleteFavorite(String id) async {
  final db = await dbInstance();
  await db.delete(_favTable, where: "id = ?", whereArgs: [id]);
}

Future<bool> isFavorite(String id) async {
  final db = await dbInstance();
  List<Map> maps = await db.query(_favTable, where: 'id = ?', whereArgs: [id]);
  return maps.length > 0;
}

Future<void> insertFavorite(FavoriteModel fav) async {
  final db = await dbInstance();

  await db.insert(
    _favTable,
    fav.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<String>> getAllFavs() async{
  final db = await dbInstance();
  List<Map> maps = await db.query(_favTable);

  return maps.map((e) => e['id'] as String).toList();
}
