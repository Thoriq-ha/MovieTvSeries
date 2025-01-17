import 'package:dartz/dartz.dart';
import 'package:movietvseries/domain/usecases/remove_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTv usecase;
  late MockTvRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockTvRepository();
    usecase = RemoveWatchlistTv(mockMovieRepository);
  });

  test('should remove watchlist tv from repository', () async {
    // arrange
    when(mockMovieRepository.removeWatchlistTv(testTvDetail))
        .thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testTvDetail);
    // assert
    verify(mockMovieRepository.removeWatchlistTv(testTvDetail));
    expect(result, Right('Removed from watchlist'));
  });
}
