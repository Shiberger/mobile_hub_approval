import 'package:flutter/material.dart';
import '../../domain/entities/approval_item.dart';
import '../../../../core/theme/app_theme.dart';

class ApprovalItemCard extends StatelessWidget {
  final ApprovalItem item;
  final VoidCallback onTap;

  const ApprovalItemCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: _SourceBadge(source: item.source),
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.requester),
            if (item.amount != null) Text(item.amount!, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: _StatusChip(status: item.status),
        isThreeLine: item.amount != null,
      ),
    );
  }
}

class _SourceBadge extends StatelessWidget {
  final ApprovalSource source;

  const _SourceBadge({required this.source});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: _sourceColor.withValues(alpha:0.15),
      child: Text(_sourceLabel, style: TextStyle(color: _sourceColor, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  String get _sourceLabel => switch (source) {
        ApprovalSource.hr => 'HR',
        ApprovalSource.finance => 'FIN',
        ApprovalSource.procurement => 'PRO',
      };

  Color get _sourceColor => switch (source) {
        ApprovalSource.hr => Colors.blue,
        ApprovalSource.finance => Colors.purple,
        ApprovalSource.procurement => Colors.orange,
      };
}

class _StatusChip extends StatelessWidget {
  final ApprovalStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(_label, style: TextStyle(color: _color, fontSize: 11)),
      backgroundColor: _color.withValues(alpha:0.1),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
    );
  }

  String get _label => switch (status) {
        ApprovalStatus.pending => 'Pending',
        ApprovalStatus.approved => 'Approved',
        ApprovalStatus.rejected => 'Rejected',
      };

  Color get _color => switch (status) {
        ApprovalStatus.pending => AppTheme.pendingColor,
        ApprovalStatus.approved => AppTheme.approvedColor,
        ApprovalStatus.rejected => AppTheme.rejectedColor,
      };
}
