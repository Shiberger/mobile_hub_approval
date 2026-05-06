part of 'approval_action_cubit.dart';

abstract class ApprovalActionState extends Equatable {
  const ApprovalActionState();
  @override
  List<Object> get props => [];
}

class ApprovalActionInitial extends ApprovalActionState {}

class ApprovalActionLoading extends ApprovalActionState {}

class ApprovalActionSuccess extends ApprovalActionState {}

class ApprovalActionFailure extends ApprovalActionState {
  final String message;
  const ApprovalActionFailure(this.message);
  @override
  List<Object> get props => [message];
}
