import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/approval_item.dart';
import '../bloc/approval_list_bloc.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter by Status', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _FilterChip(
                label: 'All',
                onTap: () {
                  context.read<ApprovalListBloc>().add(const LoadApprovalList());
                  Navigator.pop(context);
                },
              ),
              _FilterChip(
                label: 'Pending',
                onTap: () {
                  context.read<ApprovalListBloc>().add(
                    const FilterApprovalList(status: ApprovalStatus.pending),
                  );
                  Navigator.pop(context);
                },
              ),
              _FilterChip(
                label: 'Approved',
                onTap: () {
                  context.read<ApprovalListBloc>().add(
                    const FilterApprovalList(status: ApprovalStatus.approved),
                  );
                  Navigator.pop(context);
                },
              ),
              _FilterChip(
                label: 'Rejected',
                onTap: () {
                  context.read<ApprovalListBloc>().add(
                    const FilterApprovalList(status: ApprovalStatus.rejected),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Filter by Source', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _FilterChip(
                label: 'HR',
                onTap: () {
                  context.read<ApprovalListBloc>().add(
                    const FilterApprovalList(source: ApprovalSource.hr),
                  );
                  Navigator.pop(context);
                },
              ),
              _FilterChip(
                label: 'Finance',
                onTap: () {
                  context.read<ApprovalListBloc>().add(
                    const FilterApprovalList(source: ApprovalSource.finance),
                  );
                  Navigator.pop(context);
                },
              ),
              _FilterChip(
                label: 'Procurement',
                onTap: () {
                  context.read<ApprovalListBloc>().add(
                    const FilterApprovalList(source: ApprovalSource.procurement),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(label: Text(label), onPressed: onTap);
  }
}
