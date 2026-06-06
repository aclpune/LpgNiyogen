import 'package:flutter_bloc/flutter_bloc.dart';

// ── States ──
sealed class DeliveryBoyListState {}

class DeliveryBoyListInitial extends DeliveryBoyListState {}

class DeliveryBoyListLoading extends DeliveryBoyListState {}

class DeliveryBoyListLoaded extends DeliveryBoyListState {}

class DeliveryBoyListError extends DeliveryBoyListState {
  DeliveryBoyListError(this.message);
  final String message;
}

// ── Cubit ──
class DeliveryBoyListCubit extends Cubit<DeliveryBoyListState> {
  DeliveryBoyListCubit() : super(DeliveryBoyListInitial());

  Future<void> loadDeliveryBoyList() async {
    emit(DeliveryBoyListLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      emit(DeliveryBoyListLoaded());
    } catch (e) {
      emit(DeliveryBoyListError(e.toString()));
    }
  }

  Future<void> refresh() => loadDeliveryBoyList();
}

