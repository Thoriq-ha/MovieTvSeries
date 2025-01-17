import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/presentation/bloc/tv/now_playing_tv_bloc.dart';
import 'package:movietvseries/presentation/pages/tv/home_tv_page.dart';
import 'package:movietvseries/presentation/pages/tv/now_playing_tv_page.dart';
import 'package:movietvseries/injection.dart' as di;
import 'package:movietvseries/presentation/widgets/tv_card_list.dart';
import 'package:movietvseries/routes/my_router.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'home_tv_page_test.dart';
import 'home_tv_page_test.mocks.dart';

void main() {
  late MockNowPlayingTVBloc mockNowPlayingTVBloc;

  setUp(() async {
    await di.init();
    await dotenv.load(fileName: ".env");

    mockNowPlayingTVBloc = MockNowPlayingTVBloc();

    if (di.locator.isRegistered<NowPlayingTVBloc>()) {
      di.locator.unregister<NowPlayingTVBloc>();
    }

    di.locator
        .registerLazySingleton<NowPlayingTVBloc>(() => mockNowPlayingTVBloc);
  });

  tearDown(() {
    di.locator.reset();
  });

  group('NowPlaying Tv Page', () {
    testWidgets('NowPlayingTVPage renders correctly with NowPlaying Tv',
        (WidgetTester tester) async {
      when(mockNowPlayingTVBloc.state)
          .thenReturn(NowPlayingTVIsLoaded(testTvList));
      when(mockNowPlayingTVBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingTVIsLoaded(testTvList)));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(
                  initialLocation:
                      HomeTvPage.routeName + NowPlayingTvPage.routeName)
              .router,
        ),
      );

      expect(find.byType(TvCard), findsWidgets);
    });

    testWidgets('NowPlayingTVPage shows loading spinner while fetching tvs',
        (WidgetTester tester) async {
      when(mockNowPlayingTVBloc.state).thenReturn(NowPlayingTVIsLoading());

      when(mockNowPlayingTVBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingTVIsLoading()));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(
                  initialLocation:
                      HomeTvPage.routeName + NowPlayingTvPage.routeName)
              .router,
        ),
      );
      // Verify if loading indicators are present
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('NowPlayingTVPage displays error messages if tvs fail to load',
        (WidgetTester tester) async {
      const errorMessage = 'Something went wrong';
      when(mockNowPlayingTVBloc.state)
          .thenReturn(NowPlayingTVIsError(errorMessage));

      when(mockNowPlayingTVBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingTVIsError(errorMessage)));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(
                  initialLocation:
                      HomeTvPage.routeName + NowPlayingTvPage.routeName)
              .router,
        ),
      );
      // Verify if loading indicators are present
      expect(find.text(errorMessage), findsWidgets);
    });

    testWidgets('NowPlayingTVPage renders correctly with default state',
        (WidgetTester tester) async {
      when(mockNowPlayingTVBloc.state)
          .thenReturn(NowPlayingTVIsUnhandledState());

      when(mockNowPlayingTVBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingTVIsUnhandledState()));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(
                  initialLocation:
                      HomeTvPage.routeName + NowPlayingTvPage.routeName)
              .router,
        ),
      );
      // Verify if default state is displayed
      expect(find.byType(Container), findsWidgets);
    });
  });
}
