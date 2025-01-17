import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/presentation/bloc/movie/now_playing_movie_bloc.dart';
import 'package:movietvseries/presentation/bloc/movie/popular_movie_bloc.dart';
import 'package:movietvseries/presentation/bloc/movie/top_rated_movie_bloc.dart';
import 'package:movietvseries/presentation/bloc/watchlist/watchlist_movie_bloc.dart';
import 'package:movietvseries/presentation/bloc/watchlist/watchlist_tv_bloc.dart';
import 'package:movietvseries/presentation/pages/about/about_page.dart';
import 'package:movietvseries/presentation/pages/movie/home_movie_page.dart';
import 'package:movietvseries/injection.dart' as di;
import 'package:movietvseries/presentation/pages/movie/popular_movies_page.dart';
import 'package:movietvseries/presentation/pages/movie/search_movie_page.dart';
import 'package:movietvseries/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:movietvseries/presentation/pages/tv/home_tv_page.dart';
import 'package:movietvseries/presentation/pages/watchlist/watchlist_page.dart';
import 'package:movietvseries/routes/my_router.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../watchlist/watchlist_page_test.dart';
import '../watchlist/watchlist_page_test.mocks.dart';
import 'home_movie_page_test.mocks.dart';

class NowPlayingMovieIsUnhandledState extends NowPlayingMovieState {
  @override
  List<Object> get props => [];
}

class PopularMovieIsUnhandledState extends PopularMoviesState {
  @override
  List<Object> get props => [];
}

class TopRatedMovieIsUnhandledState extends TopRatedMoviesState {
  @override
  List<Object> get props => [];
}

@GenerateMocks([NowPlayingMovieBloc, PopularMoviesBloc, TopRatedMoviesBloc])
void main() {
  late MockNowPlayingMovieBloc mockNowPlayingMovieBloc;
  late MockPopularMoviesBloc mockPopularMoviesBloc;
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;
  late MockWatchListMovieBloc mockWatchListMovieBloc;
  late MockWatchListTVBloc mockWatchListTVBloc;

  setUp(() async {
    await di.init();
    await dotenv.load(fileName: ".env");

    mockNowPlayingMovieBloc = MockNowPlayingMovieBloc();
    mockPopularMoviesBloc = MockPopularMoviesBloc();
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();

    if (di.locator.isRegistered<NowPlayingMovieBloc>()) {
      di.locator.unregister<NowPlayingMovieBloc>();
    }
    if (di.locator.isRegistered<PopularMoviesBloc>()) {
      di.locator.unregister<PopularMoviesBloc>();
    }
    if (di.locator.isRegistered<TopRatedMoviesBloc>()) {
      di.locator.unregister<TopRatedMoviesBloc>();
    }

    di.locator.registerLazySingleton<NowPlayingMovieBloc>(
      () => mockNowPlayingMovieBloc,
    );
    di.locator.registerLazySingleton<PopularMoviesBloc>(
      () => mockPopularMoviesBloc,
    );
    di.locator.registerLazySingleton<TopRatedMoviesBloc>(
      () => mockTopRatedMoviesBloc,
    );

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

  group('Drawer and AppBar', () {
    testWidgets('AppBar should display correct title and action',
        (WidgetTester tester) async {
      when(mockNowPlayingMovieBloc.state)
          .thenReturn(NowPlayingMovieIsUnhandledState());
      when(mockPopularMoviesBloc.state)
          .thenReturn(PopularMovieIsUnhandledState());
      when(mockTopRatedMoviesBloc.state)
          .thenReturn(TopRatedMovieIsUnhandledState());

      when(mockNowPlayingMovieBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingMovieIsUnhandledState()));
      when(mockPopularMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(PopularMovieIsUnhandledState()));
      when(mockTopRatedMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedMovieIsUnhandledState()));

      // Open the drawer
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(initialLocation: '/').router,
        ),
      );
      // Verify AppBar title
      expect(find.text('Ditonton'), findsOneWidget);

      // Verify AppBar action
      final searchIconFinder = find.byIcon(Icons.search);
      expect(searchIconFinder, findsOneWidget);

      // Tap on search icon
      await tester.tap(searchIconFinder);
      await tester.pumpAndSettle();

      // Verify search route
      expect(find.byType(SearchMoviePage), findsOneWidget);
    });

    testWidgets('Drawer should display correct items and action',
        (WidgetTester tester) async {
      when(mockNowPlayingMovieBloc.state)
          .thenReturn(NowPlayingMovieIsUnhandledState());
      when(mockPopularMoviesBloc.state)
          .thenReturn(PopularMovieIsUnhandledState());
      when(mockTopRatedMoviesBloc.state)
          .thenReturn(TopRatedMovieIsUnhandledState());

      when(mockNowPlayingMovieBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingMovieIsUnhandledState()));
      when(mockPopularMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(PopularMovieIsUnhandledState()));
      when(mockTopRatedMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedMovieIsUnhandledState()));

      when(mockWatchListMovieBloc.state)
          .thenReturn(WatchListMovieIsUnhandledState());
      when(mockWatchListTVBloc.state).thenReturn(WatchListTVIsUnhandledState());

      when(mockWatchListMovieBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListMovieIsUnhandledState()));
      when(mockWatchListTVBloc.stream)
          .thenAnswer((_) => Stream.value(WatchListTVIsUnhandledState()));

      // Open the drawer
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(initialLocation: '/').router,
        ),
      );
      final scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);

      final drawerFinder = find.byType(Drawer);
      expect(drawerFinder, findsNothing);

      final drawerIconFinder = find.byIcon(Icons.menu);
      expect(drawerIconFinder, findsOneWidget);

      await tester.tap(drawerIconFinder);
      await tester.pumpAndSettle();

      // Check if drawer is open
      expect(drawerFinder, findsOneWidget);

      final moviesMenuFinder = find.text('Movies');
      final tvMenuFinder = find.text('TV');
      final watchlistMenuFinder = find.text('Watchlist');
      final aboutMenuFinder = find.text('About');

      // Check for specific content inside the drawer
      expect(moviesMenuFinder, findsOneWidget);
      expect(tvMenuFinder, findsOneWidget);
      expect(watchlistMenuFinder, findsOneWidget);
      expect(aboutMenuFinder, findsOneWidget);

      await tester.tap(moviesMenuFinder);
      await tester.pumpAndSettle();
      expect(find.byType(HomeMoviePage), findsOneWidget);

      await tester.tap(drawerIconFinder);
      await tester.pumpAndSettle();
      await tester.tap(tvMenuFinder);
      await tester.pumpAndSettle();
      expect(find.byType(HomeTvPage), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(watchlistMenuFinder);
      await tester.pumpAndSettle();
      expect(find.byType(WatchlistPage), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(aboutMenuFinder);
      await tester.pumpAndSettle();
      expect(find.byType(AboutPage), findsOneWidget);
    });
  });

  testWidgets(
      'HomeMoviePage renders correctly with Now Playing Movies, Popular Movies, and Top Rated Movies',
      (WidgetTester tester) async {
    when(mockNowPlayingMovieBloc.state)
        .thenReturn(NowPlayingMovieIsLoaded(testMovieList));
    when(mockPopularMoviesBloc.state)
        .thenReturn(PopularMovieIsLoaded(testMovieList));
    when(mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMovieIsLoaded(testMovieList));

    when(mockNowPlayingMovieBloc.stream).thenAnswer(
        (_) => Stream.value(NowPlayingMovieIsLoaded(testMovieList)));
    when(mockPopularMoviesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMovieIsLoaded(testMovieList)));
    when(mockTopRatedMoviesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMovieIsLoaded(testMovieList)));

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: MyRouter(initialLocation: '/').router,
      ),
    );
    expect(find.byType(MovieList), findsNWidgets(3));
  });

  testWidgets('HomeMoviePage shows loading spinner while fetching movies',
      (WidgetTester tester) async {
    when(mockNowPlayingMovieBloc.state).thenReturn(NowPlayingMovieIsLoading());
    when(mockPopularMoviesBloc.state).thenReturn(PopularMovieIsLoading());
    when(mockTopRatedMoviesBloc.state).thenReturn(TopRatedMovieIsLoading());

    when(mockNowPlayingMovieBloc.stream)
        .thenAnswer((_) => Stream.value(NowPlayingMovieIsLoading()));
    when(mockPopularMoviesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMovieIsLoading()));
    when(mockTopRatedMoviesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMovieIsLoading()));

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: MyRouter(initialLocation: '/').router,
      ),
    );
    // Verify if loading indicators are present
    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('HomeMoviePage displays error messages if movies fail to load',
      (WidgetTester tester) async {
    const errorMessage = 'Something went wrong';
    when(mockNowPlayingMovieBloc.state)
        .thenReturn(NowPlayingMovieIsError(errorMessage));
    when(mockPopularMoviesBloc.state)
        .thenReturn(PopularMovieIsError(errorMessage));
    when(mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMovieIsError(errorMessage));

    when(mockNowPlayingMovieBloc.stream)
        .thenAnswer((_) => Stream.value(NowPlayingMovieIsError(errorMessage)));
    when(mockPopularMoviesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMovieIsError(errorMessage)));
    when(mockTopRatedMoviesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMovieIsError(errorMessage)));

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: MyRouter(initialLocation: '/').router,
      ),
    );
    // Verify if error message is displayed
    expect(find.text(errorMessage), findsNWidgets(3));
  });

  testWidgets('HomeMoviePage renders correctly with default state',
      (WidgetTester tester) async {
    when(mockNowPlayingMovieBloc.state)
        .thenReturn(NowPlayingMovieIsUnhandledState());
    when(mockPopularMoviesBloc.state)
        .thenReturn(PopularMovieIsUnhandledState());
    when(mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMovieIsUnhandledState());

    when(mockNowPlayingMovieBloc.stream)
        .thenAnswer((_) => Stream.value(NowPlayingMovieIsUnhandledState()));
    when(mockPopularMoviesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMovieIsUnhandledState()));
    when(mockTopRatedMoviesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMovieIsUnhandledState()));

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: MyRouter(initialLocation: '/').router,
      ),
    );
    // Verify if default state is displayed
    expect(find.byType(Container), findsNWidgets(3));

    final nowPlayingFinder = find.text('Now Playing');
    final popularFinder = find.text('Popular');
    final topRatedFinder = find.text('Top Rated');
    final seeMoreFinder = find.text('See More');

    expect(nowPlayingFinder, findsOneWidget);
    expect(popularFinder, findsOneWidget);
    expect(topRatedFinder, findsOneWidget);

    await tester.tap(seeMoreFinder.at(0));
    await tester.pumpAndSettle();
    expect(find.byType(PopularMoviesPage), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(seeMoreFinder.at(1));
    await tester.pumpAndSettle();
    expect(find.byType(TopRatedMoviesPage), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
  });
}
