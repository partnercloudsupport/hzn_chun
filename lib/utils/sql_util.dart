import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = '_Dict';
final String columnId = '_id';
final String columnName = '_name';
final String columnPid = '_pid';

class SqlUtil {
  static SqlUtil instance;
  static BuildContext _context;

  static SqlUtil getInstance(BuildContext context) {
    print('getInstance');
    if (instance == null) {
      _context = context;
      instance = new SqlUtil();
    }
    return instance;
  }

  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableName ( 
  $columnId integer primary key , 
  $columnName text not null,
  $columnPid integer not null)
''');
    });
  }

  void init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'city.db');
    await open(path);


    deleteAll();
    //开始加载数据
    loadCityData();
  }

  SqlUtil() {
    init();
  }

  void loadCityData() async {
    var json = JsonDecoder();
    String jsonData = await DefaultAssetBundle.of(_context).loadString('assets/citys.json');
    Map<String, dynamic> city = json.convert(jsonData);
    var cityList = List<Dict>();
    for (var key in city.keys) {
      var id = key;
      var name = city[key]["name"];
      var pid = "0";

      var dict = Dict(id, name, pid);
      cityList.add(dict);

      var value = city[key]["child"];
      if (value is Map<String, dynamic>) {
        cityList.addAll(analysisData(key, value));
      }


    }

    //加到数据库中
    Observable.fromIterable(cityList)
        .map((Dict dict)=>dict.toMap())
        .listen((Map<String, dynamic> map)=>db.insert(tableName, map));

  }

  List<Dict> analysisData(String pid, Map<String, dynamic> value) {
    var cityList = List<Dict>();
    for (var key in value.keys) {
      var id = key;
      var name = value[key]["name"];
      var _pid = pid;

      var dict = Dict(id, name, _pid);
      cityList.add(dict);

      var child = value[key]["child"];
      if (child is Map<String, dynamic>) {
        for(var childKey in child.keys){
          var dict = Dict(childKey, child[childKey], key);
          cityList.add(dict);
        }
      }
    }

    return cityList;
  }

  Future<int> insert(Dict dict) async {
    return await db.insert(tableName, dict.toMap());
  }


  void insertBatch(List<Map<String, dynamic>> dicts) async {
    var batch = db.batch();
    batch.rawInsert("INSERT INTO $tableName ($columnId,$columnName,$columnPid) VALUES (?,?.?)",dicts);
    await batch.commit();
  }



  Future<List<Map<String, dynamic>>> getChildsByPid(String pid) async {
    return await db.rawQuery('SELECT * FROM $tableName where $columnPid = $pid');;
  }


  Future<Dict> getDictById(int id) async {
    List<Map> maps = await db.query(tableName,
        columns: [columnId, columnName, columnPid],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Dict.fromMap(maps.first);
    }
    return null;
  }





  Future<int> delete(int id) async {
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  ///删除整表
  Future<int> deleteAll() async {
    return await db.delete(tableName);
  }


  Future<int> update(Dict dict) async {
    return await db.update(tableName, dict.toMap(),
        where: '$columnId = ?', whereArgs: [dict.id]);
  }

  Future close() async => db.close();
}

class Dict {
  String id;
  String name;
  String pid;

  Dict(this.id, this.name, this.pid);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{columnId: id, columnName: name, columnPid: pid};

    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Dict.fromMap(Map<String, dynamic> map) {
    id = "${map[columnId]}";
    name = "${map[columnName]}";
    pid = "${map[columnPid]}";
  }
}
