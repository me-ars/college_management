import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/faculty.dart';
import '../../models/student.dart';
import 'database_service.dart';

class DatabaseServiceImpl extends DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'university.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create Students table
        await db.execute('''
    CREATE TABLE students(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      firstName TEXT,
      lastName TEXT,
      studentId TEXT UNIQUE,
      course TEXT,
      joiningDate TEXT,
      batch TEXT,
      gender TEXT,
      dob TEXT,
      phone TEXT,
      email TEXT UNIQUE,
      guardianName TEXT,
      guardianPhone TEXT,
      address TEXT,
      sslc TEXT,
      plusTwo TEXT,
      bachelors TEXT,
      loginPassword TEXT
    )
  ''');

        // Create Faculties table
        await db.execute('''
    CREATE TABLE faculties(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      firstName TEXT,
      lastName TEXT,
      employeeId TEXT UNIQUE,
      course TEXT,
      joiningDate TEXT,
      subject TEXT,
      gender TEXT,
      dob TEXT,
      phone TEXT,
      email TEXT UNIQUE,
      coName TEXT,
      coPhoneNumber TEXT,
      address TEXT,
      loginPassword TEXT
    )
  ''');
      },
    );
  }

  @override
  Future<void> insertStudent(Student student) async {
    final db = await database;
    await db.insert(
      'students',
      student.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> insertFaculty(Faculty faculty) async {
    final db = await database;
    await db.insert(
      'faculties',
      faculty.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Student>> getStudents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('students');
    return List.generate(maps.length, (i) {
      return Student.fromMap(maps[i]);
    });
  }

  @override
  Future<List<Faculty>> getFaculties() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('faculties');
    return List.generate(maps.length, (i) {
      return Faculty.fromMap(maps[i]);
    });
  }
}
