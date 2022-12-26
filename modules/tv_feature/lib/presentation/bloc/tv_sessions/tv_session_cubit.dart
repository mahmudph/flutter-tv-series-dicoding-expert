import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_feature/domain/entitas/tv_session.dart';
import 'package:tv_feature/domain/usecases/get_tv_sessions.dart';

part 'tv_session_state.dart';

class TvSessionCubit extends Cubit<TvSessionState> {
  final GetTvSession getTvSession;

  TvSessionCubit({
    required this.getTvSession,
  }) : super(TvSessionInitial());

  Future<void> getTvSessions(int tvId, int tvSessionId) async {
    emit(TvSessionLoading());

    final result = await getTvSession.execute(tvId, tvSessionId);

    result.fold(
      (failure) => emit(TvSessionFailure(message: failure.message)),
      (session) => emit(TvSessionSuccess(session: session)),
    );
  }
}
