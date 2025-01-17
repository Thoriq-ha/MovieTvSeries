import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movietvseries/common/constants.dart';
import 'package:movietvseries/domain/entities/genre.dart';
import 'package:movietvseries/domain/entities/movie_detail.dart';
import 'package:movietvseries/injection.dart';
import 'package:movietvseries/presentation/bloc/movie/detail_movie_bloc.dart';
import 'package:movietvseries/presentation/bloc/movie/recomendations_movie_bloc.dart';
import 'package:movietvseries/presentation/bloc/watchlist/watchlist_movie_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieDetailPage extends StatelessWidget {
  static const routeName = '/detail';
  final int id;
  const MovieDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailMovieBloc, DetailMovieState>(
          bloc: locator.get<DetailMovieBloc>()..add(FetchDetailMovie(id)),
          builder: (context, state) {
            if (state is DetailMovieIsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DetailMovieIsError) {
              return Text(state.message);
            } else if (state is DetailMovieIsLoaded) {
              return SafeArea(
                child: DetailContent(
                  state.movie,
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;

  const DetailContent(this.movie, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: headlineSmall,
                            ),
                            BlocConsumer<WatchListMovieBloc,
                                    WatchListMovieState>(
                                listener: (context, state) {
                                  if (state is WatchListMovieIsSaved) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.message),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                    locator.get<WatchListMovieBloc>().add(
                                        FetchWatchListMovieStatus(movie.id));
                                  }
                                },
                                bloc: locator.get<WatchListMovieBloc>()
                                  ..add(FetchWatchListMovieStatus(movie.id)),
                                builder: (context, state) {
                                  if (state is WatchListMovieIsLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (state is WatchListMovieIsError) {
                                    return Text(state.message);
                                  } else if (state
                                      is WatchListMovieStatusIsLoaded) {
                                    return ElevatedButton(
                                      onPressed: () {
                                        locator.get<WatchListMovieBloc>().add(
                                            UpdateWatchListMovieStatus(movie,
                                                state.isAddedToWatchlist));
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          state.isAddedToWatchlist
                                              ? Icon(Icons.check)
                                              : Icon(Icons.add),
                                          SizedBox(width: 4),
                                          Text('Watchlist'),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                            Text(
                              _showGenres(movie.genres),
                            ),
                            Text(
                              _showDuration(movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: titleLarge,
                            ),
                            Text(
                              movie.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: titleLarge,
                            ),
                            BlocBuilder<MovieRecomendationsBloc,
                                MovieRecomendationsState>(
                              bloc: locator.get<MovieRecomendationsBloc>()
                                ..add(FetchMovieRecomendations(movie.id)),
                              builder: (context, state) {
                                if (state is MovieRecomendationsIsLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state
                                    is MovieRecomendationsIsError) {
                                  return Text(state.message);
                                } else if (state
                                    is MovieRecomendationsIsLoaded) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final movie = state.movies[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              context.pushReplacementNamed(
                                                MovieDetailPage.routeName,
                                                extra: movie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: state.movies.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
