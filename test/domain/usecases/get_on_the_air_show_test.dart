import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvRepository mockTvRepository;
  late GetOnTheAirTVShows getOnTheAirTVShows;

  setUp(() {
    mockTvRepository = MockTvRepository();
    getOnTheAirTVShows = GetOnTheAirTVShows(mockTvRepository);
  });

  test(
    'should get data on the air tv show from the repository',
    () async {
      when(mockTvRepository.getOnTheAirTVShows()).thenAnswer(
        (_) async => Right(testTvList),
      );
      final result = await getOnTheAirTVShows.execute();

      verify(mockTvRepository.getOnTheAirTVShows());
      expect(result, Right(testTvList));
    },
  );
}
