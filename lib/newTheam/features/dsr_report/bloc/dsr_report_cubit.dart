import 'package:flutter_bloc/flutter_bloc.dart';

// ── States ──
sealed class DsrReportState {}

class DsrReportInitial extends DsrReportState {}

class DsrReportLoading extends DsrReportState {}

class DsrReportLoaded extends DsrReportState {}

class DsrReportError extends DsrReportState {
  DsrReportError(this.message);
  final String message;
}

// ── Cubit ──
class DsrReportCubit extends Cubit<DsrReportState> {
  DsrReportCubit() : super(DsrReportInitial());

  Future<void> loadDsrReport() async {
    emit(DsrReportLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      emit(DsrReportLoaded());
    } catch (e) {
      emit(DsrReportError(e.toString()));
    }
  }

  Future<void> refresh() => loadDsrReport();
}

