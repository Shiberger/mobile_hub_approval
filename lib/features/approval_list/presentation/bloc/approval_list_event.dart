part of 'approval_list_bloc.dart';

abstract class ApprovalListEvent extends Equatable {
  const ApprovalListEvent();

  @override
  List<Object?> get props => [];
}

class LoadApprovalList extends ApprovalListEvent {
  const LoadApprovalList();
}

class LoadHistory extends ApprovalListEvent {
  const LoadHistory();
}

class FilterApprovalList extends ApprovalListEvent {
  final ApprovalStatus? status;
  final ApprovalSource? source;

  const FilterApprovalList({this.status, this.source});

  @override
  List<Object?> get props => [status, source];
}

class SearchApprovalList extends ApprovalListEvent {
  final String query;

  const SearchApprovalList(this.query);

  @override
  List<Object> get props => [query];
}

class SubmitApprove extends ApprovalListEvent {
  final String id;

  const SubmitApprove(this.id);

  @override
  List<Object> get props => [id];
}

class SubmitReject extends ApprovalListEvent {
  final String id;
  final String reason;

  const SubmitReject({required this.id, required this.reason});

  @override
  List<Object> get props => [id, reason];
}
