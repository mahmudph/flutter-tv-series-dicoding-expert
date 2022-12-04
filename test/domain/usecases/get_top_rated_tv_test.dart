import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvRepository mockTvRepository;
  late GetTopRatedTv getTopRatedTv;

  setUp(() {
    mockTvRepository = MockTvRepository();
    getTopRatedTv = GetTopRatedTv(mockTvRepository);
  });

  test(
    'should get data on top rated tv show from the repository',
    () async {
      when(mockTvRepository.getTopRatedTvs()).thenAnswer(
        (_) async => Right(testTvList),
      );
      final result = await getTopRatedTv.execute();

      verify(mockTvRepository.getTopRatedTvs());
      expect(result, Right(testTvList));
    },
  );
}
