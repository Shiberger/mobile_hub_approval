import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/approval_item_model.dart';

abstract class ApprovalRemoteDataSource {
  Future<List<ApprovalItemModel>> getApprovals({
    String? status,
    String? source,
    String? searchQuery,
  });

  Future<void> approveItem(String id);

  Future<void> rejectItem(String id, {required String reason});
}

class ApprovalRemoteDataSourceImpl implements ApprovalRemoteDataSource {
  final ApiClient apiClient;

  ApprovalRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ApprovalItemModel>> getApprovals({
    String? status,
    String? source,
    String? searchQuery,
  }) async {
    final params = <String, dynamic>{
      if (status != null) 'status': status,
      if (source != null) 'source': source,
      if (searchQuery != null && searchQuery.isNotEmpty) 'q': searchQuery,
    };

    final response = await apiClient.get(ApiConstants.approvalList, queryParams: params);
    if (response.statusCode == 200) {
      final list = response.data as List<dynamic>;
      return list.map((e) => ApprovalItemModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw ServerException('Failed to fetch approvals', statusCode: response.statusCode);
  }

  @override
  Future<void> approveItem(String id) async {
    final response = await apiClient.post(ApiConstants.approveAction(id));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ServerException('Failed to approve item', statusCode: response.statusCode);
    }
  }

  @override
  Future<void> rejectItem(String id, {required String reason}) async {
    final response = await apiClient.post(
      ApiConstants.rejectAction(id),
      data: {'reason': reason},
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ServerException('Failed to reject item', statusCode: response.statusCode);
    }
  }
}

