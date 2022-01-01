import 'dart:async';
import 'package:covidapp/models/covidData.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final database = initializeDB();

Future<Database> initializeDB() async {
  WidgetsFlutterBinding.ensureInitialized();
  final data = openDatabase(
    join(await getDatabasesPath(), 'CovidData_database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE covidData(cases INTEGER, date TEXT)',
      );
    },
    version: 1,
  );

  return data;
}

Future<void> insertData(CovidData covidData) async {
  final db = await database;

  await db.insert(
    'covidData',
    covidData.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<CovidData>> dataDisplay() async {
  final db = await database;

  final List<Map<String, dynamic>> maps = await db.query('covidData');

  return List.generate(maps.length, (i) {
    return CovidData(
      cases: maps[i]['cases'],
      date: maps[i]['date'],
    );
  });
}

Future<void> updatedata(CovidData covidData) async {
  final db = await database;

  await db.update(
    'covidData',
    covidData.toMap(),
    where: 'cases = ?',
    whereArgs: [covidData.cases],
  );
}
