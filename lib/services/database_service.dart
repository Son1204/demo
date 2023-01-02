import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test123/models/chi_tiet_ky_cong.dart';
import 'package:test123/models/employee.dart';
import 'package:test123/models/ky_cong.dart';
import 'package:test123/models/up_level.dart';

import '../models/bill.dart';
import '../models/breed.dart';
import '../models/dog.dart';
import '../models/log.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    print("INIT DATABASE");
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'flutter_sqflite31.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 5,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to store breeds
  // and a table to store dogs.
  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {breeds} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE breeds(id INTEGER PRIMARY KEY, name TEXT, description TEXT)',
    );
    await db.execute(
      'CREATE TABLE employee('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'name TEXT, '
          'wage INTEGER, '
          'daThanhToan INTEGER, '
          'chuaThanhToan INTEGER, '
          'tongTienChuaThanhToan INTEGER, '
          'tongThuNhap INTEGER, '
          'description TEXT, '
      'wageOld INTEGER, '
      'dateUpLevel TEXT'
      ')',
    );

    await db.execute(
      'CREATE TABLE log('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'description1 TEXT, '
          'day INTEGER, '
          'month INTEGER, '
          'year INTEGER, '
          'date TEXT, '
          'dateTime TEXT, '
          'dataJson TEXT, '
          'employeeId INTEGER, '
          'FOREIGN KEY (employeeId) REFERENCES employee(id) ON DELETE SET NULL '
      ')',
    );

    await db.execute(
      'CREATE TABLE uplevel('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'wageOld INTEGER, '
          'wageNew INTEGER, '
          'day INTEGER, '
          'month INTEGER, '
          'year INTEGER, '
          'employeeId INTEGER, '
          'description TEXT, '
          'date TEXT, '
          'FOREIGN KEY (employeeId) REFERENCES employee(id) ON DELETE SET NULL '
          ')',
    );

    await db.execute(
      'CREATE TABLE bill('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'soTien INTEGER, '
          'employeeId INTEGER, '
          'day INTEGER, '
          'month INTEGER, '
          'year INTEGER, '
          'date TEXT, '
          'description TEXT, '
          'FOREIGN KEY (employeeId) REFERENCES employee(id) ON DELETE SET NULL '
      ')',
    );

    await db.execute(
      'CREATE TABLE kycong('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'title TEXT, '
          'employeeId INTEGER, '
          'month INTEGER, '
          'year INTEGER, '
          'ngayTinhCong INTEGER, '
          'soNgayCongTrongThang INTEGER, '
          'soNgayDiLam INTEGER, '
          'soNgayNghiPhep INTEGER, '
          'soNgayNghiKhongLuong INTEGER, '
          'soNgayDiLamNuaBuoi INTEGER,'
          'totalOfMonth INTEGER, '
          'daThanhToanThang INTEGER, '
          'chuaThanhToanThang INTEGER, '
          'note TEXT, '
          'FOREIGN KEY (employeeId) REFERENCES employee(id) ON DELETE SET NULL '
      ')',
    );
    await db.execute(
      'CREATE TABLE chitietkycong('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'title TEXT, '
          'kyCongId INTEGER,'
          'day INTEGER,'
          'date TEXT, '
          'chamCongNgay TEXT, '
          'thuNhapThucTe INTEGER, '
          'FOREIGN KEY (kyCongId) REFERENCES kycong(id) ON DELETE SET NULL'
      ')',
    );

  // TODO: table log
    print("CREATE TABLE");
    // Run the CREATE {dogs} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER, color INTEGER, breedId INTEGER, FOREIGN KEY (breedId) REFERENCES breeds(id) ON DELETE SET NULL)',
    );
  }

  // Define a function that inserts breeds into the database
  Future<void> insertBreed(Breed breed) async {

    // Get a reference to the database.
    final db = await _databaseService.database;

    // Insert the Breed into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same breed is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'breeds',
      breed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertDog(Dog dog) async {
    final db = await _databaseService.database;
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the breeds from the breeds table.
  Future<List<Breed>> breeds() async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Query the table for all the Breeds.
    final List<Map<String, dynamic>> maps = await db.query('breeds');

    final List<Map<String, dynamic>> maps1 = await db.query('employee');
    print("SIZE: "+maps1.length.toString());

    // Convert the List<Map<String, dynamic> into a List<Breed>.
    return List.generate(maps.length, (index) => Breed.fromMap(maps[index]));
  }

  Future<Breed> breed(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('breeds', where: 'id = ?', whereArgs: [id]);
    return Breed.fromMap(maps[0]);
  }

  Future<List<Dog>> dogs() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('dogs');
    return List.generate(maps.length, (index) => Dog.fromMap(maps[index]));
  }

  // A method that updates a breed data from the breeds table.
  Future<void> updateBreed(Breed breed) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Update the given breed
    await db.update(
      'breeds',
      breed.toMap(),
      // Ensure that the Breed has a matching id.
      where: 'id = ?',
      // Pass the Breed's id as a whereArg to prevent SQL injection.
      whereArgs: [breed.id],
    );
  }

  Future<void> updateDog(Dog dog) async {
    final db = await _databaseService.database;
    await db.update('dogs', dog.toMap(), where: 'id = ?', whereArgs: [dog.id]);
  }

  // A method that deletes a breed data from the breeds table.
  Future<void> deleteBreed(int id) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Remove the Breed from the database.
    await db.delete(
      'breeds',
      // Use a `where` clause to delete a specific breed.
      where: 'id = ?',
      // Pass the Breed's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> deleteDog(int id) async {
    final db = await _databaseService.database;
    await db.delete('dogs', where: 'id = ?', whereArgs: [id]);
  }


  // Define a function that inserts breeds into the database
  Future<int> insertEmployee(Employee employee) async {
    final db = await _databaseService.database;

    print('(insertEmployee)'+employee.toMap().toString());
    return await db.insert(
      'employee',
      employee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Employee>> findAllEmployees() async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> maps = await db.query('employee');

    return List.generate(maps.length, (index) => Employee.fromMap(maps[index]));
  }

  Future<Breed> findEmployee(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
    await db.query('employee', where: 'id = ?', whereArgs: [id]);
    return Breed.fromMap(maps[0]);
  }

  Future<void> updateEmployee(Employee employee) async {
    final db = await _databaseService.database;
    print('(updateEmployee): '+employee.toString());
    await db.update(
      'employee',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<void> deleteEmployee(int id) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Remove the Breed from the database.
    await db.delete(
      'employee',
      // Use a `where` clause to delete a specific breed.
      where: 'id = ?',
      // Pass the Breed's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  // Future<List<EmployeeEnrich>> findAllEmployeesByDay(DateTime dateTime) async {
  //   final db = await _databaseService.database;
  //
  //   final List<Map<String, dynamic>> maps =
  //   await db.query(
  //       'employee em inner join kycong kc on em.id=kc.employeeId inner join chitietkycong ct on kc.id=ct.kyCongId ',
  //       where: 'ct.day = ? and kc.month = ? and kc.year ',
  //       whereArgs: [dateTime.day, dateTime.month, dateTime.year]);
  //   return List.generate(maps.length, (index) => EmployeeEnrich.fromMap(maps[index]));
  // }

  Future<int> insertKyCong(KyCong kyCong) async {
    final db = await _databaseService.database;

    print('(insertKyCong)'+kyCong.toMap().toString());
    return await db.insert(
      'kycong',
      kyCong.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateKyCong(KyCong kyCong) async {
    final db = await _databaseService.database;
    print('(updateKyCong): '+kyCong.toString());
    await db.update(
      'kycong',
      kyCong.toMap(),
      where: 'id = ?',
      whereArgs: [kyCong.id],
    );
  }

  Future<int> insertChiTietKyCong(ChiTietKyCong chiTietKyCong) async {
    final db = await _databaseService.database;
    print('(insertChiTietKyCong)'+chiTietKyCong.toMap().toString());
    return await db.insert(
      'chitietkycong',
      chiTietKyCong.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateChiTietKyCong(ChiTietKyCong chiTietKyCong) async {
    final db = await _databaseService.database;
    print('(updateChiTietKyCong): '+chiTietKyCong.toString());
    await db.update(
      'chitietkycong',
      chiTietKyCong.toMap(),
      where: 'id = ?',
      whereArgs: [chiTietKyCong.id],
    );
  }

  Future<KyCong> findByEmployeeId(int employeeId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
    await db.query('kycong', where: 'employeeId = ?', whereArgs: [employeeId]);
    return KyCong.fromMap(maps[0]);
  }

  Future<ChiTietKyCong> findByKyCongId(int kyCongId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
    await db.query('chitietkycong', where: 'kyCongId = ?', whereArgs: [kyCongId]);
    return ChiTietKyCong.fromMap(maps[0]);
  }

  Future<bool> checkKyCongId(int employeeId, DateTime dateTime) async {
    final db = await _databaseService.database;
    // final int maps =
    //     await db.query('EXCEPT  SELECT employeeId FROM kycong');
    // return KyCong.fromMap(maps[0]);

    var result = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM kycong kc INNER JOIN employee em ON kc.employeeId=em.id WHERE em.id='+employeeId.toString()+' and kc.month='+dateTime.month.toString()+' and kc.year='+dateTime.year.toString()+' )',
    );
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<ChiTietKyCong> findChiTietKyCong(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
    await db.query('chitietkycong', where: 'id = ?', whereArgs: [id]);
    return ChiTietKyCong.fromMap(maps[0]);
  }

  Future<ChiTietKyCong> findChiTietKyCongByEmployeeIdAndDateTime(int employeeId, DateTime dateTime) async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> maps =
        await db.query(
        'employee em inner join kycong kc on em.id=kc.employeeId inner join chitietkycong ct on kc.id=ct.kyCongId ',
        where: 'ct.day = ? and kc.month = ? and kc.year=? and em.id=? ',
        whereArgs: [dateTime.day, dateTime.month, dateTime.year, employeeId]);
    return ChiTietKyCong.fromMap(maps[0]);
  }

  Future<List<ChiTietKyCong>> findChiTietKyCongsByEmployeeIdAndDateTime(int employeeId, String date) async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> maps =
    await db.query(
        'employee em inner join kycong kc on em.id=kc.employeeId inner join chitietkycong ct on kc.id=ct.kyCongId ',
        where: 'ct.date >= ? and em.id=? ',
        whereArgs: [date, employeeId]);

    return List.generate(maps.length, (index) => ChiTietKyCong.fromMap(maps[index]));
  }

  Future<List<ChiTietKyCong>> findChiTietKyCongByDateTime(DateTime dateTime) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
        'kycong kc inner join chitietkycong ct on kc.id=ct.kyCongId ',
        where: 'ct.day=? and kc.month=? and kc.year=?',
        whereArgs: [dateTime.day, dateTime.month, dateTime.year]
    );
    return List.generate(maps.length, (index) => ChiTietKyCong.fromMap(maps[index]));
  }

  Future<bool> checkChiTietKyCong(int employeeId, DateTime dateTime) async {
    final db = await _databaseService.database;
    var result = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 '
          'FROM kycong kc INNER JOIN employee em ON kc.employeeId=em.id inner join chitietkycong ct on kc.id=ct.kyCongId '
          'WHERE em.id='+employeeId.toString()+' and kc.month='+dateTime.month.toString()+' and kc.year='+dateTime.year.toString()+' and ct.day='+dateTime.day.toString()+' )',
    );
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<KyCong> findKyCongIdByEmployeeAndDateTime(int employeeId, DateTime dateTime) async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> maps =
        await db.query(
        'employee em inner join kycong kc on em.id=kc.employeeId  ',
        where: 'kc.month = ? and kc.year=? and em.id=? ',
        whereArgs: [dateTime.month, dateTime.year, employeeId]);
    return KyCong.fromMap(maps[0]);
  }

  Future<List<ChiTietKyCong>> findChiTietKyCongByEmployeeAndDate(int employeeId, DateTime dateTime) async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> maps =
        await db.query(
        'employee em inner join kycong kc on em.id=kc.employeeId inner join chitietkycong ct on kc.id=ct.kyCongId ',
        where: 'kc.month = ? and kc.year=? and em.id=? ',
        orderBy: 'ct.day',
        whereArgs: [dateTime.month, dateTime.year, employeeId]);
    return List.generate(maps.length, (index) => ChiTietKyCong.fromMap(maps[index]));
  }

  Future<List<ChiTietKyCong>> findChiTietKyCongByKyCongId(int kyCongId) async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> maps =
        await db.query(
        'chitietkycong ',
        where: 'kyCongId = ? ',
        whereArgs: [kyCongId]);
    return List.generate(maps.length, (index) => ChiTietKyCong.fromMap(maps[index]));
  }


  Future<void> insertBill(Bill bill) async {
    final db = await _databaseService.database;

    await db.insert(
      'bill',
      bill.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('(insertBill)'+bill.toMap().toString());
  }

  Future<void> insertUpLevel(UpLevel upLevel) async {
    final db = await _databaseService.database;

    await db.insert(
      'uplevel',
      upLevel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('(insertUpLevel)'+upLevel.toMap().toString());
  }


  Future<List<Bill>> findBillsByEmployeeAndDateTime(int employeeId, DateTime dateTime) async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> maps =
    await db.query(
        'bill ',
        where: 'month = ? and year=? and employeeId=? ',
        whereArgs: [dateTime.month, dateTime.year, employeeId]);
    return List.generate(maps.length, (index) => Bill.fromMap(maps[index]));
  }

  Future<void> insertLog(Log log) async {

    // Get a reference to the database.
    final db = await _databaseService.database;

    // Insert the Breed into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same breed is inserted twice.
    //
    // In this case, replace any previous data.
    print(log);
    await db.insert(
      'log',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Log>> findLogsByEmployee(int employeeId, int page) async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> maps =
        await db.query(
        'log lg inner join employee em on lg.employeeId = em.id ',
        where: 'lg.employeeId=? ',
        offset: page,
        limit: 10,
        whereArgs: [employeeId],
        orderBy: 'date DESC, lg.id DESC '
        );
    return List.generate(maps.length, (index) => Log.fromMap(maps[index]));
  }

}
