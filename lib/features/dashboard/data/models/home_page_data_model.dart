import '../../domain/entities/dashboard_summary.dart';

class HomePageDataModel {
  final int pending;
  final int approved;
  final int rejected;

  const HomePageDataModel({
    required this.pending,
    required this.approved,
    required this.rejected,
  });

  factory HomePageDataModel.fromJson(Map<String, dynamic> json) {
    return HomePageDataModel(
      pending: json['pending'] as int,
      approved: json['approved'] as int,
      rejected: json['rejected'] as int,
    );
  }

  DashboardSummary toEntity() => DashboardSummary(
        pendingCount: pending,
        approvedCount: approved,
        rejectedCount: rejected,
      );
}
