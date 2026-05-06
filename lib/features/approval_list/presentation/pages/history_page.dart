import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/approval_list_bloc.dart';
import '../widgets/approval_item_card.dart';
import '../../domain/entities/approval_item.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  ApprovalStatus? _activeFilter;

  @override
  void initState() {
    super.initState();
    context.read<ApprovalListBloc>().add(const LoadHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Column(
        children: [
          _FilterBar(
            active: _activeFilter,
            onChanged: (status) {
              setState(() => _activeFilter = status);
              if (status == null) {
                context.read<ApprovalListBloc>().add(const LoadHistory());
              } else {
                context.read<ApprovalListBloc>().add(
                  FilterApprovalList(status: status),
                );
              }
            },
          ),
          Expanded(
            child: BlocBuilder<ApprovalListBloc, ApprovalListState>(
              builder: (context, state) {
                if (state is ApprovalListLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ApprovalListError) {
                  return Center(child: Text(state.message));
                }
                if (state is ApprovalListLoaded) {
                  if (state.items.isEmpty) {
                    return const _EmptyHistory();
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return ApprovalItemCard(
                        item: item,
                        onTap: () => context.push('/approvals/${item.id}', extra: item),
                      );
                    },
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
}

class _FilterBar extends StatelessWidget {
  final ApprovalStatus? active;
  final ValueChanged<ApprovalStatus?> onChanged;

  const _FilterBar({required this.active, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _Chip(label: 'All', selected: active == null, onTap: () => onChanged(null)),
          const SizedBox(width: 8),
          _Chip(
            label: 'Approved',
            selected: active == ApprovalStatus.approved,
            onTap: () => onChanged(ApprovalStatus.approved),
          ),
          const SizedBox(width: 8),
          _Chip(
            label: 'Rejected',
            selected: active == ApprovalStatus.rejected,
            onTap: () => onChanged(ApprovalStatus.rejected),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No history yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[500]),
          ),
          const SizedBox(height: 4),
          Text(
            'Approved and rejected items will appear here',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
