import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/presentation/bloc/tv/detail_tv_bloc.dart';
import 'package:movietvseries/presentation/bloc/tv/now_playing_tv_bloc.dart';
import 'package:movietvseries/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:movietvseries/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:movietvseries/injection.dart' as di;
import 'package:movietvseries/presentation/pages/tv/home_tv_page.dart';
import 'package:movietvseries/presentation/pages/tv/now_playing_tv_page.dart';
import 'package:movietvseries/presentation/pages/tv/popular_tv_page.dart';
import 'package:movietvseries/presentation/pages/tv/search_tv_page.dart';
import 'package:movietvseries/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:movietvseries/presentation/pages/tv/tv_detail_page.dart';
import 'package:movietvseries/routes/my_router.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'home_tv_page_test.mocks.dart';

class NowPlayingTVIsUnhandledState extends NowPlayingTVState {
  @override
  List<Object> get props => [];
}

class PopularTVIsUnhandledState extends PopularTVState {
  @override
  List<Object> get props => [];
}

class TopRatedTVIsUnhandledState extends TopRatedTVState {
  @override
  List<Object> get props => [];
}

class DetailTVBlocIsUnhandledState extends DetailTVState {
  @override
  List<Object> get props => [];
}

@GenerateMocks([NowPlayingTVBloc, PopularTVBloc, TopRatedTVBloc])
void main() {
  late MockNowPlayingTVBloc mockNowPlayingTVBloc;
  late MockPopularTVBloc mockPopularTVBloc;
  late MockTopRatedTVBloc mockTopRatedTVBloc;

  setUp(() async {
    await di.init();
    await dotenv.load(fileName: ".env");

    mockNowPlayingTVBloc = MockNowPlayingTVBloc();
    mockPopularTVBloc = MockPopularTVBloc();
    mockTopRatedTVBloc = MockTopRatedTVBloc();

    if (di.locator.isRegistered<NowPlayingTVBloc>()) {
      di.locator.unregister<NowPlayingTVBloc>();
    }
    if (di.locator.isRegistered<PopularTVBloc>()) {
      di.locator.unregister<PopularTVBloc>();
    }
    if (di.locator.isRegistered<TopRatedTVBloc>()) {
      di.locator.unregister<TopRatedTVBloc>();
    }
    if (di.locator.isRegistered<DetailTVBloc>()) {
      di.locator.unregister<DetailTVBloc>();
    }

    di.locator.registerLazySingleton<NowPlayingTVBloc>(
      () => mockNowPlayingTVBloc,
    );
    di.locator.registerLazySingleton<PopularTVBloc>(
      () => mockPopularTVBloc,
    );
    di.locator.registerLazySingleton<TopRatedTVBloc>(
      () => mockTopRatedTVBloc,
    );
  });

  tearDown(() {
    di.locator.reset();
  });

  group('Home TV Page', () {
    testWidgets(
        'HomeTVPage renders correctly with Now Playing TV, Popular TV, and Top Rated TV',
        (WidgetTester tester) async {
      when(mockNowPlayingTVBloc.state)
          .thenReturn(NowPlayingTVIsLoaded(testTvList));
      when(mockPopularTVBloc.state).thenReturn(PopularTVIsLoaded(testTvList));
      when(mockTopRatedTVBloc.state).thenReturn(TopRatedTVIsLoaded(testTvList));

      when(mockNowPlayingTVBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingTVIsLoaded(testTvList)));
      when(mockPopularTVBloc.stream)
          .thenAnswer((_) => Stream.value(PopularTVIsLoaded(testTvList)));
      when(mockTopRatedTVBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedTVIsLoaded(testTvList)));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(initialLocation: HomeTvPage.routeName).router,
        ),
      );
      expect(find.byType(TVList), findsNWidgets(3));
    });

    testWidgets('HomeTVPage shows loading spinner while fetching movies',
        (WidgetTester tester) async {
      when(mockNowPlayingTVBloc.state).thenReturn(NowPlayingTVIsLoading());
      when(mockPopularTVBloc.state).thenReturn(PopularTVIsLoading());
      when(mockTopRatedTVBloc.state).thenReturn(TopRatedTVIsLoading());

      when(mockNowPlayingTVBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingTVIsLoading()));
      when(mockPopularTVBloc.stream)
          .thenAnswer((_) => Stream.value(PopularTVIsLoading()));
      when(mockTopRatedTVBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedTVIsLoading()));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(initialLocation: HomeTvPage.routeName).router,
        ),
      );
      // Verify if loading indicators are present
      expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
    });

    testWidgets('HomeTVPage displays error messages if movies fail to load',
        (WidgetTester tester) async {
      const errorMessage = 'Something went wrong';
      when(mockNowPlayingTVBloc.state)
          .thenReturn(NowPlayingTVIsError(errorMessage));
      when(mockPopularTVBloc.state).thenReturn(PopularTVIsError(errorMessage));
      when(mockTopRatedTVBloc.state)
          .thenReturn(TopRatedTVIsError(errorMessage));

      when(mockNowPlayingTVBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingTVIsError(errorMessage)));
      when(mockPopularTVBloc.stream)
          .thenAnswer((_) => Stream.value(PopularTVIsError(errorMessage)));
      when(mockTopRatedTVBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedTVIsError(errorMessage)));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(initialLocation: HomeTvPage.routeName).router,
        ),
      );
      // Verify if error message is displayed
      expect(find.text(errorMessage), findsNWidgets(3));
    });

    testWidgets('HomeTVPage renders correctly with default state',
        (WidgetTester tester) async {
      when(mockNowPlayingTVBloc.state)
          .thenReturn(NowPlayingTVIsUnhandledState());
      when(mockPopularTVBloc.state).thenReturn(PopularTVIsUnhandledState());
      when(mockTopRatedTVBloc.state).thenReturn(TopRatedTVIsUnhandledState());

      when(mockNowPlayingTVBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingTVIsUnhandledState()));
      when(mockPopularTVBloc.stream)
          .thenAnswer((_) => Stream.value(PopularTVIsUnhandledState()));
      when(mockTopRatedTVBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedTVIsUnhandledState()));

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: MyRouter(initialLocation: HomeTvPage.routeName).router,
        ),
      );
      // Verify if default state is displayed
      expect(find.byType(Container), findsNWidgets(3));
    });
  });

  group('Button and Action', () {
    testWidgets('Search button navigates to Search TV page',
        (WidgetTester tester) async {
      when(mockNowPlayingTVBloc.state)
          .thenReturn(NowPlayingTVIsUnhandledState());
      when(mockPopularTVBloc.state).thenReturn(PopularTVIsUnhandledState());
      when(mockTopRatedTVBloc.state).thenReturn(TopRatedTVIsUnhandledState());

      when(mockNowPlayingTVBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingTVIsUnhandledState()));
      when(mockPopularTVBloc.stream)
          .thenAnswer((_) => Stream.value(PopularTVIsUnhandledState()));
      when(mockTopRatedTVBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedTVIsUnhandledState()));

      final mockGoRouter = GoRouter(
        initialLocation: HomeTvPage.routeName,
        routes: [
          GoRoute(
              path: HomeTvPage.routeName,
              name: HomeTvPage.routeName,
              builder: (context, state) => HomeTvPage(),
              routes: [
                GoRoute(
                  path: SearchTvPage.routeName,
                  name: SearchTvPage.routeName,
                  builder: (context, state) => Scaffold(
                    body: Text('Mock Search TV Page'),
                  ),
                ),
              ]),
        ],
      );
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: mockGoRouter),
      );
      final seeMoreFinder = find.byType(IconButton);

      await tester.tap(seeMoreFinder);
      await tester.pumpAndSettle();
      expect(find.text('Mock Search TV Page'), findsOneWidget);
    });

    testWidgets('See More button navigates to Now Playing TV page',
        (WidgetTester tester) async {
      when(mockNowPlayingTVBloc.state)
          .thenReturn(NowPlayingTVIsUnhandledState());
      when(mockPopularTVBloc.state).thenReturn(PopularTVIsUnhandledState());
      when(mockTopRatedTVBloc.state).thenReturn(TopRatedTVIsUnhandledState());

      when(mockNowPlayingTVBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingTVIsUnhandledState()));
      when(mockPopularTVBloc.stream)
          .thenAnswer((_) => Stream.value(PopularTVIsUnhandledState()));
      when(mockTopRatedTVBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedTVIsUnhandledState()));

      final mockGoRouter = GoRouter(
        initialLocation: HomeTvPage.routeName,
        routes: [
          GoRoute(
              path: HomeTvPage.routeName,
              name: HomeTvPage.routeName,
              builder: (context, state) => HomeTvPage(),
              routes: [
                GoRoute(
                  path: NowPlayingTvPage.routeName,
                  name: NowPlayingTvPage.routeName,
                  builder: (context, state) => Scaffold(
                    body: Text('Mock Now Playing TV Page'),
                  ),
                ),
              ]),
        ],
      );
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: mockGoRouter),
      );
      final seeMoreFinder = find.text('See More');

      await tester.tap(seeMoreFinder.at(0));
      await tester.pumpAndSettle();
      expect(find.text('Mock Now Playing TV Page'), findsOneWidget);
    });

    testWidgets('See More button navigates to Popular TV page',
        (WidgetTester tester) async {
      when(mockNowPlayingTVBloc.state)
          .thenReturn(NowPlayingTVIsUnhandledState());
      when(mockPopularTVBloc.state).thenReturn(PopularTVIsUnhandledState());
      when(mockTopRatedTVBloc.state).thenReturn(TopRatedTVIsUnhandledState());

      when(mockNowPlayingTVBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingTVIsUnhandledState()));
      when(mockPopularTVBloc.stream)
          .thenAnswer((_) => Stream.value(PopularTVIsUnhandledState()));
      when(mockTopRatedTVBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedTVIsUnhandledState()));

      final mockGoRouter = GoRouter(
        initialLocation: HomeTvPage.routeName,
        routes: [
          GoRoute(
              path: HomeTvPage.routeName,
              name: HomeTvPage.routeName,
              builder: (context, state) => HomeTvPage(),
              routes: [
                GoRoute(
                  path: PopularTvPage.routeName,
                  name: PopularTvPage.routeName,
                  builder: (context, state) => Scaffold(
                    body: Text('Mock Popular TV Page'),
                  ),
                ),
              ]),
        ],
      );
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: mockGoRouter),
      );
      final seeMoreFinder = find.text('See More');

      await tester.tap(seeMoreFinder.at(1));
      await tester.pumpAndSettle();
      expect(find.text('Mock Popular TV Page'), findsOneWidget);
    });

    testWidgets('See More button navigates to Top Rated TV page',
        (WidgetTester tester) async {
      when(mockNowPlayingTVBloc.state)
          .thenReturn(NowPlayingTVIsUnhandledState());
      when(mockPopularTVBloc.state).thenReturn(PopularTVIsUnhandledState());
      when(mockTopRatedTVBloc.state).thenReturn(TopRatedTVIsUnhandledState());

      when(mockNowPlayingTVBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingTVIsUnhandledState()));
      when(mockPopularTVBloc.stream)
          .thenAnswer((_) => Stream.value(PopularTVIsUnhandledState()));
      when(mockTopRatedTVBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedTVIsUnhandledState()));

      final mockGoRouter = GoRouter(
        initialLocation: HomeTvPage.routeName,
        routes: [
          GoRoute(
              path: HomeTvPage.routeName,
              name: HomeTvPage.routeName,
              builder: (context, state) => HomeTvPage(),
              routes: [
                GoRoute(
                  path: TopRatedTvPage.routeName,
                  name: TopRatedTvPage.routeName,
                  builder: (context, state) => Scaffold(
                    body: Text('Mock Top Rated TV Page'),
                  ),
                ),
              ]),
        ],
      );
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: mockGoRouter),
      );
      final seeMoreFinder = find.text('See More');

      await tester.tap(seeMoreFinder.at(2));
      await tester.pumpAndSettle();
      expect(find.text('Mock Top Rated TV Page'), findsOneWidget);
    });
  });

  testWidgets('TVList handles tap on a TV item correctly',
      (WidgetTester tester) async {
    final goRouter = GoRouter(
      initialLocation: HomeTvPage.routeName,
      routes: [
        GoRoute(
            path: HomeTvPage.routeName,
            name: HomeTvPage.routeName,
            builder: (context, state) => Scaffold(body: TVList(testTvList)),
            routes: [
              GoRoute(
                path: TvDetailPage.routeName,
                name: TvDetailPage.routeName,
                builder: (context, state) => Scaffold(
                  body: Text('Mock TvDetailPage'),
                ),
              ),
            ]),
      ],
    );
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: goRouter,
      ),
    );

    // Tap on the first TV item
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    // Verify navigation
    expect(find.text('Mock TvDetailPage'), findsOneWidget);
  });
}
