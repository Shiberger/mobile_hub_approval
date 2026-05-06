import '../models/home_page_data_model.dart';
import 'dashboard_remote_datasource.dart';

class DashboardMockDataSource implements DashboardRemoteDataSource {
  @override
  Future<HomePageDataModel> getDashboardSummary() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const HomePageDataModel(pending: 12, approved: 34, rejected: 5);
  }
}
