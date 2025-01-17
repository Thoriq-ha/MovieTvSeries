import 'dart:convert';

import 'package:movietvseries/data/models/tv_model.dart';
import 'package:movietvseries/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
      backdropPath: "/path.jpg",
      firstAirDate: "2020-11-02",
      genreIds: [1, 2, 3],
      id: 1,
      name: "Name",
      originCountry: [
        "origin_country 1",
        "origin_country 2",
        "origin_country 3"
      ],
      originalLanguage: "Original Language",
      originalName: "Original Name",
      overview: "Overview",
      popularity: 1.0,
      posterPath: "/path.jpg",
      voteAverage: 1.0,
      voteCount: 1);
  final tTvResponseModel = TvResponse(tvList: <TvModel>[tTvModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_now_playing.json'));
      // act
      final result = TvResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/path.jpg",
            "first_air_date": "2020-11-02",
            "genre_ids": [1, 2, 3],
            "id": 1,
            "name": "Name",
            "origin_country": [
              "origin_country 1",
              "origin_country 2",
              "origin_country 3"
            ],
            "original_language": "Original Language",
            "original_name": "Original Name",
            "overview": "Overview",
            "popularity": 1.0,
            "poster_path": "/path.jpg",
            "vote_average": 1.0,
            "vote_count": 1
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
