import 'package:equatable/equatable.dart';
import '../../../approval_list/domain/entities/approval_item.dart';

class ApprovalDetail extends Equatable {
  final String id;
  final String title;
  final String requester;
  final String requesterRole;
  final String description;
  final ApprovalStatus status;
  final ApprovalSource source;
  final DateTime createdAt;
  final String? amount;
  final Map<String, dynamic> payload;
  final List<String> attachmentUrls;
  final String? auditTrail;

  const ApprovalDetail({
    required this.id,
    required this.title,
    required this.requester,
    required this.requesterRole,
    required this.description,
    required this.status,
    required this.source,
    required this.createdAt,
    this.amount,
    required this.payload,
    required this.attachmentUrls,
    this.auditTrail,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        requester,
        requesterRole,
        description,
        status,
        source,
        createdAt,
        amount,
        payload,
        attachmentUrls,
        auditTrail,
      ];
}
