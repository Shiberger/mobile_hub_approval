import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/approval_item.dart';
import '../repositories/approval_repository.dart';

class GetApprovals {
  final ApprovalRepository repository;

  GetApprovals(this.repository);

  Future<Either<Failure, List<ApprovalItem>>> call(GetApprovalsParams params) {
    return repository.getApprovals(
      statusFilter: params.statusFilter,
      sourceFilter: params.sourceFilter,
      searchQuery: params.searchQuery,
    );
  }
}

class GetApprovalsParams extends Equatable {
  final ApprovalStatus? statusFilter;
  final ApprovalSource? sourceFilter;
  final String? searchQuery;

  const GetApprovalsParams({
    this.statusFilter,
    this.sourceFilter,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [statusFilter, sourceFilter, searchQuery];
}
