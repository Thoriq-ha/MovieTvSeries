import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movietvseries/common/constants.dart';
import 'package:movietvseries/domain/entities/genre.dart';
import 'package:movietvseries/domain/entities/tv_detail.dart';
import 'package:movietvseries/injection.dart';
import 'package:movietvseries/presentation/bloc/tv/detail_tv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movietvseries/presentation/bloc/tv/recomendations_tv_bloc.dart';
import 'package:movietvseries/presentation/bloc/watchlist/watchlist_tv_bloc.dart';

class TvDetailPage extends StatelessWidget {
  static const routeName = '/detail_tv';
  final int id;

  const TvDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailTVBloc, DetailTVState>(
          bloc: locator.get<DetailTVBloc>()..add(FetchDetailTV(id)),
          builder: (context, state) {
            if (state is DetailTVIsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DetailTVIsError) {
              return Text(state.message);
            } else if (state is DetailTVIsLoaded) {
              return SafeArea(
                child: DetailContent(
                  state.tv,
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
  final TvDetail tv;

  const DetailContent(this.tv, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
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
                              tv.name ?? "-",
                              style: headlineSmall,
                            ),
                            BlocConsumer<WatchListTVBloc, WatchListTVState>(
                                listener: (context, state) {
                                  if (state is WatchListTVIsSaved) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.message),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                    locator
                                        .get<WatchListTVBloc>()
                                        .add(FetchWatchListTVStatus(tv.id));
                                  }
                                },
                                bloc: locator.get<WatchListTVBloc>()
                                  ..add(FetchWatchListTVStatus(tv.id)),
                                builder: (context, state) {
                                  if (state is WatchListTVIsLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (state is WatchListTVIsError) {
                                    return Text(state.message);
                                  } else if (state
                                      is WatchListTVStatusIsLoaded) {
                                    return ElevatedButton(
                                      onPressed: () {
                                        locator.get<WatchListTVBloc>().add(
                                            UpdateWatchListTVStatus(
                                                tv, state.isAddedToWatchlist));
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
                              _showGenres(tv.genres ?? []),
                            ),
                            Text(
                              _showDuration(0),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage ?? 2 / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: titleLarge,
                            ),
                            Text(
                              tv.overview ?? "-",
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: titleLarge,
                            ),
                            BlocBuilder<TVRecomendationsBloc,
                                TVRecomendationsState>(
                              bloc: locator.get<TVRecomendationsBloc>()
                                ..add(FetchTVRecomendations(tv.id)),
                              builder: (context, state) {
                                if (state is TVRecomendationsIsLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is TVRecomendationsIsError) {
                                  return Text(state.message);
                                } else if (state is TVRecomendationsIsLoaded) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tv = state.tvs[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              context.pushReplacementNamed(
                                                TvDetailPage.routeName,
                                                extra: tv.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${tv.posterPath}',
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
                                      itemCount: state.tvs.length,
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
