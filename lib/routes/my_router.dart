import 'package:go_router/go_router.dart';
import 'package:movietvseries/presentation/pages/about/about_page.dart';
import 'package:movietvseries/presentation/pages/movie/home_movie_page.dart';
import 'package:movietvseries/presentation/pages/movie/movie_detail_page.dart';
import 'package:movietvseries/presentation/pages/movie/popular_movies_page.dart';
import 'package:movietvseries/presentation/pages/movie/search_movie_page.dart';
import 'package:movietvseries/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:movietvseries/presentation/pages/tv/home_tv_page.dart';
import 'package:movietvseries/presentation/pages/tv/now_playing_tv_page.dart';
import 'package:movietvseries/presentation/pages/tv/popular_tv_page.dart';
import 'package:movietvseries/presentation/pages/tv/search_tv_page.dart';
import 'package:movietvseries/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:movietvseries/presentation/pages/tv/tv_detail_page.dart';
import 'package:movietvseries/presentation/pages/watchlist/watchlist_page.dart';

class MyRouter {
  final String initialLocation;
  MyRouter({this.initialLocation = '/'});

  get router => GoRouter(
        initialLocation: initialLocation,
        routes: [
          GoRoute(
            path: "/",
            name: "menu",
            pageBuilder: (context, state) => NoTransitionPage(
              child: HomeMoviePage(),
            ),
            // sub routes
            routes: [
              GoRoute(
                path: MovieDetailPage.routeName,
                name: MovieDetailPage.routeName,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: MovieDetailPage(
                    id: state.extra as int,
                  ),
                ),
              ),
              GoRoute(
                path: SearchMoviePage.routeName,
                name: SearchMoviePage.routeName,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: SearchMoviePage(),
                ),
              ),
              GoRoute(
                path: PopularMoviesPage.routeName,
                name: PopularMoviesPage.routeName,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: PopularMoviesPage(),
                ),
              ),
              GoRoute(
                path: TopRatedMoviesPage.routeName,
                name: TopRatedMoviesPage.routeName,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: TopRatedMoviesPage(),
                ),
              ),
              GoRoute(
                  path: HomeTvPage.routeName,
                  name: HomeTvPage.routeName,
                  pageBuilder: (context, state) => NoTransitionPage(
                        child: HomeTvPage(),
                      ),
                  routes: [
                    GoRoute(
                      path: TvDetailPage.routeName,
                      name: TvDetailPage.routeName,
                      pageBuilder: (context, state) => NoTransitionPage(
                        child: TvDetailPage(
                          id: state.extra as int,
                        ),
                      ),
                    ),
                    GoRoute(
                      path: SearchTvPage.routeName,
                      name: SearchTvPage.routeName,
                      pageBuilder: (context, state) => NoTransitionPage(
                        child: SearchTvPage(),
                      ),
                    ),
                    GoRoute(
                      path: NowPlayingTvPage.routeName,
                      name: NowPlayingTvPage.routeName,
                      pageBuilder: (context, state) => NoTransitionPage(
                        child: NowPlayingTvPage(),
                      ),
                    ),
                    GoRoute(
                      path: PopularTvPage.routeName,
                      name: PopularTvPage.routeName,
                      pageBuilder: (context, state) => NoTransitionPage(
                        child: PopularTvPage(),
                      ),
                    ),
                    GoRoute(
                      path: TopRatedTvPage.routeName,
                      name: TopRatedTvPage.routeName,
                      pageBuilder: (context, state) => NoTransitionPage(
                        child: TopRatedTvPage(),
                      ),
                    ),
                  ]),
              GoRoute(
                path: AboutPage.routeName,
                name: AboutPage.routeName,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: AboutPage(),
                ),
              ),
              GoRoute(
                path: WatchlistPage.routeName,
                name: WatchlistPage.routeName,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: WatchlistPage(),
                ),
              ),
            ],
          ),
        ],
      );
}
