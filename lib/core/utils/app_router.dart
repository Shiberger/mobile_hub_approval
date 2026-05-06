import 'package:go_router/go_router.dart';
import '../../features/approval_list/domain/entities/approval_item.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/approval_list/presentation/pages/approval_list_page.dart';
import '../../features/approval_list/presentation/pages/history_page.dart';
import '../../features/approval_detail/presentation/pages/approval_detail_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/approvals',
      builder: (context, state) => const ApprovalListPage(),
    ),
    GoRoute(
      path: '/approvals/:id',
      builder: (context, state) => ApprovalDetailPage(
        item: state.extra as ApprovalItem,
      ),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryPage(),
    ),
  ],
);
