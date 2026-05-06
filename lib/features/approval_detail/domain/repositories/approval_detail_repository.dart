import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/approval_detail.dart';

abstract class ApprovalDetailRepository {
  Future<Either<Failure, ApprovalDetail>> getApprovalDetail(String id);
  Future<Either<Failure, List<String>>> getRejectionReasons();
}
