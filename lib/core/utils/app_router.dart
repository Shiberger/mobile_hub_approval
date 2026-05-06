import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../di/injection_container.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/approval_list/domain/entities/approval_item.dart';
import '../../features/approval_list/presentation/bloc/approval_list_bloc.dart';
import '../../features/approval_list/presentation/pages/approval_list_page.dart';
import '../../features/approval_list/presentation/pages/history_page.dart';
import '../../features/approval_detail/presentation/bloc/approval_action_cubit.dart';
import '../../features/approval_detail/presentation/pages/approval_detail_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<DashboardBloc>(),
        child: const DashboardPage(),
      ),
    ),
    GoRoute(
      path: '/approvals',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<ApprovalListBloc>(),
        child: const ApprovalListPage(),
      ),
    ),
    GoRoute(
      path: '/approvals/:id',
      builder: (context, state) {
        final item = state.extra as ApprovalItem;
        return BlocProvider(
          create: (_) => sl<ApprovalActionCubit>(),
          child: ApprovalDetailPage(item: item),
        );
      },
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<ApprovalListBloc>(),
        child: const HistoryPage(),
      ),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.error}')),
  ),
);
