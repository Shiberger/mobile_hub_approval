import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../approval_list/domain/usecases/submit_approval_action.dart';

part 'approval_action_state.dart';

class ApprovalActionCubit extends Cubit<ApprovalActionState> {
  final SubmitApprovalAction _submitApprovalAction;

  ApprovalActionCubit(this._submitApprovalAction) : super(ApprovalActionInitial());

  Future<void> approve(String id) async {
    emit(ApprovalActionLoading());
    final result = await _submitApprovalAction(SubmitActionParams(id: id, isApprove: true));
    result.fold(
      (failure) => emit(ApprovalActionFailure(failure.message)),
      (_) => emit(ApprovalActionSuccess()),
    );
  }

  Future<void> reject(String id, String reason) async {
    emit(ApprovalActionLoading());
    final result = await _submitApprovalAction(
      SubmitActionParams(id: id, isApprove: false, reason: reason),
    );
    result.fold(
      (failure) => emit(ApprovalActionFailure(failure.message)),
      (_) => emit(ApprovalActionSuccess()),
    );
  }
}
