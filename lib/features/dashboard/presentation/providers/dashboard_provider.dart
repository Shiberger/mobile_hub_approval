import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../approval_list/domain/entities/approval_item.dart';
import '../../../approval_list/domain/usecases/get_approvals.dart';
import '../../../approval_list/presentation/providers/approval_providers.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_dashboard_summary.dart';

// Real API path — used when AppConfig.useMockData == false
final dashboardDataSourceProvider = Provider<DashboardRemoteDataSource>((ref) {
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
//
// autoDispose ensures counts are recomputed fresh every time the dashboard
// page is visited — so approve/reject actions are always reflected.

final dashboardNotifierProvider =
    AutoDisposeAsyncNotifierProvider<DashboardNotifier, DashboardSummary>(
  DashboardNotifier.new,
);

class DashboardNotifier extends AutoDisposeAsyncNotifier<DashboardSummary> {
  @override
  Future<DashboardSummary> build() async {
    if (AppConfig.useMockData) {
      return _computeFromItems();
    }
    final result = await ref.read(getDashboardSummaryProvider)();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (summary) => summary,
    );
  }

  // Derives counts from the same mock data the approval list uses,
  // so the numbers always match what the user actually sees.
  Future<DashboardSummary> _computeFromItems() async {
    final result = await ref.read(getApprovalsProvider)(
      const GetApprovalsParams(),
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (items) => DashboardSummary(
        pendingCount:
            items.where((i) => i.status == ApprovalStatus.pending).length,
        approvedCount:
            items.where((i) => i.status == ApprovalStatus.approved).length,
        rejectedCount:
            items.where((i) => i.status == ApprovalStatus.rejected).length,
      ),
    );
  }
}
