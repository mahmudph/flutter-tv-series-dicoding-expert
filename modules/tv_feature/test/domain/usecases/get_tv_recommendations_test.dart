import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/domain/usecases/get_tv_recommendations.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../mocks/data_mock.dart';

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
      when(() => mockTvRepository.getTvRecommendations(theId)).thenAnswer(
        (_) async => Right(testTvList),
      );
      final result = await getRecomentations.execute(theId);

      verify(() => mockTvRepository.getTvRecommendations(theId));
      expect(result, Right(testTvList));
    },
  );
}
