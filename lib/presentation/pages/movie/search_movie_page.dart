import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/common/constants.dart';
import 'package:movietvseries/injection.dart';
import 'package:movietvseries/presentation/bloc/movie/search_movie_bloc.dart';
import 'package:movietvseries/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';

class SearchMoviePage extends StatelessWidget {
  static const routeName = '/search';

  const SearchMoviePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                locator<SearchMovieBloc>().add(FetchSearchMovie(query: query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: titleLarge,
            ),
            BlocBuilder<SearchMovieBloc, SearchMovieState>(
                bloc: locator<SearchMovieBloc>()..add(FetchSearchMovie()),
                builder: (context, state) {
                  if (state is SearchMovieIsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SearchMovieIsError) {
                    return Text(state.message);
                  } else if (state is SearchMovieIsLoaded) {
                    return Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final movie = state.movies[index];
                          return MovieCard(movie);
                        },
                        itemCount: state.movies.length,
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
