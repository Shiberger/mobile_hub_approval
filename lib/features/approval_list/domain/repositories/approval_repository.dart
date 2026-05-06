import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/approval_item.dart';

abstract class ApprovalRepository {
  Future<Either<Failure, List<ApprovalItem>>> getApprovals({
    ApprovalStatus? statusFilter,
    ApprovalSource? sourceFilter,
    String? searchQuery,
  });

  Future<Either<Failure, void>> approveItem(String id);

  Future<Either<Failure, void>> rejectItem(String id, {required String reason});
}
