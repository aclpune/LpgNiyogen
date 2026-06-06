import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/newTheam/features/manager_more/bloc/more_cubit.dart';

void main() {
  group('MoreCubit', () {
    test('initial state is MoreInitial', () {
      expect(MoreCubit().state, isA<MoreInitial>());
    });

    test('loadMore ends in MoreLoaded', () async {
      final cubit = MoreCubit();
      await cubit.loadMore();
      expect(cubit.state, isA<MoreLoaded>());
      await cubit.close();
    });

    test('refresh ends in MoreLoaded', () async {
      final cubit = MoreCubit();
      await cubit.refresh();
      expect(cubit.state, isA<MoreLoaded>());
      await cubit.close();
    });
  });
}

