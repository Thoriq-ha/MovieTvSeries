import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movietvseries/common/constants.dart';
import 'package:movietvseries/domain/entities/movie.dart';
import 'package:movietvseries/injection.dart';
import 'package:movietvseries/presentation/bloc/movie/now_playing_movie_bloc.dart';
import 'package:movietvseries/presentation/bloc/movie/popular_movie_bloc.dart';
import 'package:movietvseries/presentation/bloc/movie/top_rated_movie_bloc.dart';
import 'package:movietvseries/presentation/pages/about/about_page.dart';
import 'package:movietvseries/presentation/pages/movie/movie_detail_page.dart';
import 'package:movietvseries/presentation/pages/movie/popular_movies_page.dart';
import 'package:movietvseries/presentation/pages/movie/search_movie_page.dart';
import 'package:movietvseries/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:movietvseries/presentation/pages/tv/home_tv_page.dart';
import 'package:movietvseries/presentation/pages/watchlist/watchlist_page.dart';
import 'package:flutter/material.dart';

class HomeMoviePage extends StatelessWidget {
  static const routeName = '/';

  final GlobalKey<ScaffoldState>? scaffoldKey;
  const HomeMoviePage({super.key, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv_rounded),
              title: Text('TV'),
              onTap: () {
                context.pushNamed(HomeTvPage.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                context.pushNamed(WatchlistPage.routeName);
              },
            ),
            ListTile(
              onTap: () {
                context.pushNamed(AboutPage.routeName);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed(SearchMoviePage.routeName);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: titleLarge,
              ),
              BlocBuilder<NowPlayingMovieBloc, NowPlayingMovieState>(
                  bloc: locator<NowPlayingMovieBloc>()
                    ..add(FetchNowPlayingMovie()),
                  builder: (context, state) {
                    if (state is NowPlayingMovieIsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is NowPlayingMovieIsError) {
                      return Text(state.message);
                    } else if (state is NowPlayingMovieIsLoaded) {
                      return MovieList(state.movies);
                    } else {
                      return Container();
                    }
                  }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () => context.pushNamed(PopularMoviesPage.routeName),
              ),
              BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
                  bloc: locator<PopularMoviesBloc>()..add(FetchPopularMovies()),
                  buildWhen: (previous, current) {
                    return current is PopularMovieIsLoaded;
                  },
                  builder: (context, state) {
                    if (state is PopularMovieIsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is PopularMovieIsError) {
                      return Text(state.message);
                    } else if (state is PopularMovieIsLoaded) {
                      return MovieList(state.movies);
                    } else {
                      return Container();
                    }
                  }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () => context.pushNamed(TopRatedMoviesPage.routeName),
              ),
              BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
                  bloc: locator<TopRatedMoviesBloc>()
                    ..add(FetchTopRatedMovies()),
                  buildWhen: (previous, current) {
                    return current is TopRatedMovieIsLoaded;
                  },
                  builder: (context, state) {
                    if (state is TopRatedMovieIsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TopRatedMovieIsError) {
                      return Text(state.message);
                    } else if (state is TopRatedMovieIsLoaded) {
                      return MovieList(state.movies);
                    } else {
                      return Container();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: titleLarge,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                context.pushNamed(
                  MovieDetailPage.routeName,
                  extra: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
