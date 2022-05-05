part of 'notification_bloc.dart';

@immutable
abstract class NotificationState extends Equatable {}

// When the user presses the signin or signup button the state is changed to loading first and then to Authenticated.
class Loading extends NotificationState {
  @override
  List<Object?> get props => [];
}

// When the user is authenticated the state is changed to Authenticated.
class NotificationsNothingToLoad extends NotificationState {
  @override
  List<Object?> get props => [];
}

// When the user is authenticated the state is changed to Authenticated.
class NotificationsLoadedSuccess extends NotificationState {

  final List<ProductNotification> products;


  NotificationsLoadedSuccess(this.products);

  @override
  List<Object?> get props => [products];
}


// If any error occurs the state is changed to AuthError.
class NotificationsError extends NotificationState {
  final String error;

  NotificationsError(this.error);
  @override
  List<Object?> get props => [error];
}
