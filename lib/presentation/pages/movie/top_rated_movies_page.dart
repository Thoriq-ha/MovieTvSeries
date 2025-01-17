import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/injection.dart';
import 'package:movietvseries/presentation/bloc/movie/top_rated_movie_bloc.dart';
import 'package:movietvseries/presentation/widgets/movie_card_list.dart';

class TopRatedMoviesPage extends StatelessWidget {
  static const routeName = '/top-rated-movie';

  const TopRatedMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
            bloc: locator<TopRatedMoviesBloc>()..add(FetchTopRatedMovies()),
            builder: (context, state) {
              if (state is TopRatedMovieIsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TopRatedMovieIsError) {
                return Text(state.message);
              } else if (state is TopRatedMovieIsLoaded) {
                return ListView.builder(
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
      ),
    );
  }
}
