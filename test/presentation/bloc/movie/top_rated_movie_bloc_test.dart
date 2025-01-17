import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/usecases/get_top_rated_movies.dart';
import 'package:movietvseries/presentation/bloc/movie/top_rated_movie_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_movie_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMoviesBloc bloc;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    bloc = TopRatedMoviesBloc(
      mockGetTopRatedMovies,
    );
  });

  const tMessage = 'Success';

  group('WatchListMovieEvent Equality Test', () {
    test('FetchTopRatedMovies props should include id', () {
      final event1 = FetchTopRatedMovies();
      final event2 = FetchTopRatedMovies();

      expect(event1, equals(event2)); // Should be true
    });
  });

  group('FetchTopRatedMovies', () {
    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'emits [TopRatedMovieIsLoading, TopRatedMovieIsLoaded] when data is fetched successfully',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        TopRatedMovieIsLoading(),
        TopRatedMovieIsLoaded(testMovieList),
      ],
      verify: (_) {
        verify(mockGetTopRatedMovies.execute());
      },
    );

    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'emits [TopRatedMovieIsLoading, TopRatedMovieIsError] when fetching fails',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure(tMessage)));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        TopRatedMovieIsLoading(),
        TopRatedMovieIsError(tMessage),
      ],
      verify: (_) {
        verify(mockGetTopRatedMovies.execute());
      },
    );
  });
}
