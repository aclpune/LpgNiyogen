import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/newTheam/features/delivery_boy_list/bloc/delivery_boy_list_cubit.dart';

void main() {
  group('DeliveryBoyListCubit', () {
    test('initial state is DeliveryBoyListInitial', () {
      expect(DeliveryBoyListCubit().state, isA<DeliveryBoyListInitial>());
    });

    test('loadDeliveryBoyList ends in DeliveryBoyListLoaded', () async {
      final cubit = DeliveryBoyListCubit();
      await cubit.loadDeliveryBoyList();
      expect(cubit.state, isA<DeliveryBoyListLoaded>());
      await cubit.close();
    });

    test('refresh ends in DeliveryBoyListLoaded', () async {
      final cubit = DeliveryBoyListCubit();
      await cubit.refresh();
      expect(cubit.state, isA<DeliveryBoyListLoaded>());
      await cubit.close();
    });
  });
}

