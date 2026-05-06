import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/approval_item.dart';
import '../../domain/repositories/approval_repository.dart';
import '../datasources/approval_remote_datasource.dart';
import '../models/approval_item_model.dart';

class ApprovalRepositoryImpl implements ApprovalRepository {
  final ApprovalRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ApprovalRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ApprovalItem>>> getApprovals({
    ApprovalStatus? statusFilter,
    ApprovalSource? sourceFilter,
    String? searchQuery,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final models = await remoteDataSource.getApprovals(
        status: _statusToString(statusFilter),
        source: _sourceToString(sourceFilter),
        searchQuery: searchQuery,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> approveItem(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      await remoteDataSource.approveItem(id);
      return const Right(null);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> rejectItem(String id, {required String reason}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      await remoteDataSource.rejectItem(id, reason: reason);
      return const Right(null);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  String? _statusToString(ApprovalStatus? status) => switch (status) {
        ApprovalStatus.pending => 'pending',
        ApprovalStatus.approved => 'approved',
        ApprovalStatus.rejected => 'rejected',
        null => null,
      };

  String? _sourceToString(ApprovalSource? source) => switch (source) {
        ApprovalSource.hr => 'hr',
        ApprovalSource.finance => 'finance',
        ApprovalSource.procurement => 'procurement',
        null => null,
      };
}
