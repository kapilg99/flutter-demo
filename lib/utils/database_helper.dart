import 'dart:io';

import 'package:flutter_crud/models/member.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "MemberDB.db";
  static const _databaseVersion = 1;

//  singleton constructor
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    return openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  _onCreateDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE ${Member.table}(
    ${Member.colId} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    ${Member.colPhone_no} INTEGER NOT NULL,
    ${Member.colName} TEXT NOT NULL,
    ${Member.colCity} TEXT NOT NULL,
    ${Member.colPin_no} INTEGER NOT NULL
    )
    ''');
  }

  Future<int> insertMember(Member member) async {
    Database db = await database;
    return await db.insert(Member.table, member.toMap());
  }

  Future<List<Member>> fetchMembers() async {
    Database db = await database;
    List<Map> members = await db.query(Member.table);
    return members.length == 0
        ? []
        : members.map((e) => Member.fromMap(e)).toList();
  }

  Future<int> updateMember(Member member) async {
    Database db = await database;
    return await db.update(Member.table, member.toMap(),
        where: '${Member.colId}=?', whereArgs: [member.id]);
  }

  Future<int> deleteMember(int id) async {
    Database db = await database;
    return await db
        .delete(Member.table, where: '${Member.colId}=?', whereArgs: [id]);
  }
}
