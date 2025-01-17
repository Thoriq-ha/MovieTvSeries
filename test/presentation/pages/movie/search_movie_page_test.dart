import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/presentation/bloc/movie/search_movie_bloc.dart';
import 'package:movietvseries/presentation/pages/movie/search_movie_page.dart';
import 'package:movietvseries/presentation/widgets/movie_card_list.dart';
import 'package:movietvseries/injection.dart' as di;
import 'package:movietvseries/routes/my_router.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'search_movie_page_test.mocks.dart';

class SearchMovieIsUnhandledState extends SearchMovieState {
  @override
  List<Object> get props => [];
}

@GenerateMocks([SearchMovieBloc])
void main() {
  late MockSearchMovieBloc mockSearchMovieBloc;

  setUp(() async {
    await di.init();
    await dotenv.load(fileName: ".env");

    mockSearchMovieBloc = MockSearchMovieBloc();

    if (di.locator.isRegistered<SearchMovieBloc>()) {
      di.locator.unregister<SearchMovieBloc>();
    }

    di.locator
        .registerLazySingleton<SearchMovieBloc>(() => mockSearchMovieBloc);
  });

  tearDown(() {
    di.locator.reset();
  });

  group('Search Movie Page', () {
    testWidgets('SearchMoviePage renders correctly with Search Movie',
        (WidgetTester tester) async {
      when(mockSearchMovieBloc.state)
          .thenReturn(SearchMovieIsLoaded(testMovieList));
      when(mockSearchMovieBloc.stream)
          .thenAnswer((_) => Stream.value(SearchMovieIsLoaded(testMovieList)));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig:
              MyRouter(initialLocation: SearchMoviePage.routeName).router,
        ),
      );
      expect(find.byType(MovieCard), findsWidgets);
    });

    testWidgets('SearchMoviePage shows loading spinner while fetching movies',
        (WidgetTester tester) async {
      when(mockSearchMovieBloc.state).thenReturn(SearchMovieIsLoading());

      when(mockSearchMovieBloc.stream)
          .thenAnswer((_) => Stream.value(SearchMovieIsLoading()));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig:
              MyRouter(initialLocation: SearchMoviePage.routeName).router,
        ),
      );
      // Verify if loading indicators are present
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets(
        'SearchMoviePage displays error messages if movies fail to load',
        (WidgetTester tester) async {
      const errorMessage = 'Something went wrong';
      when(mockSearchMovieBloc.state)
          .thenReturn(SearchMovieIsError(errorMessage));

      when(mockSearchMovieBloc.stream)
          .thenAnswer((_) => Stream.value(SearchMovieIsError(errorMessage)));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig:
              MyRouter(initialLocation: SearchMoviePage.routeName).router,
        ),
      );
      // Verify if loading indicators are present
      expect(find.text(errorMessage), findsWidgets);
    });

    testWidgets('SearchMoviePage renders correctly with default state',
        (WidgetTester tester) async {
      when(mockSearchMovieBloc.state).thenReturn(SearchMovieIsUnhandledState());

      when(mockSearchMovieBloc.stream)
          .thenAnswer((_) => Stream.value(SearchMovieIsUnhandledState()));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig:
              MyRouter(initialLocation: SearchMoviePage.routeName).router,
        ),
      );
      // Verify if default state is displayed
      expect(find.byType(Container), findsWidgets);
    });
  });

  testWidgets('Triggers search when query is submitted',
      (WidgetTester tester) async {
    when(mockSearchMovieBloc.state).thenReturn(SearchMovieIsUnhandledState());

    when(mockSearchMovieBloc.stream)
        .thenAnswer((_) => Stream.value(SearchMovieIsUnhandledState()));

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig:
            MyRouter(initialLocation: SearchMoviePage.routeName).router,
      ),
    );
    const testQuery = 'Spiderman';

    await tester.enterText(find.byType(TextField), testQuery);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    verify(mockSearchMovieBloc.add(argThat(isA<FetchSearchMovie>()
            .having((e) => e.query, 'query', testQuery))))
        .called(1);
  });
}
