part of 'filter_bloc.dart';

@immutable
abstract class FilterState extends Equatable {}

class FilterLoading extends FilterState {
  @override
  List<Object?> get props => [];
}

class FilterShowReady extends FilterState {

  final int index;
  final FilterScreen filterScreen;

  FilterShowReady(this.index, this.filterScreen);

  @override
  List<Object?> get props => [index, filterScreen];
}

// If any error occurs the state is changed to AuthError.
class FilterError extends FilterState {
  final String error;
  FilterError(this.error);
  @override
  List<Object?> get props => [error];
}
