import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:simple_notes/model.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'Note.db');
    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  _createDatabase(Database db, int version) async {
    await db.execute(
      """
      CREATE TABLE mynote(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            desc TEXT NOT NULL,
            dateandtime TEXT NOT NULL
            )
      """,
    );
  }

  Future<NoteModel> insert(NoteModel model) async {
    var dbClient = await db;
    await dbClient?.insert('mynote', model.toMap());
    return model;
  }

  Future<List<NoteModel>> getDataList() async {
    await db;

    final List<Map<String, Object?>> result =
        await _db!.rawQuery('SELECT * FROM mynote');
    return result.map((e) => NoteModel.fromMap(e)).toList();
  }

  Future<int> delete(int idDel) async {
    var dbClient = await db;
    return await dbClient!
        .delete('mynote', where: 'id = ?', whereArgs: [idDel]);
  }

  Future<int> update(NoteModel model) async {
    var dbClient = await db;
    return await dbClient!.update('mynote', model.toMap(),
        where: 'id = ?', whereArgs: [model.id]);
  }
}
