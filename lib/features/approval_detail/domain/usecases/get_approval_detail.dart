import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/approval_detail.dart';
import '../repositories/approval_detail_repository.dart';

class GetApprovalDetail {
  final ApprovalDetailRepository repository;

  GetApprovalDetail(this.repository);

  Future<Either<Failure, ApprovalDetail>> call(String id) {
    return repository.getApprovalDetail(id);
  }
}
