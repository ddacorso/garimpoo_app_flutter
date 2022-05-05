part of 'dash_bloc.dart';

@immutable
abstract class DashState extends Equatable {}

// When the user presses the signin or signup button the state is changed to loading first and then to Authenticated.
class DashLoading extends DashState {
  @override
  List<Object?> get props => [];
}

// When the user is authenticated the state is changed to Authenticated.
class ShowFilter extends DashState {
  @override
  List<Object?> get props => [];
}

// When the user is authenticated the state is changed to Authenticated.
class ShowSearch extends DashState {
  @override
  List<Object?> get props => [];
}

// When the user is authenticated the state is changed to Authenticated.
class ShowNotification extends DashState {
  @override
  List<Object?> get props => [];
}


// When the user is authenticated the state is changed to Authenticated.
class LoggedOut extends DashState {
  @override
  List<Object?> get props => [];
}


// If any error occurs the state is changed to AuthError.
class DashError extends DashState {
  final String error;

  DashError(this.error);
  @override
  List<Object?> get props => [error];
}
