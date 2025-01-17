import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/presentation/bloc/movie/detail_movie_bloc.dart';
import 'package:movietvseries/presentation/bloc/movie/recomendations_movie_bloc.dart';
import 'package:movietvseries/presentation/bloc/watchlist/watchlist_movie_bloc.dart';
import 'package:movietvseries/presentation/pages/movie/movie_detail_page.dart';
import 'package:movietvseries/injection.dart' as di;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../watchlist/watchlist_page_test.dart';
import '../watchlist/watchlist_page_test.mocks.dart';
import 'movie_detail_page_test.mocks.dart';

class DetailMovieIsUnhandledState extends DetailMovieState {
  @override
  List<Object> get props => [];
}

class MovieRecomendationsIsUnhandledState extends MovieRecomendationsState {
  @override
  List<Object> get props => [];
}

@GenerateMocks([DetailMovieBloc, MovieRecomendationsBloc])
void main() {
  late MockDetailMovieBloc mockDetailMovieBloc;
  late MockWatchListMovieBloc mockWatchListMovieBloc;
  late MockMovieRecomendationsBloc mockMovieRecomendationsBloc;

  const testId = 1;

  setUp(() async {
    sqfliteFfiInit();
    databaseFactoryOrNull = databaseFactoryFfi;

    await di.init();
    await dotenv.load(fileName: ".env");

    mockDetailMovieBloc = MockDetailMovieBloc();
    mockWatchListMovieBloc = MockWatchListMovieBloc();
    mockMovieRecomendationsBloc = MockMovieRecomendationsBloc();

    if (di.locator.isRegistered<DetailMovieBloc>()) {
      di.locator.unregister<DetailMovieBloc>();
    }
    if (di.locator.isRegistered<WatchListMovieBloc>()) {
      di.locator.unregister<WatchListMovieBloc>();
    }
    if (di.locator.isRegistered<MovieRecomendationsBloc>()) {
      di.locator.unregister<MovieRecomendationsBloc>();
    }

    di.locator
        .registerLazySingleton<DetailMovieBloc>(() => mockDetailMovieBloc);
    di.locator.registerLazySingleton<WatchListMovieBloc>(
        () => mockWatchListMovieBloc);
    di.locator.registerLazySingleton<MovieRecomendationsBloc>(
        () => mockMovieRecomendationsBloc);
  });

  tearDown(() {
    di.locator.reset();
  });

  group('Detail Movie Page', () {
    testWidgets('DetailMoviePage renders correctly with Detail Movie',
        (WidgetTester tester) async {
      when(mockDetailMovieBloc.state)
          .thenReturn(DetailMovieIsLoaded(testMovieDetail));
      when(mockDetailMovieBloc.stream).thenAnswer(
          (_) => Stream.value(DetailMovieIsLoaded(testMovieDetail)));

      when(mockWatchListMovieBloc.state)
          .thenReturn(WatchListMovieIsUnhandledState());
      when(mockWatchListMovieBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListMovieIsUnhandledState()));

      when(mockMovieRecomendationsBloc.state)
          .thenReturn(MovieRecomendationsIsUnhandledState());
      when(mockMovieRecomendationsBloc.stream).thenAnswer(
          (_) => Stream.value(MovieRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: MovieDetailPage(id: testId),
      ));
      expect(find.byType(DetailContent), findsWidgets);
    });

    testWidgets('DetailMoviePage shows loading spinner while fetching movies',
        (WidgetTester tester) async {
      when(mockDetailMovieBloc.state).thenReturn(DetailMovieIsLoading());
      when(mockDetailMovieBloc.stream)
          .thenAnswer((_) => Stream.value(DetailMovieIsLoading()));

      when(mockWatchListMovieBloc.state)
          .thenReturn(WatchListMovieIsUnhandledState());
      when(mockWatchListMovieBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListMovieIsUnhandledState()));

      when(mockMovieRecomendationsBloc.state)
          .thenReturn(MovieRecomendationsIsUnhandledState());
      when(mockMovieRecomendationsBloc.stream).thenAnswer(
          (_) => Stream.value(MovieRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: MovieDetailPage(id: testId),
      ));
      // Verify if loading indicators are present
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets(
        'DetailMoviePage displays error messages if movies fail to load',
        (WidgetTester tester) async {
      const errorMessage = 'Something went wrong';
      when(mockDetailMovieBloc.state)
          .thenReturn(DetailMovieIsError(errorMessage));
      when(mockDetailMovieBloc.stream)
          .thenAnswer((_) => Stream.value(DetailMovieIsError(errorMessage)));

      when(mockWatchListMovieBloc.state)
          .thenReturn(WatchListMovieIsUnhandledState());
      when(mockWatchListMovieBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListMovieIsUnhandledState()));

      when(mockMovieRecomendationsBloc.state)
          .thenReturn(MovieRecomendationsIsUnhandledState());
      when(mockMovieRecomendationsBloc.stream).thenAnswer(
          (_) => Stream.value(MovieRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: MovieDetailPage(id: testId),
      ));

      // Verify if loading indicators are present
      expect(find.text(errorMessage), findsWidgets);
    });

    testWidgets('DetailMoviePage renders correctly with default state',
        (WidgetTester tester) async {
      when(mockDetailMovieBloc.state).thenReturn(DetailMovieIsUnhandledState());
      when(mockDetailMovieBloc.stream)
          .thenAnswer((_) => Stream.value(DetailMovieIsUnhandledState()));

      when(mockWatchListMovieBloc.state)
          .thenReturn(WatchListMovieIsUnhandledState());
      when(mockWatchListMovieBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListMovieIsUnhandledState()));

      when(mockMovieRecomendationsBloc.state)
          .thenReturn(MovieRecomendationsIsUnhandledState());
      when(mockMovieRecomendationsBloc.stream).thenAnswer(
          (_) => Stream.value(MovieRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: MovieDetailPage(id: testId),
      ));

      // Verify if default state is displayed
      expect(find.byType(Container), findsWidgets);
    });
  });

  group('DetailContent', () {
    testWidgets('DetailContent renders correctly with true watchlist status',
        (WidgetTester tester) async {
      final watchListStatus = true;
      when(mockWatchListMovieBloc.state)
          .thenReturn(WatchListMovieStatusIsLoaded(watchListStatus));
      when(mockWatchListMovieBloc.stream).thenAnswer(
          (_) => Stream.value(WatchListMovieStatusIsLoaded(watchListStatus)));

      when(mockMovieRecomendationsBloc.state)
          .thenReturn(MovieRecomendationsIsUnhandledState());
      when(mockMovieRecomendationsBloc.stream).thenAnswer(
          (_) => Stream.value(MovieRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: DetailContent(testMovieDetail),
      ));

      expect(
        find.widgetWithIcon(ElevatedButton, Icons.check),
        findsOneWidget,
      );
    });

    testWidgets('DetailContent renders correctly with false watchlist status',
        (WidgetTester tester) async {
      final watchListStatus = false;
      when(mockWatchListMovieBloc.state)
          .thenReturn(WatchListMovieStatusIsLoaded(watchListStatus));
      when(mockWatchListMovieBloc.stream).thenAnswer(
          (_) => Stream.value(WatchListMovieStatusIsLoaded(watchListStatus)));

      when(mockMovieRecomendationsBloc.state)
          .thenReturn(MovieRecomendationsIsUnhandledState());
      when(mockMovieRecomendationsBloc.stream).thenAnswer(
          (_) => Stream.value(MovieRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: DetailContent(testMovieDetail),
      ));

      expect(
        find.widgetWithIcon(ElevatedButton, Icons.add),
        findsOneWidget,
      );
    });

    testWidgets(
        'DetailContent renders correctly with loading spinner while fetching watchlist status',
        (WidgetTester tester) async {
      when(mockWatchListMovieBloc.state).thenReturn(WatchListMovieIsLoading());
      when(mockWatchListMovieBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListMovieIsLoading()));

      when(mockMovieRecomendationsBloc.state)
          .thenReturn(MovieRecomendationsIsUnhandledState());
      when(mockMovieRecomendationsBloc.stream).thenAnswer(
          (_) => Stream.value(MovieRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: DetailContent(testMovieDetail),
      ));

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets(
        'DetailContent displays error messages if WatchListMovieIsError to load',
        (WidgetTester tester) async {
      const errorMessage = 'Something went wrong';
      when(mockWatchListMovieBloc.state)
          .thenReturn(WatchListMovieIsError(errorMessage));
      when(mockWatchListMovieBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListMovieIsError(errorMessage)));

      when(mockMovieRecomendationsBloc.state)
          .thenReturn(MovieRecomendationsIsUnhandledState());
      when(mockMovieRecomendationsBloc.stream).thenAnswer(
          (_) => Stream.value(MovieRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: DetailContent(testMovieDetail),
      ));

      expect(find.text(errorMessage), findsWidgets);
    });

    testWidgets('DetailContent renders correctly with default state',
        (WidgetTester tester) async {
      when(mockWatchListMovieBloc.state)
          .thenReturn(WatchListMovieIsUnhandledState());
      when(mockWatchListMovieBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListMovieIsUnhandledState()));

      when(mockMovieRecomendationsBloc.state)
          .thenReturn(MovieRecomendationsIsUnhandledState());
      when(mockMovieRecomendationsBloc.stream).thenAnswer(
          (_) => Stream.value(MovieRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: DetailContent(testMovieDetail),
      ));

      // Verify if default state is displayed
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets(
        'DetailContent Scaffold renders correctly while update watchlist status',
        (WidgetTester tester) async {
      when(mockWatchListMovieBloc.state)
          .thenReturn(WatchListMovieIsSaved('Added to Watchlist'));
      when(mockWatchListMovieBloc.stream).thenAnswer(
          (_) => Stream.value(WatchListMovieIsSaved('Added to Watchlist')));

      when(mockMovieRecomendationsBloc.state)
          .thenReturn(MovieRecomendationsIsUnhandledState());
      when(mockMovieRecomendationsBloc.stream).thenAnswer(
          (_) => Stream.value(MovieRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: DetailContent(testMovieDetail)),
      ));

      expect(find.byType(ScaffoldMessenger), findsOneWidget);
    });
  });

  testWidgets('onPressed of ElevatedButton Watchlist is called',
      (WidgetTester tester) async {
    when(mockWatchListMovieBloc.state)
        .thenReturn(WatchListMovieStatusIsLoaded(false));
    when(mockWatchListMovieBloc.stream)
        .thenAnswer((_) => Stream.value(WatchListMovieStatusIsLoaded(false)));

    when(mockMovieRecomendationsBloc.state)
        .thenReturn(MovieRecomendationsIsUnhandledState());
    when(mockMovieRecomendationsBloc.stream)
        .thenAnswer((_) => Stream.value(MovieRecomendationsIsUnhandledState()));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: DetailContent(testMovieDetail)),
    ));

    final elevatedButtonFinder = find.byType(ElevatedButton);

    await tester.tap(elevatedButtonFinder);
    await tester.pump();

    verify(mockWatchListMovieBloc
            .add(UpdateWatchListMovieStatus(testMovieDetail, false)))
        .called(1);
  });

  group('Recomendations', () {
    testWidgets('Recomendations renders correctly with true watchlist status',
        (WidgetTester tester) async {
      when(mockWatchListMovieBloc.state)
          .thenReturn(WatchListMovieIsUnhandledState());
      when(mockWatchListMovieBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListMovieIsUnhandledState()));

      when(mockMovieRecomendationsBloc.state)
          .thenReturn(MovieRecomendationsIsLoaded(testMovieList));
      when(mockMovieRecomendationsBloc.stream).thenAnswer(
          (_) => Stream.value(MovieRecomendationsIsLoaded(testMovieList)));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: DetailContent(testMovieDetail)),
      ));

      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets(
        'Recomendations renders correctly with loading spinner while fetching watchlist status',
        (WidgetTester tester) async {
      when(mockWatchListMovieBloc.state)
          .thenReturn(WatchListMovieIsUnhandledState());
      when(mockWatchListMovieBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListMovieIsUnhandledState()));

      when(mockMovieRecomendationsBloc.state)
          .thenReturn(MovieRecomendationsIsLoading());
      when(mockMovieRecomendationsBloc.stream)
          .thenAnswer((_) => Stream.value(MovieRecomendationsIsLoading()));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: DetailContent(testMovieDetail)),
      ));

      expect(find.byType(CircularProgressIndicator), findsExactly(2));
    });

    testWidgets(
        'Recomendations displays error messages if WatchListMovieIsError to load',
        (WidgetTester tester) async {
      const errorMessage = 'Something went wrong';
      when(mockWatchListMovieBloc.state)
          .thenReturn(WatchListMovieIsUnhandledState());
      when(mockWatchListMovieBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListMovieIsUnhandledState()));

      when(mockMovieRecomendationsBloc.state)
          .thenReturn(MovieRecomendationsIsError(errorMessage));
      when(mockMovieRecomendationsBloc.stream).thenAnswer(
          (_) => Stream.value(MovieRecomendationsIsError(errorMessage)));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: DetailContent(testMovieDetail)),
      ));

      expect(find.text(errorMessage), findsWidgets);
    });

    testWidgets('Recomendations renders correctly with default state',
        (WidgetTester tester) async {
      when(mockWatchListMovieBloc.state)
          .thenReturn(WatchListMovieIsUnhandledState());
      when(mockWatchListMovieBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListMovieIsUnhandledState()));

      when(mockMovieRecomendationsBloc.state)
          .thenReturn(MovieRecomendationsIsUnhandledState());
      when(mockMovieRecomendationsBloc.stream).thenAnswer(
          (_) => Stream.value(MovieRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: DetailContent(testMovieDetail)),
      ));

      // Verify if default state is displayed
      expect(find.byType(Container), findsWidgets);
    });
  });
}
