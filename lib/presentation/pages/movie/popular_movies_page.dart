import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/injection.dart';
import 'package:movietvseries/presentation/bloc/movie/popular_movie_bloc.dart';
import 'package:movietvseries/presentation/widgets/movie_card_list.dart';

class PopularMoviesPage extends StatelessWidget {
  static const routeName = '/popular-movie';

  const PopularMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
            bloc: locator<PopularMoviesBloc>()..add(FetchPopularMovies()),
            builder: (context, state) {
              if (state is PopularMovieIsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PopularMovieIsError) {
                return Text(state.message);
              } else if (state is PopularMovieIsLoaded) {
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
