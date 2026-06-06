import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/newTheam/features/dsr_report/bloc/dsr_report_cubit.dart';

void main() {
  group('DsrReportCubit', () {
    test('initial state is DsrReportInitial', () {
      expect(DsrReportCubit().state, isA<DsrReportInitial>());
    });

    test('loadDsrReport ends in DsrReportLoaded', () async {
      final cubit = DsrReportCubit();
      await cubit.loadDsrReport();
      expect(cubit.state, isA<DsrReportLoaded>());
      await cubit.close();
    });

    test('refresh ends in DsrReportLoaded', () async {
      final cubit = DsrReportCubit();
      await cubit.refresh();
      expect(cubit.state, isA<DsrReportLoaded>());
      await cubit.close();
    });
  });
}

