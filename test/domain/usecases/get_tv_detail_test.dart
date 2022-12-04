import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvRepository mockTvRepository;
  late GetTvDetail getTvDetail;

  setUp(() {
    mockTvRepository = MockTvRepository();
    getTvDetail = GetTvDetail(mockTvRepository);
  });

  final theId = 1;

  test(
    'should get data on detail tv show from the repository',
    () async {
      when(mockTvRepository.getTvDetail(theId)).thenAnswer(
        (_) async => Right(testTvDetail),
      );
      final result = await getTvDetail.execute(theId);

      verify(mockTvRepository.getTvDetail(theId));
      expect(result, Right(testTvDetail));
    },
  );
}
