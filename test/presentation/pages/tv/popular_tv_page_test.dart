import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:movietvseries/presentation/pages/tv/home_tv_page.dart';
import 'package:movietvseries/presentation/pages/tv/popular_tv_page.dart';
import 'package:movietvseries/injection.dart' as di;
import 'package:movietvseries/presentation/widgets/tv_card_list.dart';
import 'package:movietvseries/routes/my_router.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'home_tv_page_test.dart';
import 'home_tv_page_test.mocks.dart';

void main() {
  late MockPopularTVBloc mockPopularTVBloc;

  setUp(() async {
    await di.init();
    await dotenv.load(fileName: ".env");

    mockPopularTVBloc = MockPopularTVBloc();

    if (di.locator.isRegistered<PopularTVBloc>()) {
      di.locator.unregister<PopularTVBloc>();
    }

    di.locator.registerLazySingleton<PopularTVBloc>(() => mockPopularTVBloc);
  });

  tearDown(() {
    di.locator.reset();
  });

  group('Popular Tv Page', () {
    testWidgets('PopularTVPage renders correctly with Popular Tv',
        (WidgetTester tester) async {
      when(mockPopularTVBloc.state).thenReturn(PopularTVIsLoaded(testTvList));
      when(mockPopularTVBloc.stream)
          .thenAnswer((_) => Stream.value(PopularTVIsLoaded(testTvList)));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(
                  initialLocation:
                      HomeTvPage.routeName + PopularTvPage.routeName)
              .router,
        ),
      );
      expect(find.byType(TvCard), findsWidgets);
    });

    testWidgets('PopularTVPage shows loading spinner while fetching tvs',
        (WidgetTester tester) async {
      when(mockPopularTVBloc.state).thenReturn(PopularTVIsLoaded(testTvList));
      when(mockPopularTVBloc.stream)
          .thenAnswer((_) => Stream.value(PopularTVIsLoaded(testTvList)));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(
                  initialLocation:
                      HomeTvPage.routeName + PopularTvPage.routeName)
              .router,
        ),
      );
      // Verify if loading indicators are present
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('PopularTVPage displays error messages if tvs fail to load',
        (WidgetTester tester) async {
      const errorMessage = 'Something went wrong';
      when(mockPopularTVBloc.state).thenReturn(PopularTVIsError(errorMessage));

      when(mockPopularTVBloc.stream)
          .thenAnswer((_) => Stream.value(PopularTVIsError(errorMessage)));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(
                  initialLocation:
                      HomeTvPage.routeName + PopularTvPage.routeName)
              .router,
        ),
      );
      // Verify if loading indicators are present
      expect(find.text(errorMessage), findsWidgets);
    });

    testWidgets('PopularTVPage renders correctly with default state',
        (WidgetTester tester) async {
      when(mockPopularTVBloc.state).thenReturn(PopularTVIsUnhandledState());

      when(mockPopularTVBloc.stream)
          .thenAnswer((_) => Stream.value(PopularTVIsUnhandledState()));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(
                  initialLocation:
                      HomeTvPage.routeName + PopularTvPage.routeName)
              .router,
        ),
      );
      // Verify if default state is displayed
      expect(find.byType(Container), findsWidgets);
    });
  });
}
