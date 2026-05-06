part of 'approval_list_bloc.dart';

abstract class ApprovalListState extends Equatable {
  const ApprovalListState();

  @override
  List<Object?> get props => [];
}

class ApprovalListInitial extends ApprovalListState {}

class ApprovalListLoading extends ApprovalListState {}

class ApprovalListLoaded extends ApprovalListState {
  final List<ApprovalItem> items;
  const ApprovalListLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class ApprovalListError extends ApprovalListState {
  final String message;
  const ApprovalListError(this.message);

  @override
  List<Object> get props => [message];
}
