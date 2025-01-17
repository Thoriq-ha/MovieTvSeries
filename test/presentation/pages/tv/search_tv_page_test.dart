import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/presentation/bloc/tv/search_tv_bloc.dart';
import 'package:movietvseries/presentation/pages/tv/home_tv_page.dart';
import 'package:movietvseries/presentation/pages/tv/search_tv_page.dart';
import 'package:movietvseries/injection.dart' as di;
import 'package:movietvseries/presentation/widgets/tv_card_list.dart';
import 'package:movietvseries/routes/my_router.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'search_tv_page_test.mocks.dart';

class SearchTVIsUnhandledState extends SearchTVState {
  @override
  List<Object> get props => [];
}

@GenerateMocks([SearchTVBloc])
void main() {
  late MockSearchTVBloc mockSearchTVBloc;

  setUp(() async {
    await di.init();
    await dotenv.load(fileName: ".env");

    mockSearchTVBloc = MockSearchTVBloc();

    if (di.locator.isRegistered<SearchTVBloc>()) {
      di.locator.unregister<SearchTVBloc>();
    }

    di.locator.registerLazySingleton<SearchTVBloc>(() => mockSearchTVBloc);
  });

  tearDown(() {
    di.locator.reset();
  });

  group('Search Tv Page', () {
    testWidgets('SearchTvPage renders correctly with Search Tv',
        (WidgetTester tester) async {
      when(mockSearchTVBloc.state).thenReturn(SearchTVIsLoaded(testTvList));
      when(mockSearchTVBloc.stream)
          .thenAnswer((_) => Stream.value(SearchTVIsLoaded(testTvList)));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(
                  initialLocation:
                      HomeTvPage.routeName + SearchTvPage.routeName)
              .router,
        ),
      );
      expect(find.byType(TvCard), findsWidgets);
    });

    testWidgets('SearchTvPage shows loading spinner while fetching tvs',
        (WidgetTester tester) async {
      when(mockSearchTVBloc.state).thenReturn(SearchTVIsLoading());

      when(mockSearchTVBloc.stream)
          .thenAnswer((_) => Stream.value(SearchTVIsLoading()));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(
                  initialLocation:
                      HomeTvPage.routeName + SearchTvPage.routeName)
              .router,
        ),
      );
      // Verify if loading indicators are present
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('SearchTvPage displays error messages if tvs fail to load',
        (WidgetTester tester) async {
      const errorMessage = 'Something went wrong';
      when(mockSearchTVBloc.state).thenReturn(SearchTVIsError(errorMessage));

      when(mockSearchTVBloc.stream)
          .thenAnswer((_) => Stream.value(SearchTVIsError(errorMessage)));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(
                  initialLocation:
                      HomeTvPage.routeName + SearchTvPage.routeName)
              .router,
        ),
      );
      // Verify if loading indicators are present
      expect(find.text(errorMessage), findsWidgets);
    });

    testWidgets('SearchTvPage renders correctly with default state',
        (WidgetTester tester) async {
      when(mockSearchTVBloc.state).thenReturn(SearchTVIsUnhandledState());

      when(mockSearchTVBloc.stream)
          .thenAnswer((_) => Stream.value(SearchTVIsUnhandledState()));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(
                  initialLocation:
                      HomeTvPage.routeName + SearchTvPage.routeName)
              .router,
        ),
      );
      // Verify if default state is displayed
      expect(find.byType(Container), findsWidgets);
    });
  });

  testWidgets('Triggers search when query is submitted',
      (WidgetTester tester) async {
    when(mockSearchTVBloc.state).thenReturn(SearchTVIsUnhandledState());

    when(mockSearchTVBloc.stream)
        .thenAnswer((_) => Stream.value(SearchTVIsUnhandledState()));

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: MyRouter(
                initialLocation: HomeTvPage.routeName + SearchTvPage.routeName)
            .router,
      ),
    );
    const testQuery = 'Spiderman';

    await tester.enterText(find.byType(TextField), testQuery);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    verify(mockSearchTVBloc.add(argThat(
            isA<FetchSearchTV>().having((e) => e.query, 'query', testQuery))))
        .called(1);
  });
}
