import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/domain/usecases/search_tv.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../mocks/data_mock.dart';

void main() {
  late MockTvRepository mockTvRepository;
  late SearchTv searchTv;

  setUp(() {
    mockTvRepository = MockTvRepository();
    searchTv = SearchTv(mockTvRepository);
  });

  const query = 'nikita';

  test(
    'should search data tv by query and return list of the tv show',
    () async {
      when(() => mockTvRepository.searchTvs(query)).thenAnswer(
        (_) async => Right(testTvList),
      );
      final result = await searchTv.execute(query);

      verify(() => mockTvRepository.searchTvs(query));
      expect(result, Right(testTvList));
    },
  );
}
