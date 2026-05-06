import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/approval_mock_datasource.dart';
import '../../data/datasources/approval_remote_datasource.dart';
import '../../data/repositories/approval_repository_impl.dart';
import '../../domain/entities/approval_item.dart';
import '../../domain/repositories/approval_repository.dart';
import '../../domain/usecases/get_approvals.dart';
import '../../domain/usecases/submit_approval_action.dart';

// ── Infrastructure ────────────────────────────────────────────────────────────

final approvalDataSourceProvider = Provider<ApprovalRemoteDataSource>((ref) {
  if (AppConfig.useMockData) return ApprovalMockDataSource();
  return ApprovalRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

final approvalRepositoryProvider = Provider<ApprovalRepository>((ref) {
  return ApprovalRepositoryImpl(
    remoteDataSource: ref.watch(approvalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final getApprovalsProvider = Provider<GetApprovals>(
  (ref) => GetApprovals(ref.watch(approvalRepositoryProvider)),
);

final submitApprovalActionProvider = Provider<SubmitApprovalAction>(
  (ref) => SubmitApprovalAction(ref.watch(approvalRepositoryProvider)),
);

// ── Approval List Notifier (pending queue) ────────────────────────────────────

final approvalListNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ApprovalListNotifier, List<ApprovalItem>>(
  ApprovalListNotifier.new,
);

class ApprovalListNotifier extends AutoDisposeAsyncNotifier<List<ApprovalItem>> {
  @override
  Future<List<ApprovalItem>> build() =>
      _fetch(const GetApprovalsParams(statusFilter: ApprovalStatus.pending));

  Future<List<ApprovalItem>> _fetch(GetApprovalsParams params) async {
    final result = await ref.read(getApprovalsProvider)(params);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (items) => items,
    );
  }

  Future<void> filter({ApprovalStatus? status, ApprovalSource? source}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(GetApprovalsParams(
          statusFilter: status ?? ApprovalStatus.pending,
          sourceFilter: source,
        )));
  }

  Future<void> search(String query) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(GetApprovalsParams(
          statusFilter: ApprovalStatus.pending,
          searchQuery: query.isEmpty ? null : query,
        )));
  }
}

// ── History Notifier (approved + rejected) ────────────────────────────────────

final historyNotifierProvider =
    AutoDisposeAsyncNotifierProvider<HistoryNotifier, List<ApprovalItem>>(
  HistoryNotifier.new,
);

class HistoryNotifier extends AutoDisposeAsyncNotifier<List<ApprovalItem>> {
  ApprovalStatus? _activeFilter;

  @override
  Future<List<ApprovalItem>> build() => _fetch();

  Future<List<ApprovalItem>> _fetch() async {
    final result =
        await ref.read(getApprovalsProvider)(const GetApprovalsParams());
    return result.fold(
      (failure) => throw Exception(failure.message),
      (items) {
        final nonPending =
            items.where((i) => i.status != ApprovalStatus.pending).toList();
        return _activeFilter == null
            ? nonPending
            : nonPending.where((i) => i.status == _activeFilter).toList();
      },
    );
  }

  Future<void> filter(ApprovalStatus? status) async {
    _activeFilter = status;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

// ── Action Notifier (approve / reject) ────────────────────────────────────────

final approvalActionNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ApprovalActionNotifier, void>(
  ApprovalActionNotifier.new,
);

class ApprovalActionNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> approve(String id) async {
    state = const AsyncLoading();
    final result = await ref.read(submitApprovalActionProvider)(
      SubmitActionParams(id: id, isApprove: true),
    );
    state = result.fold(
      (f) => AsyncError(f.message, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }

  Future<void> reject(String id, String reason) async {
    state = const AsyncLoading();
    final result = await ref.read(submitApprovalActionProvider)(
      SubmitActionParams(id: id, isApprove: false, reason: reason),
    );
    state = result.fold(
      (f) => AsyncError(f.message, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }
}
