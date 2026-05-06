import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/dashboard_mock_datasource.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_dashboard_summary.dart';

final dashboardDataSourceProvider = Provider<DashboardRemoteDataSource>((ref) {
  if (AppConfig.useMockData) return DashboardMockDataSource();
  return DashboardRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    remoteDataSource: ref.watch(dashboardDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final getDashboardSummaryProvider = Provider<GetDashboardSummary>(
  (ref) => GetDashboardSummary(ref.watch(dashboardRepositoryProvider)),
);

// ── Notifier ──────────────────────────────────────────────────────────────────

final dashboardNotifierProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardSummary>(
  DashboardNotifier.new,
);

class DashboardNotifier extends AsyncNotifier<DashboardSummary> {
  @override
  Future<DashboardSummary> build() async {
    final result = await ref.read(getDashboardSummaryProvider)();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (summary) => summary,
    );
  }
}
