import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/home_page_data_model.dart';

abstract class DashboardRemoteDataSource {
  Future<HomePageDataModel> getDashboardSummary();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient apiClient;

  DashboardRemoteDataSourceImpl(this.apiClient);

  @override
  Future<HomePageDataModel> getDashboardSummary() async {
    final response = await apiClient.get(ApiConstants.dashboardSummary);
    if (response.statusCode == 200) {
      return HomePageDataModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw ServerException('Failed to fetch dashboard summary', statusCode: response.statusCode);
  }
}
