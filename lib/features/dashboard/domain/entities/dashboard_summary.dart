import 'package:equatable/equatable.dart';

class DashboardSummary extends Equatable {
  final int pendingCount;
  final int approvedCount;
  final int rejectedCount;
  final int totalCount;

  const DashboardSummary({
    required this.pendingCount,
    required this.approvedCount,
    required this.rejectedCount,
  }) : totalCount = pendingCount + approvedCount + rejectedCount;

  @override
  List<Object> get props => [pendingCount, approvedCount, rejectedCount];
}
