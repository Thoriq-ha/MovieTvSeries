import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/common/constants.dart';
import 'package:movietvseries/injection.dart';
import 'package:movietvseries/presentation/bloc/watchlist/watchlist_movie_bloc.dart';
import 'package:movietvseries/presentation/bloc/watchlist/watchlist_tv_bloc.dart';
import 'package:movietvseries/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:movietvseries/presentation/widgets/tv_card_list.dart';

class WatchlistPage extends StatelessWidget {
  static const routeName = '/watchlist-movie';

  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Movie",
                style: titleLarge,
              ),
              BlocBuilder<WatchListMovieBloc, WatchListMovieState>(
                  bloc: locator<WatchListMovieBloc>()
                    ..add(FetchWatchListMovies()),
                  builder: (context, state) {
                    if (state is WatchListMovieIsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is WatchListMovieIsError) {
                      return Text(state.message);
                    } else if (state is WatchListMovieIsLoaded) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final movie = state.movies[index];
                          return MovieCard(movie);
                        },
                        itemCount: state.movies.length,
                      );
                    } else {
                      return Container();
                    }
                  }),
              SizedBox(
                height: 32,
              ),
              Text(
                "Tv",
                style: titleLarge,
              ),
              BlocBuilder<WatchListTVBloc, WatchListTVState>(
                  bloc: locator<WatchListTVBloc>()..add(FetchWatchListTVs()),
                  builder: (context, state) {
                    if (state is WatchListTVIsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is WatchListTVIsError) {
                      return Text(state.message);
                    } else if (state is WatchListTVIsLoaded) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final tv = state.tvs[index];
                          return TvCard(tv);
                        },
                        itemCount: state.tvs.length,
                      );
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
}
