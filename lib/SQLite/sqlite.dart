import 'package:flutter_nolatech2/JsonModels/book_model.dart';
import 'package:flutter_nolatech2/JsonModels/cancha_model.dart';
import 'package:flutter_nolatech2/JsonModels/node_model.dart';
import 'package:flutter_nolatech2/JsonModels/users.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = "note9.db";
  String noteTable =
      "CREATE TABLE notes (noteId INTEGER PRIMARY KEY AUTOINCREMENT, noteTitle TEXT NOT NULL, noteContent TEXT NOT NULL, createdAt TEXT DEFAULT CURRENT_TIMESTAMP)";
  String users =
      "create table users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT UNIQUE, usrEmail TEXT, usrPassword TEXT, usrTelefono TEXT)";
  String canchaTable =
      "CREATE TABLE canchas (canchaId INTEGER PRIMARY KEY AUTOINCREMENT, canchaTitle TEXT NOT NULL, canchaType TEXT NOT NULL, canchaImagen TEXT NOT NULL, createdAt TEXT DEFAULT CURRENT_TIMESTAMP)";

  String canchaInsert =
      "INSERT INTO canchas(canchaTitle, canchaType, canchaImagen) values('Epic Box','Cancha Tipo A', 'lib/assets/cancha1.png')";
  String canchaInsert2 =
      "INSERT INTO canchas(canchaTitle, canchaType, canchaImagen) values('Rusty Tenis','Cancha Tipo B', 'lib/assets/cancha2.png')";
  String canchaInsert3 =
      "INSERT INTO canchas(canchaTitle, canchaType, canchaImagen) values('Cancha Multiple','Cancha Tipo C', 'lib/assets/cancha3.png')";

  String bookTable =
      "CREATE TABLE books (bookId INTEGER PRIMARY KEY AUTOINCREMENT, canchaId INTEGER, userId INTEGER, fecha TEXT NOT NULL, horaInicio TEXT NOT NULL, horaFin TEXT NOT NULL, createdAt TEXT DEFAULT CURRENT_TIMESTAMP)";

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(users);
      await db.execute(noteTable);
      await db.execute(canchaTable);
      await db.execute(canchaInsert);
      await db.execute(canchaInsert2);
      await db.execute(canchaInsert3);
      await db.execute(bookTable);
    });
  }

  /*Future<List<Users>> login(Users user) async {
    final Database db = await initDB();

    // I forgot the password to check
    var result = await db.rawQuery(
        "select * from users where usrName = '${user.usrName}' AND usrPassword = '${user.usrPassword}'");
    print('sqlite login');
    print(result);
    print(result[0]);
    if (result.isNotEmpty) {
      return result.map((e) => Users.fromMap(e)).toList();
    } else {
      return result.map((e) => Users.fromMap(e)).toList();
    }
  }*/

  //login
  Future<List<Users>> login(Users user) async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query(
        'users where usrName="${user.usrName}" and usrPassword="${user.usrPassword}"');
    return result.map((e) => Users.fromMap(e)).toList();
  }

  Future<int> signup(Users user) async {
    final Database db = await initDB();

    return db.insert('users', user.toMap());
  }

  //CRUD methods
  //Create note
  Future<int> createNote(NoteModel note) async {
    final Database db = await initDB();
    return db.insert('notes', note.toMap());
  }

  //Get note
  Future<List<NoteModel>> getNotes() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('notes');
    return result.map((e) => NoteModel.fromMap(e)).toList();
  }

  //Update note
  Future<int> updateNote(title, content, noteId) async {
    final Database db = await initDB();
    return db.rawUpdate(
        'update notes set noteTitle = ?, noteContent = ? where noteId = ?',
        [title, content, noteId]);
  }

  //Delete note
  Future<int> deleteNote(int id) async {
    final Database db = await initDB();
    return db.delete('notes', where: 'noteId = ?', whereArgs: [id]);
  }

  //Search Method
  Future<List<CanchaModel>> searchCanchas(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult = await db.rawQuery(
        "select * from canchas where canchaTitle LIKE ?", ["%$keyword%"]);
    return searchResult.map((e) => CanchaModel.fromMap(e)).toList();
  }

  //CRUD Methods

  //Create Cancha
  Future<int> createCancha(CanchaModel cancha) async {
    final Database db = await initDB();
    return db.insert('canchas', cancha.toMap());
  }

  //Get canchas
  Future<List<CanchaModel>> getCanchas() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('canchas');
    return result.map((e) => CanchaModel.fromMap(e)).toList();
  }

  //Get users
  Future<List<Users>> getUsers() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('users');
    return result.map((e) => Users.fromMap(e)).toList();
  }

  //Get user
  Future<List<Users>> getUser(id) async {
    final Database db = await initDB();
    List<Map<String, Object?>> result =
        await db.query('select * from users where usrId = ?', whereArgs: [id]);
    return result.map((e) => Users.fromMap(e)).toList();
  }

  //Get cancha
  Future<List<CanchaModel>> getCancha(int canchaId) async {
    final Database db = await initDB();
    List<Map<String, Object?>> result =
        await db.query('canchas where canchaId = ? ', whereArgs: [canchaId]);
    return result.map((e) => CanchaModel.fromMap(e)).toList();
  }

  //Delete Canchas
  Future<int> deleteCancha(int id) async {
    final Database db = await initDB();
    return db.delete('canchas', where: 'canchaId = ?', whereArgs: [id]);
  }

  //Update Canchas
  Future<int> updateCancha(title, tipo, imagen, canchaId) async {
    final Database db = await initDB();
    return db.rawUpdate(
        'update canchas set canchaTitle = ?, canchaType = ?, canchaImagen = ? where canchaId = ?',
        [title, tipo, imagen, canchaId]);
  }

//Search Method
  Future<List<BookModel>> searchBooks(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult2 = await db
        .rawQuery("select * from books where bookTitle LIKE ?", ["%$keyword%"]);
    return searchResult2.map((e) => BookModel.fromMap(e)).toList();
  }

  //CRUD Methods

  //Create Books
  Future<int> createBook(BookModel book) async {
    final Database db = await initDB();
    return db.insert('books', book.toMap());
  }

  //Get Books
  Future<List<BookModel>> getBooks() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('books');
    return result.map((e) => BookModel.fromMap(e)).toList();
  }

  //Delete Books
  Future<int> deleteBook(int id) async {
    final Database db = await initDB();
    return db.delete('books', where: 'bookId = ?', whereArgs: [id]);
  }

  //Update Books
  Future<int> updateBook(int canchaId, int userId, String fecha,
      String horaInicio, String horaFin, int bookId) async {
    final Database db = await initDB();
    return db.rawUpdate(
        'update books set canchaId = ?, userId = ?, fecha = ?, horaInicio = ?, horaFin = ? where bookId = ?',
        [canchaId, userId, fecha, horaInicio, horaFin, bookId]);
  }
}
