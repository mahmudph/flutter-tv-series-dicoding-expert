import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/domain/usecases/get_popular_tv.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../mocks/data_mock.dart';

void main() {
  late MockTvRepository mockTvRepository;
  late GetPopularTv getPopularTv;

  setUp(() {
    mockTvRepository = MockTvRepository();
    getPopularTv = GetPopularTv(mockTvRepository);
  });

  test(
    'should get data popular tv show from the repository',
    () async {
      when(() => mockTvRepository.getPopularTvs()).thenAnswer(
        (_) async => Right(testTvList),
      );
      final result = await getPopularTv.execute();

      verify(() => mockTvRepository.getPopularTvs());
      expect(result, Right(testTvList));
    },
  );
}
