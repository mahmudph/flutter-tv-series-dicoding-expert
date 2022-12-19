part of 'tv_details_cubit.dart';

abstract class TvDetailsState extends Equatable {
  const TvDetailsState();

  @override
  List<Object?> get props => [];
}


class TvDetailsInitial extends TvDetailsState {}

class TvDetailsLoading extends TvDetailsState {}

class TvDetailsSuccess extends TvDetailsState {
  final TvDetail tvDetail;

  const TvDetailsSuccess({
    required this.tvDetail,
  });

  @override
  List<Object?> get props => [tvDetail];
}

class TvDetailsFailure extends TvDetailsState {
  final String message;

  const TvDetailsFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
