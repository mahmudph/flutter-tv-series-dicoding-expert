import 'package:bloc_test/bloc_test.dart';
import 'package:core/commons/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/movie_feature.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetMovieDetail extends Mock implements GetMovieDetail {}

void main() {
  late MockGetMovieDetail getMovieDetail;
  late MovieDetailCubit movieDetailCubit;

  const theId = 1;

  setUp(() {
    getMovieDetail = MockGetMovieDetail();
    movieDetailCubit = MovieDetailCubit(movieDetail: getMovieDetail);
  });

  tearDown(() {
    movieDetailCubit.close();
  });

  group(
    'test movie detail',
    () {
      blocTest(
        'should get movie detail with success and emit state MovieDetailSuccess',
        build: () => movieDetailCubit,
        setUp: () => when(
          () => getMovieDetail.execute(theId),
        ).thenAnswer(
          (_) async => const Right(testMovieDetail),
        ),
        act: (cubit) => cubit.loadMovieDetail(theId),
        verify: (cubit) => verify(
          () => getMovieDetail.execute(theId),
        ).called(1),
        expect: () => [
          MovieDetailLoading(),
          const MovieDetailSuccess(movieDetail: testMovieDetail),
        ],
      );

      blocTest(
        'should get movie detail with failure and emit state ',
        build: () => movieDetailCubit,
        setUp: () => when(
          () => getMovieDetail.execute(theId),
        ).thenAnswer(
          (_) async => const Left(
            ConnectionFailure('data detail not found'),
          ),
        ),
        act: (cubit) => cubit.loadMovieDetail(theId),
        verify: (cubit) => verify(
          () => getMovieDetail.execute(theId),
        ).called(1),
        expect: () => [
          MovieDetailLoading(),
          const MovieDetailFailure(message: 'data detail not found'),
        ],
      );
    },
  );
}
