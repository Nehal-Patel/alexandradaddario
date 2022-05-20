import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallpaperset/model/model_favorite.dart';
import '../model/model_wallpaper.dart';

class SqliteService {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE Wallpaper(id TEXT NOT NULL,image TEXT NOT NULL,thumbnail Text NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<bool> isFavorite(String id) async {
    final Database db = await initializeDB();
    List<Map<String, Object?>> result = await db.rawQuery("select * from Wallpaper where id=$id");
    if(result.isEmpty){
      return false;
    }else{
      return true;
    }
  }

  Future<int> addToFavorite(ModelWallpaper modelWallpaper) async {
    final Database db = await initializeDB();
    Map<String, dynamic> row = {
      'id' : modelWallpaper.id.toString(),
      'image' : modelWallpaper.image,
      'thumbnail' : modelWallpaper.thumbnail,
    };
    int id = await db.insert("Wallpaper", row);
    return id;
  }

  Future<int> removeFromFavorite(String id) async {
    final Database db = await initializeDB();
    int result=0;
    try {
      result = await db.delete("Wallpaper", where: "id = ?", whereArgs: [id]);
      print(result);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
    return result;
  }

  getAllFavorite() async {
    final Database db = await initializeDB();
    List<Map<String, Object?>> result = await db.rawQuery("select * from Wallpaper");
    return List.generate(result.length, (i) {
      return ModelFavorite(result[i]['id'].toString(),result[i]['image'].toString(),result[i]['thumbnail'].toString());
    });
  }
}
