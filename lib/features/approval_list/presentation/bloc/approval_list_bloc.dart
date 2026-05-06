import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/approval_item.dart';
import '../../domain/usecases/get_approvals.dart';
import '../../domain/usecases/submit_approval_action.dart';

part 'approval_list_event.dart';
part 'approval_list_state.dart';

class ApprovalListBloc extends Bloc<ApprovalListEvent, ApprovalListState> {
  final GetApprovals getApprovals;
  final SubmitApprovalAction submitApprovalAction;

  ApprovalListBloc({
    required this.getApprovals,
    required this.submitApprovalAction,
  }) : super(ApprovalListInitial()) {
    on<LoadApprovalList>(_onLoad);
    on<LoadHistory>(_onLoadHistory);
    on<FilterApprovalList>(_onFilter);
    on<SearchApprovalList>(_onSearch);
    on<SubmitApprove>(_onApprove);
    on<SubmitReject>(_onReject);
  }

  // Loads pending items only — the main approval queue
  Future<void> _onLoad(
    LoadApprovalList event,
    Emitter<ApprovalListState> emit,
  ) async {
    emit(ApprovalListLoading());
    final result = await getApprovals(
      const GetApprovalsParams(statusFilter: ApprovalStatus.pending),
    );
    result.fold(
      (failure) => emit(ApprovalListError(failure.message)),
      (items) => emit(ApprovalListLoaded(items)),
    );
  }

  // Loads approved + rejected items for History page
  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<ApprovalListState> emit,
  ) async {
    emit(ApprovalListLoading());
    final result = await getApprovals(const GetApprovalsParams());
    result.fold(
      (failure) => emit(ApprovalListError(failure.message)),
      (items) => emit(ApprovalListLoaded(
        items.where((i) => i.status != ApprovalStatus.pending).toList(),
      )),
    );
  }

  Future<void> _onFilter(
    FilterApprovalList event,
    Emitter<ApprovalListState> emit,
  ) async {
    emit(ApprovalListLoading());
    final result = await getApprovals(GetApprovalsParams(
      statusFilter: event.status ?? ApprovalStatus.pending,
      sourceFilter: event.source,
    ));
    result.fold(
      (failure) => emit(ApprovalListError(failure.message)),
      (items) => emit(ApprovalListLoaded(items)),
    );
  }

  Future<void> _onSearch(
    SearchApprovalList event,
    Emitter<ApprovalListState> emit,
  ) async {
    emit(ApprovalListLoading());
    final result = await getApprovals(GetApprovalsParams(
      statusFilter: ApprovalStatus.pending,
      searchQuery: event.query,
    ));
    result.fold(
      (failure) => emit(ApprovalListError(failure.message)),
      (items) => emit(ApprovalListLoaded(items)),
    );
  }

  Future<void> _onApprove(
    SubmitApprove event,
    Emitter<ApprovalListState> emit,
  ) async {
    final result = await submitApprovalAction(
      SubmitActionParams(id: event.id, isApprove: true),
    );
    result.fold(
      (failure) => emit(ApprovalListError(failure.message)),
      (_) => add(const LoadApprovalList()),
    );
  }

  Future<void> _onReject(
    SubmitReject event,
    Emitter<ApprovalListState> emit,
  ) async {
    final result = await submitApprovalAction(
      SubmitActionParams(id: event.id, isApprove: false, reason: event.reason),
    );
    result.fold(
      (failure) => emit(ApprovalListError(failure.message)),
      (_) => add(const LoadApprovalList()),
    );
  }
}
