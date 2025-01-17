import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/presentation/bloc/tv/detail_tv_bloc.dart';
import 'package:movietvseries/presentation/bloc/tv/recomendations_tv_bloc.dart';
import 'package:movietvseries/injection.dart' as di;
import 'package:movietvseries/presentation/bloc/watchlist/watchlist_tv_bloc.dart';
import 'package:movietvseries/presentation/pages/tv/tv_detail_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../watchlist/watchlist_page_test.dart';
import '../watchlist/watchlist_page_test.mocks.dart';
import 'tv_detail_page_test.mocks.dart';

class DetailTVIsUnhandledState extends DetailTVState {
  @override
  List<Object> get props => [];
}

class TVRecomendationsIsUnhandledState extends TVRecomendationsState {
  @override
  List<Object> get props => [];
}

@GenerateMocks([DetailTVBloc, TVRecomendationsBloc])
void main() {
  late MockDetailTVBloc mockDetailTVBloc;
  late MockWatchListTVBloc mockWatchListTvBloc;
  late MockTVRecomendationsBloc mockTVRecomendationsBloc;

  const testId = 1;

  setUp(() async {
    sqfliteFfiInit();
    databaseFactoryOrNull = databaseFactoryFfi;

    await di.init();
    await dotenv.load(fileName: ".env");

    mockDetailTVBloc = MockDetailTVBloc();
    mockWatchListTvBloc = MockWatchListTVBloc();
    mockTVRecomendationsBloc = MockTVRecomendationsBloc();

    if (di.locator.isRegistered<DetailTVBloc>()) {
      di.locator.unregister<DetailTVBloc>();
    }
    if (di.locator.isRegistered<WatchListTVBloc>()) {
      di.locator.unregister<WatchListTVBloc>();
    }
    if (di.locator.isRegistered<TVRecomendationsBloc>()) {
      di.locator.unregister<TVRecomendationsBloc>();
    }

    di.locator.registerLazySingleton<DetailTVBloc>(() => mockDetailTVBloc);
    di.locator
        .registerLazySingleton<WatchListTVBloc>(() => mockWatchListTvBloc);
    di.locator.registerLazySingleton<TVRecomendationsBloc>(
        () => mockTVRecomendationsBloc);
  });

  tearDown(() {
    di.locator.reset();
  });

  group('Detail TV Page', () {
    testWidgets('DetailTVPage renders correctly with Detail TV',
        (WidgetTester tester) async {
      when(mockDetailTVBloc.state).thenReturn(DetailTVIsLoaded(testTvDetail));
      when(mockDetailTVBloc.stream)
          .thenAnswer((_) => Stream.value(DetailTVIsLoaded(testTvDetail)));

      when(mockWatchListTvBloc.state).thenReturn(WatchListTVIsUnhandledState());
      when(mockWatchListTvBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListTVIsUnhandledState()));

      when(mockTVRecomendationsBloc.state)
          .thenReturn(TVRecomendationsIsUnhandledState());
      when(mockTVRecomendationsBloc.stream)
          .thenAnswer((_) => Stream.value(TVRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: TvDetailPage(id: testId),
      ));
      expect(find.byType(DetailContent), findsWidgets);
    });

    testWidgets('DetailTVPage shows loading spinner while fetching tvs',
        (WidgetTester tester) async {
      when(mockDetailTVBloc.state).thenReturn(DetailTVIsLoading());
      when(mockDetailTVBloc.stream)
          .thenAnswer((_) => Stream.value(DetailTVIsLoading()));

      when(mockWatchListTvBloc.state).thenReturn(WatchListTVIsUnhandledState());
      when(mockWatchListTvBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListTVIsUnhandledState()));

      when(mockTVRecomendationsBloc.state)
          .thenReturn(TVRecomendationsIsUnhandledState());
      when(mockTVRecomendationsBloc.stream)
          .thenAnswer((_) => Stream.value(TVRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: TvDetailPage(id: testId),
      ));
      // Verify if loading indicators are present
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('DetailTVPage displays error messages if tvs fail to load',
        (WidgetTester tester) async {
      const errorMessage = 'Something went wrong';
      when(mockDetailTVBloc.state).thenReturn(DetailTVIsError(errorMessage));
      when(mockDetailTVBloc.stream)
          .thenAnswer((_) => Stream.value(DetailTVIsError(errorMessage)));

      when(mockWatchListTvBloc.state).thenReturn(WatchListTVIsUnhandledState());
      when(mockWatchListTvBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListTVIsUnhandledState()));

      when(mockTVRecomendationsBloc.state)
          .thenReturn(TVRecomendationsIsUnhandledState());
      when(mockTVRecomendationsBloc.stream)
          .thenAnswer((_) => Stream.value(TVRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: TvDetailPage(id: testId),
      ));

      // Verify if loading indicators are present
      expect(find.text(errorMessage), findsWidgets);
    });

    testWidgets('DetailTVPage renders correctly with default state',
        (WidgetTester tester) async {
      when(mockDetailTVBloc.state).thenReturn(DetailTVIsUnhandledState());
      when(mockDetailTVBloc.stream)
          .thenAnswer((_) => Stream.value(DetailTVIsUnhandledState()));

      when(mockWatchListTvBloc.state).thenReturn(WatchListTVIsUnhandledState());
      when(mockWatchListTvBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListTVIsUnhandledState()));

      when(mockTVRecomendationsBloc.state)
          .thenReturn(TVRecomendationsIsUnhandledState());
      when(mockTVRecomendationsBloc.stream)
          .thenAnswer((_) => Stream.value(TVRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: TvDetailPage(id: testId),
      ));

      // Verify if default state is displayed
      expect(find.byType(Container), findsWidgets);
    });
  });

  group('DetailContent', () {
    testWidgets('DetailContent renders correctly with true watchlist status',
        (WidgetTester tester) async {
      final watchListStatus = true;
      when(mockWatchListTvBloc.state)
          .thenReturn(WatchListTVStatusIsLoaded(watchListStatus));
      when(mockWatchListTvBloc.stream).thenAnswer(
          (_) => Stream.value(WatchListTVStatusIsLoaded(watchListStatus)));

      when(mockTVRecomendationsBloc.state)
          .thenReturn(TVRecomendationsIsUnhandledState());
      when(mockTVRecomendationsBloc.stream)
          .thenAnswer((_) => Stream.value(TVRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: DetailContent(testTvDetail),
      ));

      expect(
        find.widgetWithIcon(ElevatedButton, Icons.check),
        findsOneWidget,
      );
    });

    testWidgets('DetailContent renders correctly with false watchlist status',
        (WidgetTester tester) async {
      final watchListStatus = false;
      when(mockWatchListTvBloc.state)
          .thenReturn(WatchListTVStatusIsLoaded(watchListStatus));
      when(mockWatchListTvBloc.stream).thenAnswer(
          (_) => Stream.value(WatchListTVStatusIsLoaded(watchListStatus)));

      when(mockTVRecomendationsBloc.state)
          .thenReturn(TVRecomendationsIsUnhandledState());
      when(mockTVRecomendationsBloc.stream)
          .thenAnswer((_) => Stream.value(TVRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: DetailContent(testTvDetail),
      ));

      expect(
        find.widgetWithIcon(ElevatedButton, Icons.add),
        findsOneWidget,
      );
    });

    testWidgets(
        'DetailContent renders correctly with loading spinner while fetching watchlist status',
        (WidgetTester tester) async {
      when(mockWatchListTvBloc.state).thenReturn(WatchListTVIsLoading());
      when(mockWatchListTvBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListTVIsLoading()));

      when(mockTVRecomendationsBloc.state)
          .thenReturn(TVRecomendationsIsUnhandledState());
      when(mockTVRecomendationsBloc.stream)
          .thenAnswer((_) => Stream.value(TVRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: DetailContent(testTvDetail),
      ));

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets(
        'DetailContent displays error messages if WatchListTVIsError to load',
        (WidgetTester tester) async {
      const errorMessage = 'Something went wrong';
      when(mockWatchListTvBloc.state)
          .thenReturn(WatchListTVIsError(errorMessage));
      when(mockWatchListTvBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListTVIsError(errorMessage)));

      when(mockTVRecomendationsBloc.state)
          .thenReturn(TVRecomendationsIsUnhandledState());
      when(mockTVRecomendationsBloc.stream)
          .thenAnswer((_) => Stream.value(TVRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: DetailContent(testTvDetail),
      ));

      expect(find.text(errorMessage), findsWidgets);
    });

    testWidgets('DetailContent renders correctly with default state',
        (WidgetTester tester) async {
      when(mockWatchListTvBloc.state).thenReturn(WatchListTVIsUnhandledState());
      when(mockWatchListTvBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListTVIsUnhandledState()));

      when(mockTVRecomendationsBloc.state)
          .thenReturn(TVRecomendationsIsUnhandledState());
      when(mockTVRecomendationsBloc.stream)
          .thenAnswer((_) => Stream.value(TVRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: DetailContent(testTvDetail),
      ));

      // Verify if default state is displayed
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets(
        'DetailContent Scaffold renders correctly while update watchlist status',
        (WidgetTester tester) async {
      when(mockWatchListTvBloc.state)
          .thenReturn(WatchListTVIsSaved('Added to Watchlist'));
      when(mockWatchListTvBloc.stream).thenAnswer(
          (_) => Stream.value(WatchListTVIsSaved('Added to Watchlist')));

      when(mockTVRecomendationsBloc.state)
          .thenReturn(TVRecomendationsIsUnhandledState());
      when(mockTVRecomendationsBloc.stream)
          .thenAnswer((_) => Stream.value(TVRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: DetailContent(testTvDetail)),
      ));

      expect(find.byType(ScaffoldMessenger), findsOneWidget);
    });
  });

  testWidgets('onPressed of ElevatedButton Watchlist is called',
      (WidgetTester tester) async {
    when(mockWatchListTvBloc.state)
        .thenReturn(WatchListTVStatusIsLoaded(false));
    when(mockWatchListTvBloc.stream)
        .thenAnswer((_) => Stream.value(WatchListTVStatusIsLoaded(false)));

    when(mockTVRecomendationsBloc.state)
        .thenReturn(TVRecomendationsIsUnhandledState());
    when(mockTVRecomendationsBloc.stream)
        .thenAnswer((_) => Stream.value(TVRecomendationsIsUnhandledState()));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: DetailContent(testTvDetail)),
    ));

    final elevatedButtonFinder = find.byType(ElevatedButton);

    await tester.tap(elevatedButtonFinder);
    await tester.pump();

    verify(mockWatchListTvBloc
            .add(UpdateWatchListTVStatus(testTvDetail, false)))
        .called(1);
  });

  group('Recomendations', () {
    testWidgets('Recomendations renders correctly with true watchlist status',
        (WidgetTester tester) async {
      when(mockWatchListTvBloc.state).thenReturn(WatchListTVIsUnhandledState());
      when(mockWatchListTvBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListTVIsUnhandledState()));

      when(mockTVRecomendationsBloc.state)
          .thenReturn(TVRecomendationsIsLoaded(testTvList));
      when(mockTVRecomendationsBloc.stream).thenAnswer(
          (_) => Stream.value(TVRecomendationsIsLoaded(testTvList)));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: DetailContent(testTvDetail)),
      ));

      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets(
        'Recomendations renders correctly with loading spinner while fetching watchlist status',
        (WidgetTester tester) async {
      when(mockWatchListTvBloc.state).thenReturn(WatchListTVIsUnhandledState());
      when(mockWatchListTvBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListTVIsUnhandledState()));

      when(mockTVRecomendationsBloc.state)
          .thenReturn(TVRecomendationsIsLoading());
      when(mockTVRecomendationsBloc.stream)
          .thenAnswer((_) => Stream.value(TVRecomendationsIsLoading()));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: DetailContent(testTvDetail)),
      ));

      expect(find.byType(CircularProgressIndicator), findsExactly(2));
    });

    testWidgets(
        'Recomendations displays error messages if WatchListTVIsError to load',
        (WidgetTester tester) async {
      const errorMessage = 'Something went wrong';
      when(mockWatchListTvBloc.state).thenReturn(WatchListTVIsUnhandledState());
      when(mockWatchListTvBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListTVIsUnhandledState()));

      when(mockTVRecomendationsBloc.state)
          .thenReturn(TVRecomendationsIsError(errorMessage));
      when(mockTVRecomendationsBloc.stream).thenAnswer(
          (_) => Stream.value(TVRecomendationsIsError(errorMessage)));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: DetailContent(testTvDetail)),
      ));

      expect(find.text(errorMessage), findsWidgets);
    });

    testWidgets('Recomendations renders correctly with default state',
        (WidgetTester tester) async {
      when(mockWatchListTvBloc.state).thenReturn(WatchListTVIsUnhandledState());
      when(mockWatchListTvBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListTVIsUnhandledState()));

      when(mockTVRecomendationsBloc.state)
          .thenReturn(TVRecomendationsIsUnhandledState());
      when(mockTVRecomendationsBloc.stream)
          .thenAnswer((_) => Stream.value(TVRecomendationsIsUnhandledState()));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: DetailContent(testTvDetail)),
      ));

      // Verify if default state is displayed
      expect(find.byType(Container), findsWidgets);
    });
  });
}
