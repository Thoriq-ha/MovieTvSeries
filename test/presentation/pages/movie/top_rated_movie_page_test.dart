import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/presentation/bloc/movie/top_rated_movie_bloc.dart';
import 'package:movietvseries/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:movietvseries/presentation/widgets/movie_card_list.dart';
import 'package:movietvseries/injection.dart' as di;
import 'package:movietvseries/routes/my_router.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'home_movie_page_test.dart';
import 'home_movie_page_test.mocks.dart';

void main() {
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;

  setUp(() async {
    await di.init();
    await dotenv.load(fileName: ".env");

    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();

    if (di.locator.isRegistered<TopRatedMoviesBloc>()) {
      di.locator.unregister<TopRatedMoviesBloc>();
    }

    di.locator.registerLazySingleton<TopRatedMoviesBloc>(
        () => mockTopRatedMoviesBloc);
  });

  tearDown(() {
    di.locator.reset();
  });

  group('Top Rated Movie Page', () {
    testWidgets('TopRatedMoviePage renders correctly with Top Rated Movie',
        (WidgetTester tester) async {
      when(mockTopRatedMoviesBloc.state)
          .thenReturn(TopRatedMovieIsLoaded(testMovieList));
      when(mockTopRatedMoviesBloc.stream).thenAnswer(
          (_) => Stream.value(TopRatedMovieIsLoaded(testMovieList)));

      await tester.pumpWidget(MaterialApp(
        home: TopRatedMoviesPage(),
      ));
      expect(find.byType(MovieCard), findsWidgets);
    });

    testWidgets('TopRatedMoviePage shows loading spinner while fetching movies',
        (WidgetTester tester) async {
      when(mockTopRatedMoviesBloc.state).thenReturn(TopRatedMovieIsLoading());

      when(mockTopRatedMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedMovieIsLoading()));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig:
              MyRouter(initialLocation: TopRatedMoviesPage.routeName).router,
        ),
      );
      // Verify if loading indicators are present
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets(
        'TopRatedMoviePage displays error messages if movies fail to load',
        (WidgetTester tester) async {
      const errorMessage = 'Something went wrong';
      when(mockTopRatedMoviesBloc.state)
          .thenReturn(TopRatedMovieIsError(errorMessage));

      when(mockTopRatedMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedMovieIsError(errorMessage)));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig:
              MyRouter(initialLocation: TopRatedMoviesPage.routeName).router,
        ),
      );
      // Verify if loading indicators are present
      expect(find.text(errorMessage), findsWidgets);
    });

    testWidgets('TopRatedMoviePage renders correctly with default state',
        (WidgetTester tester) async {
      when(mockTopRatedMoviesBloc.state)
          .thenReturn(TopRatedMovieIsUnhandledState());

      when(mockTopRatedMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedMovieIsUnhandledState()));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig:
              MyRouter(initialLocation: TopRatedMoviesPage.routeName).router,
        ),
      );
      // Verify if default state is displayed
      expect(find.byType(Container), findsWidgets);
    });
  });
}
