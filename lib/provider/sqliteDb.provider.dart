import 'dart:async';
import 'dart:io';

import 'package:article_mobile_app/model/article.model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../model/category.model.dart';
class SQLiteDbProvider{
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }
  initDB() async {
    Directory documentsDirectory = await
    getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "articles.db");
    return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate
    );
  }


  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute(
        '''
      CREATE TABLE categories (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL)
      '''
    );

    await db.execute(
        '''
       CREATE TABLE articles (
       id INTEGER PRIMARY KEY,
       name TEXT NOT NULL,
       category INTEGER ,
       description TEXT,
       price DOUBLE,
       quantity INTEGER,
       storage TEXT,
       photo TEXT)
      '''
    );
  }

  /******** SUPPRESSION DES DONNÉES ****/
  Future<int> delete(int id ,String table ) async{
    Database bd = await database;
    await bd.delete('articles', where: 'category = ?', whereArgs: [id]);//on supprime aussi les articles lorsqu'on supprime la catégorie
    return await bd.delete(table, where : 'id = ?',whereArgs: [id] );
  }

  /*********** MODIFIER OU SUPPRIMER *********/
  Future<Category> upsertCategory(Category category)async {
    Database bd = await database;
    if (category.id == null ){
      category.id = await bd.insert('categories', category.toMap());
    }else {
      await bd.update('categories', category.toMap(),where: 'id = ?', whereArgs: [category.id]);
    }
    return category;
  }

  Future<Article> upsertArticle(Article article) async {
    Database bd = await database;
    if(article.id == null){
      article.id = await bd.insert('articles', article.toMap());
    }else{
      await bd.update('articles', article.toMap(),where: 'id = ?',whereArgs: [article.id]);
    }
    return article;
  }

  /****  RÉCUPÉRATION DES DONNÉES ****/
  Future<List<Category>> getAllCategories() async {
    Database bd = await database;
    List<Map<String,dynamic>> result = await bd.rawQuery('SELECT * FROM categories' ,);
    List<Category> categories = [];
    result.forEach((map) {
      Category category = Category.fromMap(map);
      categories.add(category);
    });
    return categories;
  }
  
  Future<List<Article>> getAllArticles(int category) async {
    Database bd = await database;
    List<Map<String,dynamic>> result = await bd.query('articles', where: 'category = ?', whereArgs: [category]);
    List<Article> articles = [];
    result.forEach(
            (map) {
              Article article = Article.fromMap(map);
              articles.add(article);
            }
    );
    return articles;
  }

}