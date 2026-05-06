import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../approval_list/domain/entities/approval_item.dart';
import '../../../approval_list/presentation/providers/approval_providers.dart';
import '../../../../core/theme/app_theme.dart';

class ApprovalDetailPage extends ConsumerWidget {
  final ApprovalItem item;

  const ApprovalDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(approvalActionNotifierProvider, (_, next) {
      next.whenOrNull(
        error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppTheme.rejectedColor,
          ),
        ),
        data: (_) => context.pop(true),
      );
    });

    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(
        title: const Text('Approval Detail'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderCard(item: item),
            const SizedBox(height: 12),
            if (item.amount != null) ...[
              _AmountCard(amount: item.amount!),
              const SizedBox(height: 12),
            ],
            _DescriptionCard(description: item.description),
            const SizedBox(height: 12),
            _PayloadCard(item: item),
          ],
        ),
      ),
      bottomNavigationBar: item.status == ApprovalStatus.pending
          ? _ActionBar(item: item)
          : null,
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _HeaderCard extends StatelessWidget {
  final ApprovalItem item;

  const _HeaderCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SourceTag(source: item.source),
              const Spacer(),
              _StatusBadge(status: item.status),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            item.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.onSurfaceColor,
                ),
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          _InfoRow(
              icon: Icons.person_outline,
              label: 'Requested by',
              value: item.requester),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.schedule_outlined,
            label: 'Submitted',
            value: _formatDate(item.createdAt),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const m = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${m[dt.month - 1]} ${dt.year}  $h:$min';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[500]),
        const SizedBox(width: 8),
        Text('$label: ',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[500])),
        Expanded(
          child: Text(value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

// ── Amount ────────────────────────────────────────────────────────────────────

class _AmountCard extends StatelessWidget {
  final String amount;

  const _AmountCard({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.monetization_on_outlined,
                color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Request Amount',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey[500])),
              Text(
                amount,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Description ───────────────────────────────────────────────────────────────

class _DescriptionCard extends StatelessWidget {
  final String description;

  const _DescriptionCard({required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle('Description'),
          const SizedBox(height: 10),
          Text(description,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(height: 1.6, color: Colors.grey[800])),
        ],
      ),
    );
  }
}

// ── Payload ───────────────────────────────────────────────────────────────────

class _PayloadCard extends StatelessWidget {
  final ApprovalItem item;

  const _PayloadCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final rows = _buildPayload(item);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle('Request Details'),
          const SizedBox(height: 12),
          ...rows.entries.map((e) => _DetailRow(label: e.key, value: e.value)),
        ],
      ),
    );
  }

  Map<String, String> _buildPayload(ApprovalItem item) => switch (item.source) {
        ApprovalSource.hr => {
            'Leave Type': 'Annual Leave',
            'From Date': '5 May 2025',
            'To Date': '9 May 2025',
            'Duration': '5 Working Days',
            'Leave Balance': '12 Days Remaining',
            'Work Handover': item.requester,
            'Approver Level': 'Line Manager',
          },
        ApprovalSource.finance => {
            'Budget Code': 'FIN-2025-Q2',
            'Department': 'Information Technology',
            'Category': 'Capital Expenditure',
            'GL Account': '5100-IT-CAP',
            'Fiscal Year': '2025',
            'Cost Center': 'CC-IT-001',
            'Requested by': item.requester,
          },
        ApprovalSource.procurement => {
            'Vendor': 'Apple Thailand Co., Ltd.',
            'Category': 'Hardware & Equipment',
            'Quantity': '1 Unit',
            'Delivery Terms': 'FOB Destination',
            'Expected Delivery': '14 Working Days',
            'Purchase Order': 'PO-2025-08821',
            'Requester Dept': 'Technology',
          },
      };
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[500])),
          ),
          Expanded(
            child: Text(value,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}

// ── Action Bar ────────────────────────────────────────────────────────────────

class _ActionBar extends ConsumerWidget {
  final ApprovalItem item;

  const _ActionBar({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      approvalActionNotifierProvider.select((s) => s is AsyncLoading),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.rejectedColor,
                    side: const BorderSide(color: AppTheme.rejectedColor),
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed:
                      isLoading ? null : () => _showRejectDialog(context, ref),
                  child: const Text('Reject',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.approvedColor,
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: isLoading
                      ? null
                      : () => _showApproveDialog(context, ref),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Approve',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showApproveDialog(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(approvalActionNotifierProvider.notifier);
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Confirm Approval'),
        content: const Text(
            'Are you sure you want to approve this request?\nThis action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: AppTheme.approvedColor),
            onPressed: () {
              Navigator.pop(dialogCtx);
              notifier.approve(item.id);
            },
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(approvalActionNotifierProvider.notifier);
    final reasonController = TextEditingController();
    String? selectedReason;

    const reasons = [
      'Budget exceeded',
      'Missing supporting documents',
      'Duplicate request',
      'Incorrect information',
      'Not within policy',
      'Other',
    ];

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (dialogCtx, setState) => AlertDialog(
          title: const Text('Rejection Reason'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Please select a reason for rejection:'),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Reason *',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  value: selectedReason,
                  items: reasons
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedReason = v),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Additional notes (optional)',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.rejectedColor),
              onPressed: selectedReason == null
                  ? null
                  : () {
                      final reason =
                          selectedReason == 'Other' &&
                                  reasonController.text.isNotEmpty
                              ? reasonController.text
                              : selectedReason!;
                      Navigator.pop(dialogCtx);
                      notifier.reject(item.id, reason);
                    },
              child: const Text('Reject'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.secondaryColor,
            letterSpacing: 0.5,
          ),
    );
  }
}

class _SourceTag extends StatelessWidget {
  final ApprovalSource source;

  const _SourceTag({required this.source});

  String get _label => switch (source) {
        ApprovalSource.hr => 'Human Resources',
        ApprovalSource.finance => 'Finance',
        ApprovalSource.procurement => 'Procurement',
      };

  Color get _color => switch (source) {
        ApprovalSource.hr => Colors.blue,
        ApprovalSource.finance => Colors.purple,
        ApprovalSource.procurement => Colors.orange,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(_label,
          style: TextStyle(
              color: _color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ApprovalStatus status;

  const _StatusBadge({required this.status});

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(_label,
          style: TextStyle(
              color: _color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}
