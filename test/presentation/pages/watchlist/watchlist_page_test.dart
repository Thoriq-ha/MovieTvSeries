import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/presentation/bloc/watchlist/watchlist_movie_bloc.dart';
import 'package:movietvseries/presentation/bloc/watchlist/watchlist_tv_bloc.dart';
import 'package:movietvseries/presentation/pages/watchlist/watchlist_page.dart';
import 'package:movietvseries/presentation/widgets/movie_card_list.dart';
import 'package:movietvseries/presentation/widgets/tv_card_list.dart';
import 'package:movietvseries/injection.dart' as di;
import 'package:movietvseries/routes/my_router.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_page_test.mocks.dart';

class WatchListMovieIsUnhandledState extends WatchListMovieState {
  @override
  List<Object> get props => [];
}

class WatchListTVIsUnhandledState extends WatchListTVState {
  @override
  List<Object> get props => [];
}

@GenerateMocks([WatchListMovieBloc, WatchListTVBloc])
void main() {
  late MockWatchListMovieBloc mockWatchListMovieBloc;
  late MockWatchListTVBloc mockWatchListTVBloc;

  setUp(() async {
    await di.init();
    await dotenv.load(fileName: ".env");

    mockWatchListMovieBloc = MockWatchListMovieBloc();
    mockWatchListTVBloc = MockWatchListTVBloc();

    if (di.locator.isRegistered<WatchListMovieBloc>()) {
      di.locator.unregister<WatchListMovieBloc>();
    }
    if (di.locator.isRegistered<WatchListTVBloc>()) {
      di.locator.unregister<WatchListTVBloc>();
    }
    di.locator.registerLazySingleton<WatchListMovieBloc>(
        () => mockWatchListMovieBloc);
    di.locator
        .registerLazySingleton<WatchListTVBloc>(() => mockWatchListTVBloc);
  });

  tearDown(() {
    di.locator.reset();
  });

  testWidgets('WatchlistPage renders correctly with movie and tv sections',
      (WidgetTester tester) async {
    when(mockWatchListMovieBloc.state)
        .thenReturn(WatchListMovieIsLoaded(testMovieList));
    when(mockWatchListTVBloc.state).thenReturn(WatchListTVIsLoaded(testTvList));

    when(mockWatchListMovieBloc.stream)
        .thenAnswer((_) => Stream.value(WatchListMovieIsLoaded(testMovieList)));
    when(mockWatchListTVBloc.stream)
        .thenAnswer((_) => Stream.value(WatchListTVIsLoaded(testTvList)));

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: MyRouter(initialLocation: WatchlistPage.routeName).router,
      ),
    );

    // Verify if the appBar title is correct
    expect(find.text('Watchlist'), findsOneWidget);

    // Verify if Movie section is present
    expect(find.text('Movie'), findsOneWidget);

    // Verify if Tv section is present
    expect(find.text('Tv'), findsOneWidget);

    // Verify that no items are shown for both movies and tvs when lists are empty
    expect(find.byType(MovieCard), findsOneWidget);
    expect(find.byType(TvCard), findsOneWidget);
  });

  testWidgets(
      'WatchlistPage shows loading spinner while fetching movies and tvs',
      (WidgetTester tester) async {
    when(mockWatchListMovieBloc.state).thenReturn(WatchListMovieIsLoading());
    when(mockWatchListTVBloc.state).thenReturn(WatchListTVIsLoading());

    when(mockWatchListMovieBloc.stream)
        .thenAnswer((_) => Stream.value(WatchListMovieIsLoading()));
    when(mockWatchListTVBloc.stream)
        .thenAnswer((_) => Stream.value(WatchListTVIsLoading()));

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: MyRouter(initialLocation: WatchlistPage.routeName).router,
      ),
    );

    // Verify if loading indicators are present
    expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
  });

  testWidgets(
      'WatchlistPage displays error messages if movies or tvs fail to load',
      (WidgetTester tester) async {
    const errorMessage = 'Something went wrong';
    when(mockWatchListMovieBloc.state)
        .thenReturn(WatchListMovieIsError(errorMessage));
    when(mockWatchListTVBloc.state)
        .thenReturn(WatchListTVIsError(errorMessage));

    when(mockWatchListMovieBloc.stream)
        .thenAnswer((_) => Stream.value(WatchListMovieIsError(errorMessage)));
    when(mockWatchListTVBloc.stream)
        .thenAnswer((_) => Stream.value(WatchListTVIsError(errorMessage)));

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: MyRouter(initialLocation: WatchlistPage.routeName).router,
      ),
    );

    // Verify if error message is displayed for movies and tvs
    expect(find.text(errorMessage), findsNWidgets(2));
  });

  testWidgets('WatchlistPage renders correctly with default state',
      (WidgetTester tester) async {
    when(mockWatchListMovieBloc.state)
        .thenReturn(WatchListMovieIsUnhandledState());
    when(mockWatchListTVBloc.state).thenReturn(WatchListTVIsUnhandledState());

    when(mockWatchListMovieBloc.stream)
        .thenAnswer((_) => Stream.value(WatchListMovieIsUnhandledState()));
    when(mockWatchListTVBloc.stream)
        .thenAnswer((_) => Stream.value(WatchListTVIsUnhandledState()));

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: MyRouter(initialLocation: WatchlistPage.routeName).router,
      ),
    );

    // Verifiy if the default state is rendered
    expect(find.byType(Container), findsNWidgets(2));
  });
}
