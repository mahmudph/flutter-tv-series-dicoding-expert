part of 'tv_session_cubit.dart';

abstract class TvSessionState extends Equatable {
  const TvSessionState();

  @override
  List<Object> get props => [];
}

class TvSessionInitial extends TvSessionState {}

class TvSessionLoading extends TvSessionState {}

class TvSessionSuccess extends TvSessionState {
  final TvSession session;

  const TvSessionSuccess({
    required this.session,
  });

  @override
  List<Object> get props => [session];
}

class TvSessionFailure extends TvSessionState {
  final String message;

  const TvSessionFailure({required this.message});

  @override
  List<Object> get props => [message];
}
