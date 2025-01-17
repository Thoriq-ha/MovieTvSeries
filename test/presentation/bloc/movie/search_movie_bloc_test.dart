import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/usecases/search_movies.dart';
import 'package:movietvseries/presentation/bloc/movie/search_movie_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'search_movie_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MockSearchMovies mockSearchMovies;
  late SearchMovieBloc bloc;
  const testQuery = 'Spiderman';

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    bloc = SearchMovieBloc(mockSearchMovies);
  });

  const tMessage = 'Success';

  group('WatchListMovieEvent Equality Test', () {
    test('FetchSearchMovie props should include id', () {
      final event1 = FetchSearchMovie(query: testQuery);
      final event2 = FetchSearchMovie(query: testQuery);
      final event3 = FetchSearchMovie();

      expect(event1, equals(event2)); // Should be true
      expect(event1, isNot(event3)); // Should be true
    });
  });

  group('FetchSearchMovie', () {
    blocTest<SearchMovieBloc, SearchMovieState>(
      'emits [SearchMovieIsLoading, SearchMovieIsLoaded] when data is fetched successfully',
      build: () {
        when(mockSearchMovies.execute(testQuery))
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchSearchMovie(query: testQuery)),
      expect: () => [
        SearchMovieIsLoading(),
        SearchMovieIsLoaded(testMovieList),
      ],
      verify: (_) {
        verify(mockSearchMovies.execute(testQuery));
      },
    );

    blocTest<SearchMovieBloc, SearchMovieState>(
      'emits [SearchMovieIsLoading, SearchMovieIsEmpty] when data is fetched successfully but empty',
      build: () => bloc,
      act: (bloc) => bloc.add(FetchSearchMovie()),
      expect: () => [
        SearchMovieIsLoading(),
        SearchMovieIsEmpty('Empty Data'),
      ],
    );

    blocTest<SearchMovieBloc, SearchMovieState>(
      'emits [SearchMovieIsLoading, SearchMovieIsError] when fetching fails',
      build: () {
        when(mockSearchMovies.execute(testQuery))
            .thenAnswer((_) async => Left(ServerFailure(tMessage)));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchSearchMovie(query: testQuery)),
      expect: () => [
        SearchMovieIsLoading(),
        SearchMovieIsError(tMessage),
      ],
      verify: (_) {
        verify(mockSearchMovies.execute(testQuery));
      },
    );
  });
}
