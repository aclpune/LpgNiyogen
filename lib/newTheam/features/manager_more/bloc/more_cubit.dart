import 'package:flutter_bloc/flutter_bloc.dart';

// ── States ──
sealed class MoreState {}

class MoreInitial extends MoreState {}

class MoreLoading extends MoreState {}

class MoreLoaded extends MoreState {}

class MoreError extends MoreState {
  MoreError(this.message);
  final String message;
}

// ── Cubit ──
class MoreCubit extends Cubit<MoreState> {
  MoreCubit() : super(MoreInitial());

  Future<void> loadMore() async {
    emit(MoreLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      emit(MoreLoaded());
    } catch (e) {
      emit(MoreError(e.toString()));
    }
  }

  Future<void> refresh() => loadMore();
}

