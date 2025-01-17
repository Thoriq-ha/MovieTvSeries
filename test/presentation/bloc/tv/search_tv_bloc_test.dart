import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/usecases/search_tv.dart';
import 'package:movietvseries/presentation/bloc/tv/search_tv_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'search_tv_bloc_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late MockSearchTv mockSearchTV;
  late SearchTVBloc bloc;
  const testQuery = 'Spiderman';

  setUp(() {
    mockSearchTV = MockSearchTv();
    bloc = SearchTVBloc(mockSearchTV);
  });

  const tMessage = 'Success';

  group('WatchListMovieEvent Equality Test', () {
    test('FetchSearchTV props should include id', () {
      final event1 = FetchSearchTV(query: testQuery);
      final event2 = FetchSearchTV(query: testQuery);
      final event3 = FetchSearchTV();

      expect(event1, equals(event2)); // Should be true
      expect(event1, isNot(event3)); // Should be true
    });
  });

  group('FetchSearchTV', () {
    blocTest<SearchTVBloc, SearchTVState>(
      'emits [SearchTVIsLoading, SearchTVIsLoaded] when data is fetched successfully',
      build: () {
        when(mockSearchTV.execute(testQuery))
            .thenAnswer((_) async => Right(testTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchSearchTV(query: testQuery)),
      expect: () => [
        SearchTVIsLoading(),
        SearchTVIsLoaded(testTvList),
      ],
      verify: (_) {
        verify(mockSearchTV.execute(testQuery));
      },
    );

    blocTest<SearchTVBloc, SearchTVState>(
      'emits [SearchTVIsLoading, SearchTVIsEmpty] when data is fetched successfully but empty',
      build: () => bloc,
      act: (bloc) => bloc.add(FetchSearchTV()),
      expect: () => [
        SearchTVIsLoading(),
        SearchTVIsEmpty('Empty Data'),
      ],
    );

    blocTest<SearchTVBloc, SearchTVState>(
      'emits [SearchTVIsLoading, SearchTVIsError] when fetching fails',
      build: () {
        when(mockSearchTV.execute(testQuery))
            .thenAnswer((_) async => Left(ServerFailure(tMessage)));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchSearchTV(query: testQuery)),
      expect: () => [
        SearchTVIsLoading(),
        SearchTVIsError(tMessage),
      ],
      verify: (_) {
        verify(mockSearchTV.execute(testQuery));
      },
    );
  });
}
