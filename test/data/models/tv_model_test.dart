import 'package:movietvseries/data/models/tv_model.dart';
import 'package:movietvseries/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvModel = TvModel(
    backdropPath: "backdropPath",
    firstAirDate: "firstAirDate",
    genreIds: [1, 2, 3],
    id: 1,
    name: "name",
    originCountry: ["originCountry1", "originCountry1", "originCountry1"],
    originalLanguage: "originalLanguage",
    originalName: "originalName",
    overview: "overview",
    popularity: 1.0,
    posterPath: "posterPath",
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTv = Tv(
    backdropPath: "backdropPath",
    firstAirDate: "firstAirDate",
    genreIds: [1, 2, 3],
    id: 1,
    name: "name",
    originCountry: ["originCountry1", "originCountry1", "originCountry1"],
    originalLanguage: "originalLanguage",
    originalName: "originalName",
    overview: "overview",
    popularity: 1.0,
    posterPath: "posterPath",
    voteAverage: 1.0,
    voteCount: 1,
  );

  test('should be a subclass of Tv entity', () async {
    final result = tTvModel.toEntity();
    expect(result, tTv);
  });
}
