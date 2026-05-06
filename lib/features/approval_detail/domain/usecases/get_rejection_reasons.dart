import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/approval_detail_repository.dart';

class GetRejectionReasons {
  final ApprovalDetailRepository repository;

  GetRejectionReasons(this.repository);

  Future<Either<Failure, List<String>>> call() {
    return repository.getRejectionReasons();
  }
}
