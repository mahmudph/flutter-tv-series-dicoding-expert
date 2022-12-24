import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/domain/usecases/get_watchlist_status.dart';

import '../../mocks/mocks.dart';

void main() {
  late GetWatchListStatus usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetWatchListStatus(mockMovieRepository);
  });

  test(
    'should get watchlist status from repository',
    () async {
      // arrange
      when(() => mockMovieRepository.isAddedToWatchlist(1)).thenAnswer(
        (_) async => true,
      );
      // act
      final result = await usecase.execute(1);
      // assert
      expect(result, true);
    },
  );
}
