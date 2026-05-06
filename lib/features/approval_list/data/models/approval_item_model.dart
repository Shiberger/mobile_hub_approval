import '../../domain/entities/approval_item.dart';

class ApprovalItemModel {
  final String id;
  final String title;
  final String requester;
  final String description;
  final String status;
  final String source;
  final String createdAt;
  final String? amount;

  const ApprovalItemModel({
    required this.id,
    required this.title,
    required this.requester,
    required this.description,
    required this.status,
    required this.source,
    required this.createdAt,
    this.amount,
  });

  factory ApprovalItemModel.fromJson(Map<String, dynamic> json) {
    return ApprovalItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      requester: json['requester'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      source: json['source'] as String,
      createdAt: json['created_at'] as String,
      amount: json['amount'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'requester': requester,
        'description': description,
        'status': status,
        'source': source,
        'created_at': createdAt,
        'amount': amount,
      };
}

extension ApprovalItemModelMapper on ApprovalItemModel {
  ApprovalItem toEntity() => ApprovalItem(
        id: id,
        title: title,
        requester: requester,
        description: description,
        status: _mapStatus(status),
        source: _mapSource(source),
        createdAt: DateTime.parse(createdAt),
        amount: amount,
      );

  ApprovalStatus _mapStatus(String raw) => switch (raw.toLowerCase()) {
        'approved' => ApprovalStatus.approved,
        'rejected' => ApprovalStatus.rejected,
        _ => ApprovalStatus.pending,
      };

  ApprovalSource _mapSource(String raw) => switch (raw.toLowerCase()) {
        'finance' => ApprovalSource.finance,
        'procurement' => ApprovalSource.procurement,
        _ => ApprovalSource.hr,
      };
}
