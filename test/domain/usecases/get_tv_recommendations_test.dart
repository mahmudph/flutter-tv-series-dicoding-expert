import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvRepository mockTvRepository;
  late GetTvRecommendations getRecomentations;

  setUp(() {
    mockTvRepository = MockTvRepository();
    getRecomentations = GetTvRecommendations(mockTvRepository);
  });

  final theId = 1;

  test(
    'should get data on recomendations tv show from the repository',
    () async {
      when(mockTvRepository.getTvRecommendations(theId)).thenAnswer(
        (_) async => Right(testTvList),
      );
      final result = await getRecomentations.execute(theId);

      verify(mockTvRepository.getTvRecommendations(theId));
      expect(result, Right(testTvList));
    },
  );
}
