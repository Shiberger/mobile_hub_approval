import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/approval_providers.dart';
import '../widgets/approval_item_card.dart';
import '../../domain/entities/approval_item.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyNotifierProvider);
    final notifier = ref.read(historyNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: Column(
        children: [
          _FilterBar(notifier: notifier),
          Expanded(
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(e.toString().replaceAll('Exception: ', '')),
              ),
              data: (items) => items.isEmpty
                  ? const _EmptyHistory()
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) => ApprovalItemCard(
                        item: items[index],
                        onTap: () => context.push(
                          '/approvals/${items[index].id}',
                          extra: items[index],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatefulWidget {
  final HistoryNotifier notifier;

  const _FilterBar({required this.notifier});

  @override
  State<_FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<_FilterBar> {
  ApprovalStatus? _active;

  void _select(ApprovalStatus? status) {
    setState(() => _active = status);
    widget.notifier.filter(status);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: _active == null,
            onSelected: (_) => _select(null),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Approved'),
            selected: _active == ApprovalStatus.approved,
            onSelected: (_) => _select(ApprovalStatus.approved),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Rejected'),
            selected: _active == ApprovalStatus.rejected,
            onSelected: (_) => _select(ApprovalStatus.rejected),
          ),
        ],
      ),
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
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey[500]),
          ),
          const SizedBox(height: 4),
          Text(
            'Approved and rejected items will appear here',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
