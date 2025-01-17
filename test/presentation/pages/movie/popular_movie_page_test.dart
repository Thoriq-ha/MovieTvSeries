import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/presentation/bloc/movie/popular_movie_bloc.dart';
import 'package:movietvseries/presentation/pages/movie/popular_movies_page.dart';
import 'package:movietvseries/presentation/widgets/movie_card_list.dart';
import 'package:movietvseries/injection.dart' as di;
import 'package:movietvseries/routes/my_router.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'home_movie_page_test.dart';
import 'home_movie_page_test.mocks.dart';

void main() {
  late MockPopularMoviesBloc mockPopularMoviesBloc;

  setUp(() async {
    await di.init();
    await dotenv.load(fileName: ".env");

    mockPopularMoviesBloc = MockPopularMoviesBloc();

    if (di.locator.isRegistered<PopularMoviesBloc>()) {
      di.locator.unregister<PopularMoviesBloc>();
    }

    di.locator
        .registerLazySingleton<PopularMoviesBloc>(() => mockPopularMoviesBloc);
  });

  tearDown(() {
    di.locator.reset();
  });

  group('Popular Movie Page', () {
    testWidgets('PopularMoviePage renders correctly with Popular Movie',
        (WidgetTester tester) async {
      when(mockPopularMoviesBloc.state)
          .thenReturn(PopularMovieIsLoaded(testMovieList));
      when(mockPopularMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(PopularMovieIsLoaded(testMovieList)));

      await tester.pumpWidget(MaterialApp(
        home: PopularMoviesPage(),
      ));
      expect(find.byType(MovieCard), findsWidgets);
    });

    testWidgets('PopularMoviePage shows loading spinner while fetching movies',
        (WidgetTester tester) async {
      when(mockPopularMoviesBloc.state).thenReturn(PopularMovieIsLoading());

      when(mockPopularMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(PopularMovieIsLoading()));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig:
              MyRouter(initialLocation: PopularMoviesPage.routeName).router,
        ),
      );
      // Verify if loading indicators are present
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets(
        'PopularMoviePage displays error messages if movies fail to load',
        (WidgetTester tester) async {
      const errorMessage = 'Something went wrong';
      when(mockPopularMoviesBloc.state)
          .thenReturn(PopularMovieIsError(errorMessage));

      when(mockPopularMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(PopularMovieIsError(errorMessage)));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig:
              MyRouter(initialLocation: PopularMoviesPage.routeName).router,
        ),
      );
      // Verify if loading indicators are present
      expect(find.text(errorMessage), findsWidgets);
    });

    testWidgets('PopularMoviePage renders correctly with default state',
        (WidgetTester tester) async {
      when(mockPopularMoviesBloc.state)
          .thenReturn(PopularMovieIsUnhandledState());

      when(mockPopularMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(PopularMovieIsUnhandledState()));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig:
              MyRouter(initialLocation: PopularMoviesPage.routeName).router,
        ),
      );
      // Verify if default state is displayed
      expect(find.byType(Container), findsWidgets);
    });
  });
}
