import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/approval_repository.dart';

class SubmitApprovalAction {
  final ApprovalRepository repository;

  SubmitApprovalAction(this.repository);

  Future<Either<Failure, void>> call(SubmitActionParams params) {
    if (params.isApprove) {
      return repository.approveItem(params.id);
    }
    if (params.reason == null || params.reason!.isEmpty) {
      return Future.value(const Left(ValidationFailure('Rejection reason is required')));
    }
    return repository.rejectItem(params.id, reason: params.reason!);
  }
}

class SubmitActionParams extends Equatable {
  final String id;
  final bool isApprove;
  final String? reason;

  const SubmitActionParams({
    required this.id,
    required this.isApprove,
    this.reason,
  });

  @override
  List<Object?> get props => [id, isApprove, reason];
}
