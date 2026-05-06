import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/approval_item.dart';
import '../providers/approval_providers.dart';

class FilterBottomSheet extends ConsumerWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(approvalListNotifierProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter by Status',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              ActionChip(
                label: const Text('All Pending'),
                onPressed: () {
                  notifier.filter();
                  Navigator.pop(context);
                },
              ),
              ActionChip(
                label: const Text('Approved'),
                onPressed: () {
                  notifier.filter(status: ApprovalStatus.approved);
                  Navigator.pop(context);
                },
              ),
              ActionChip(
                label: const Text('Rejected'),
                onPressed: () {
                  notifier.filter(status: ApprovalStatus.rejected);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Filter by Source',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              ActionChip(
                label: const Text('HR'),
                onPressed: () {
                  notifier.filter(source: ApprovalSource.hr);
                  Navigator.pop(context);
                },
              ),
              ActionChip(
                label: const Text('Finance'),
                onPressed: () {
                  notifier.filter(source: ApprovalSource.finance);
                  Navigator.pop(context);
                },
              ),
              ActionChip(
                label: const Text('Procurement'),
                onPressed: () {
                  notifier.filter(source: ApprovalSource.procurement);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
