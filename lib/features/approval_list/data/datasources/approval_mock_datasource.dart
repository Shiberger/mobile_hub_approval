import '../models/approval_item_model.dart';
import 'approval_remote_datasource.dart';

class ApprovalMockDataSource implements ApprovalRemoteDataSource {
  static final _items = [
    ApprovalItemModel(
      id: '001',
      title: 'Annual Leave Request',
      requester: 'Somchai Jaidee',
      description: 'Request for 5 days annual leave during Songkran holiday.',
      status: 'pending',
      source: 'hr',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
    ),
    ApprovalItemModel(
      id: '002',
      title: 'Office Equipment Purchase',
      requester: 'Nattaporn Srisuk',
      description: 'MacBook Pro M3 for development team.',
      status: 'pending',
      source: 'procurement',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
      amount: '฿85,000',
    ),
    ApprovalItemModel(
      id: '003',
      title: 'Marketing Budget Q3',
      requester: 'Wanwisa Thongchai',
      description: 'Additional budget for digital marketing campaigns.',
      status: 'pending',
      source: 'finance',
      createdAt: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      amount: '฿250,000',
    ),
    ApprovalItemModel(
      id: '004',
      title: 'Remote Work Request',
      requester: 'Priya Sharma',
      description: 'Work from home for the month of June.',
      status: 'approved',
      source: 'hr',
      createdAt: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
    ),
    ApprovalItemModel(
      id: '005',
      title: 'Travel Expense Reimbursement',
      requester: 'Tanakorn Weerasak',
      description: 'Business trip to Singapore for tech conference.',
      status: 'rejected',
      source: 'finance',
      createdAt: DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      amount: '฿42,500',
    ),
    ApprovalItemModel(
      id: '006',
      title: 'Software License Renewal',
      requester: 'Monthira Panya',
      description: 'Renew Figma and Jira annual licenses for design & dev teams.',
      status: 'pending',
      source: 'procurement',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)).toIso8601String(),
      amount: '฿38,000',
    ),
    ApprovalItemModel(
      id: '007',
      title: 'Sick Leave — 2 Days',
      requester: 'Kanya Boonsri',
      description: 'Medical certificate attached.',
      status: 'approved',
      source: 'hr',
      createdAt: DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
    ),
  ];

  final List<ApprovalItemModel> _currentItems = List.from(_items);

  @override
  Future<List<ApprovalItemModel>> getApprovals({
    String? status,
    String? source,
    String? searchQuery,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    var result = List<ApprovalItemModel>.from(_currentItems);

    if (status != null) {
      result = result.where((i) => i.status == status).toList();
    }
    if (source != null) {
      result = result.where((i) => i.source == source).toList();
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result
          .where((i) =>
              i.title.toLowerCase().contains(q) ||
              i.requester.toLowerCase().contains(q))
          .toList();
    }

    return result;
  }

  @override
  Future<void> approveItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _currentItems.indexWhere((i) => i.id == id);
    if (index != -1) {
      final item = _currentItems[index];
      _currentItems[index] = ApprovalItemModel(
        id: item.id,
        title: item.title,
        requester: item.requester,
        description: item.description,
        status: 'approved',
        source: item.source,
        createdAt: item.createdAt,
        amount: item.amount,
      );
    }
  }

  @override
  Future<void> rejectItem(String id, {required String reason}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _currentItems.indexWhere((i) => i.id == id);
    if (index != -1) {
      final item = _currentItems[index];
      _currentItems[index] = ApprovalItemModel(
        id: item.id,
        title: item.title,
        requester: item.requester,
        description: item.description,
        status: 'rejected',
        source: item.source,
        createdAt: item.createdAt,
        amount: item.amount,
      );
    }
  }
}
