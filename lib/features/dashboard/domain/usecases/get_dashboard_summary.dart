import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/dashboard_summary.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardSummary {
  final DashboardRepository repository;

  GetDashboardSummary(this.repository);

  Future<Either<Failure, DashboardSummary>> call() {
    return repository.getDashboardSummary();
  }
}
