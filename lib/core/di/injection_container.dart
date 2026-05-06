import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_config.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';

// Dashboard
import '../../features/dashboard/data/datasources/dashboard_mock_datasource.dart';
import '../../features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_summary.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';

// Approval Detail
import '../../features/approval_detail/presentation/bloc/approval_action_cubit.dart';

// Approval List
import '../../features/approval_list/data/datasources/approval_mock_datasource.dart';
import '../../features/approval_list/data/datasources/approval_remote_datasource.dart';
import '../../features/approval_list/data/repositories/approval_repository_impl.dart';
import '../../features/approval_list/domain/repositories/approval_repository.dart';
import '../../features/approval_list/domain/usecases/get_approvals.dart';
import '../../features/approval_list/domain/usecases/submit_approval_action.dart';
import '../../features/approval_list/presentation/bloc/approval_list_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── External ───────────────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<Dio>(() => Dio());

  // ── Core ───────────────────────────────────────────────────────
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

  // ── Dashboard ──────────────────────────────────────────────────
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => AppConfig.useMockData
        ? DashboardMockDataSource()
        : DashboardRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<GetDashboardSummary>(() => GetDashboardSummary(sl()));
  sl.registerFactory<DashboardBloc>(() => DashboardBloc(getDashboardSummary: sl()));

  // ── Approval List ──────────────────────────────────────────────
  sl.registerLazySingleton<ApprovalRemoteDataSource>(
    () => AppConfig.useMockData
        ? ApprovalMockDataSource()
        : ApprovalRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ApprovalRepository>(
    () => ApprovalRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<GetApprovals>(() => GetApprovals(sl()));
  sl.registerLazySingleton<SubmitApprovalAction>(() => SubmitApprovalAction(sl()));
  sl.registerFactory<ApprovalListBloc>(
    () => ApprovalListBloc(getApprovals: sl(), submitApprovalAction: sl()),
  );
  sl.registerFactory<ApprovalActionCubit>(() => ApprovalActionCubit(sl()));
}
