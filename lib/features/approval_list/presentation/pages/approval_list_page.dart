import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/approval_list_bloc.dart';
import '../widgets/approval_item_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../../../../core/theme/app_theme.dart';

class ApprovalListPage extends StatefulWidget {
  const ApprovalListPage({super.key});

  @override
  State<ApprovalListPage> createState() => _ApprovalListPageState();
}

class _ApprovalListPageState extends State<ApprovalListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ApprovalListBloc>().add(const LoadApprovalList());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openDetail(BuildContext context, item) async {
    final bloc = context.read<ApprovalListBloc>();
    final result = await context.push('/approvals/${item.id}', extra: item);
    if (result == true && mounted) {
      bloc.add(const LoadApprovalList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approvals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_outlined),
            tooltip: 'History',
            onPressed: () => context.push('/history'),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search approvals...',
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(1),
              onChanged: (query) {
                context.read<ApprovalListBloc>().add(SearchApprovalList(query));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<ApprovalListBloc, ApprovalListState>(
              builder: (context, state) {
                if (state is ApprovalListLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ApprovalListError) {
                  return _ErrorView(
                    message: state.message,
                    onRetry: () => context.read<ApprovalListBloc>().add(const LoadApprovalList()),
                  );
                }
                if (state is ApprovalListLoaded) {
                  if (state.items.isEmpty) {
                    return const _EmptyView();
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ApprovalListBloc>().add(const LoadApprovalList());
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: state.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return ApprovalItemCard(
                          item: item,
                          onTap: () => _openDetail(context, item),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<ApprovalListBloc>(),
        child: const FilterBottomSheet(),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'All caught up!',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[500]),
          ),
          const SizedBox(height: 4),
          Text(
            'No pending approvals at this time',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppTheme.rejectedColor),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
