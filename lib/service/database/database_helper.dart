import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/model/model.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;
  static final _databaseName = "SyloDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'my_draft';
  static final notifytable = 'notification';
  static final mediaTable = 'my_draft_media';

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnTag = 'tag';
  static final columnMediaType = 'media_type';
  static final columnDraftId = 'draft_id';
  static final columnCreateTime = 'create_time';
  static final columnCoverPhoto = 'cover_photo';
  static final columnDescription = 'description';
  static final columnDirectURL = 'directURL';
  static final columnQcastId = 'qcastId';
  static final columnQcastDuration = 'qcastDuration';
  static final columnQcastQuestionList = 'qcast_question_list';
  static final columnQcastCoverPhoto = 'qcast_cover_photo';
  static final columnPostType = 'post_type';
  static final columnOnlyMessage = 'onlyMessage';


  //media
  static final columnImage = 'image';
  static final columnLink = 'link';
  static final columnIsCircle = 'is_circle';

  //notification
  static final columnnotifyId = 'notifyId';
  static final columnnotifyTitle = 'title';
  static final columnnotifydescription = 'description';


  //  DatabaseHelper._privateConstructor();
//  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT,
            $columnTag TEXT,
            $columnMediaType TEXT NOT NULL,
            $columnCreateTime TEXT NOT NULL,
            $columnCoverPhoto TEXT,
            $columnDescription TEXT,
            $columnDirectURL TEXT,
            $columnQcastId INTEGER,
            $columnQcastDuration TEXT,
            $columnQcastCoverPhoto TEXT,
            $columnQcastQuestionList TEXT,
            $columnPostType TEXT,
            $columnOnlyMessage TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE $mediaTable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnDraftId INTEGER,
            $columnImage TEXT,
            $columnLink TEXT,
            $columnIsCircle TEXT
          )
          ''');


    await db.execute('''
          CREATE TABLE $notifytable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnnotifyId INTEGER UNIQUE,
            $columnnotifyTitle TEXT,
            $columnnotifydescription TEXT
          )
          ''');
  }

  Future<int> insert(MyDraft myDraft) async {
    Database db = await this.database;

    return await db.insert(table, myDraft.toMap());
  }

  Future<int> insertNotification(NotificationListDatabase notificationList) async {
    Database db = await this.database;

    return await db.insert(notifytable, notificationList.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> insertMedia(MyDraftMedia myDraftMedia) async {
    Database db = await this.database;

    return await db.insert(mediaTable, myDraftMedia.toMap());
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<MyDraft>> getAllDraft() async {
    Database db = await this.database;
    List<Map<String, dynamic>> list = await db.query(table);
    List<MyDraft> myDraftList = list.map((model) => MyDraft.fromMapObject(model)).toList();

    return myDraftList;
  }

  Future<List<NotificationListDatabase>>  getAllNotification() async {
    Database db = await this.database;
    List<Map<String, dynamic>> list = await db.query(notifytable);
    List<NotificationListDatabase> noficationList = list.map((model) => NotificationListDatabase.fromMapObject(model)).toList();

    return noficationList;
  }

  Future<List<MyDraftMedia>> getAllMediaForDraftItem(int mediaId) async {
    Database db = await this.database;
    List<Map<String, dynamic>> list = await db.query(
        mediaTable,
        columns: ['*'],
        where: '$columnDraftId = ?',
        whereArgs: [mediaId]);
    List<MyDraftMedia> myDraftMedia = list.map((model) => MyDraftMedia.fromMapObject(model)).toList();

    return myDraftMedia;
  }

  Future<int> deleteDraftWithMedia(int id, String mediaType) async {
    Database db = await this.database;
    print("TYPE:$mediaType");
    switch(mediaType){
      case "PHOTO":
      case "VIDEO":
      case "QCAST":
      case "VTAG":
        int deleteId = await db.delete(mediaTable, where: '$columnDraftId = ?', whereArgs: [id]);
        print(deleteId);
        break;
    }

    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteNotification(int id) async {
    Database db = await this.database;
    return await db.delete(notifytable, where: '$columnnotifyId = ?', whereArgs: [id]);
  }

  Future<int> deleteNotificationTable() async {
    Database db = await this.database;
    return await db.delete(notifytable);
  }
}