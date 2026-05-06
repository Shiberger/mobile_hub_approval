class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.yourdomain.com/v1';

  // Auth
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Dashboard
  static const String dashboardSummary = '/approvals/summary';

  // Approval List
  static const String approvalList = '/approvals';

  // Approval Detail
  static String approvalDetail(String id) => '/approvals/$id';

  // Actions
  static String approveAction(String id) => '/approvals/$id/approve';
  static String rejectAction(String id) => '/approvals/$id/reject';

  // Reasons
  static const String rejectionReasons = '/reasons';
}
