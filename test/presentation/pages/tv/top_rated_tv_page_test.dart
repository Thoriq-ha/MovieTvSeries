import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:movietvseries/injection.dart' as di;
import 'package:movietvseries/presentation/pages/tv/home_tv_page.dart';
import 'package:movietvseries/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:movietvseries/presentation/widgets/tv_card_list.dart';
import 'package:movietvseries/routes/my_router.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'home_tv_page_test.dart';
import 'home_tv_page_test.mocks.dart';

void main() {
  late MockTopRatedTVBloc mockTopRatedTVBloc;

  setUp(() async {
    await di.init();
    await dotenv.load(fileName: ".env");

    mockTopRatedTVBloc = MockTopRatedTVBloc();

    if (di.locator.isRegistered<TopRatedTVBloc>()) {
      di.locator.unregister<TopRatedTVBloc>();
    }

    di.locator.registerLazySingleton<TopRatedTVBloc>(() => mockTopRatedTVBloc);
  });

  tearDown(() {
    di.locator.reset();
  });

  group('TopRated Tv Page', () {
    testWidgets('TopRatedTVPage renders correctly with TopRated Tv',
        (WidgetTester tester) async {
      when(mockTopRatedTVBloc.state).thenReturn(TopRatedTVIsLoaded(testTvList));
      when(mockTopRatedTVBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedTVIsLoaded(testTvList)));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(
                  initialLocation:
                      HomeTvPage.routeName + TopRatedTvPage.routeName)
              .router,
        ),
      );
      expect(find.byType(TvCard), findsWidgets);
    });

    testWidgets('TopRatedTVPage shows loading spinner while fetching tvs',
        (WidgetTester tester) async {
      when(mockTopRatedTVBloc.state).thenReturn(TopRatedTVIsLoading());

      when(mockTopRatedTVBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedTVIsLoading()));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(
                  initialLocation:
                      HomeTvPage.routeName + TopRatedTvPage.routeName)
              .router,
        ),
      );
      // Verify if loading indicators are present
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('TopRatedTVPage displays error messages if tvs fail to load',
        (WidgetTester tester) async {
      const errorMessage = 'Something went wrong';
      when(mockTopRatedTVBloc.state)
          .thenReturn(TopRatedTVIsError(errorMessage));

      when(mockTopRatedTVBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedTVIsError(errorMessage)));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(
                  initialLocation:
                      HomeTvPage.routeName + TopRatedTvPage.routeName)
              .router,
        ),
      );
      // Verify if loading indicators are present
      expect(find.text(errorMessage), findsWidgets);
    });

    testWidgets('TopRatedTVPage renders correctly with default state',
        (WidgetTester tester) async {
      when(mockTopRatedTVBloc.state).thenReturn(TopRatedTVIsUnhandledState());

      when(mockTopRatedTVBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedTVIsUnhandledState()));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(
                  initialLocation:
                      HomeTvPage.routeName + TopRatedTvPage.routeName)
              .router,
        ),
      );
      // Verify if default state is displayed
      expect(find.byType(Container), findsWidgets);
    });
  });
}
