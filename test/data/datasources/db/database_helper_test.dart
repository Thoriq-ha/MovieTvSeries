import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/data/datasources/db/database_helper.dart';
import 'package:movietvseries/data/models/movie_table.dart';
import 'package:movietvseries/data/models/tv_table.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'database_helper_test.mocks.dart';

@GenerateMocks([MovieTable, Database])
void main() {
  late DatabaseHelper databaseHelperInit;
  late DatabaseHelper databaseHelper;
  late MockDatabase mockDatabase;
  late Database? db;

  setUp(() async {
    sqfliteFfiInit();
    databaseFactoryOrNull = databaseFactoryFfi;
    databaseHelperInit = DatabaseHelper();
    db = await databaseHelperInit.database;
    mockDatabase = MockDatabase();
    databaseHelper = DatabaseHelper(mockDatabase);
  });

  tearDown(() async {
    await db?.close();
  });

  group('Database Initialization', () {
    test('should call _initDb and _onCreate when initializing the database',
        () async {
      final db = await databaseHelperInit.database;

      expect(db, isNotNull);

      // Verify that the database instance is correctly initialized
      expect(db?.isOpen, true);

      final movieTableCheck = await db?.rawQuery(
          'SELECT name FROM sqlite_master WHERE type="table" AND name="moviewatchlist"');
      final tvTableCheck = await db?.rawQuery(
          'SELECT name FROM sqlite_master WHERE type="table" AND name="tvwatchlist"');

      expect(
          movieTableCheck?.isNotEmpty, true); // Ensure movie table is created
      expect(tvTableCheck?.isNotEmpty, true); // Ensure tv table is created
    });

    test('should return an existing database when called for the first time',
        () async {
      when(mockDatabase.query(any)).thenAnswer((_) async => []);

      final db = await databaseHelper.database;

      expect(db, equals(mockDatabase));
      verifyNever(mockDatabase.query(any));
    });

    test(
        'should create and return a database if it is the first time being called',
        () async {
      when(mockDatabase.query(any)).thenAnswer((_) async => []);

      final db = await databaseHelper.database;

      expect(db, isNotNull);
    });
  });

  group('DatabaseHelper - Movie Watchlist', () {
    const tblMovieWatchlist = 'moviewatchlist';
    const testMovie = MovieTable(
      id: 1,
      title: 'Test Movie',
      overview: 'Test Overview',
      posterPath: 'Test Path',
    );

    const testMovieMap = {
      'id': 1,
      'title': 'Test Movie',
      'overview': 'Test Overview',
      'posterPath': 'Test Path',
    };

    test('should insert movie into watchlist', () async {
      when(mockDatabase.insert(tblMovieWatchlist, testMovie.toJson()))
          .thenAnswer((_) async => 1);

      final result = await databaseHelper.insertMovieWatchlist(testMovie);

      verify(mockDatabase.insert(tblMovieWatchlist, testMovie.toJson()))
          .called(1);
      expect(result, 1);
    });

    test('should remove movie from watchlist', () async {
      when(mockDatabase.delete(
        tblMovieWatchlist,
        where: 'id = ?',
        whereArgs: [testMovie.id],
      )).thenAnswer((_) async => 1);

      final result = await databaseHelper.removeMovieWatchlist(testMovie);

      verify(mockDatabase.delete(
        tblMovieWatchlist,
        where: 'id = ?',
        whereArgs: [testMovie.id],
      )).called(1);
      expect(result, 1);
    });

    test('should get movie by id', () async {
      when(mockDatabase.query(
        tblMovieWatchlist,
        where: 'id = ?',
        whereArgs: [testMovie.id],
      )).thenAnswer((_) async => [testMovie.toJson()]);

      final result = await databaseHelper.getMovieById(testMovie.id);

      verify(mockDatabase.query(
        tblMovieWatchlist,
        where: 'id = ?',
        whereArgs: [testMovie.id],
      )).called(1);
      expect(result, testMovie.toJson());
    });

    test('should return Movie watchlist from the database', () async {
      // Arrange
      when(mockDatabase.query(any)).thenAnswer((_) async => [testMovieMap]);

      // Act
      final result = await databaseHelper.getWatchlistMovies();

      // Assert
      expect(result, [testMovieMap]);
      verify(mockDatabase.query(tblMovieWatchlist)).called(1);
    });
  });

  group('DatabaseHelper - TV Watchlist', () {
    const tblTvWatchlist = 'tvwatchlist';
    const testTv = TvTable(
      id: 1,
      name: 'Test TV',
      posterPath: 'Test Path',
      overview: 'Test Overview',
    );

    const testTvMap = {
      'id': 1,
      'name': 'Test TV',
      'poster_path': 'Test Path',
      'overview': 'Test Overview',
    };

    test('should insert tv show into watchlist', () async {
      when(mockDatabase.insert(tblTvWatchlist, testTv.toJson()))
          .thenAnswer((_) async => 1);

      final result = await databaseHelper.insertTvWatchlist(testTv);

      verify(mockDatabase.insert(tblTvWatchlist, testTv.toJson())).called(1);
      expect(result, 1);
    });

    test('should remove tv show from watchlist', () async {
      when(mockDatabase.delete(
        tblTvWatchlist,
        where: 'id = ?',
        whereArgs: [testTv.id],
      )).thenAnswer((_) async => 1);

      final result = await databaseHelper.removeTvWatchlist(testTv);

      verify(mockDatabase.delete(
        tblTvWatchlist,
        where: 'id = ?',
        whereArgs: [testTv.id],
      )).called(1);
      expect(result, 1);
    });

    test('should get tv show by id', () async {
      when(mockDatabase.query(
        tblTvWatchlist,
        where: 'id = ?',
        whereArgs: [testTv.id],
      )).thenAnswer((_) async => [testTv.toJson()]);

      final result = await databaseHelper.getTvById(testTv.id);

      verify(mockDatabase.query(
        tblTvWatchlist,
        where: 'id = ?',
        whereArgs: [testTv.id],
      )).called(1);
      expect(result, testTv.toJson());
    });

    test('should return TV watchlist from the database', () async {
      // Arrange
      when(mockDatabase.query(any)).thenAnswer((_) async => [testTvMap]);

      // Act
      final result = await databaseHelper.getWatchlistTv();

      // Assert
      expect(result, [testTvMap]);
      verify(mockDatabase.query(tblTvWatchlist)).called(1);
    });
  });
}
