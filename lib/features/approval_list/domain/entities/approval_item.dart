import 'package:equatable/equatable.dart';

enum ApprovalStatus { pending, approved, rejected }

enum ApprovalSource { hr, finance, procurement }

class ApprovalItem extends Equatable {
  final String id;
  final String title;
  final String requester;
  final String description;
  final ApprovalStatus status;
  final ApprovalSource source;
  final DateTime createdAt;
  final String? amount;

  const ApprovalItem({
    required this.id,
    required this.title,
    required this.requester,
    required this.description,
    required this.status,
    required this.source,
    required this.createdAt,
    this.amount,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        requester,
        description,
        status,
        source,
        createdAt,
        amount,
      ];
}
