part of 'dash_bloc.dart';

@immutable
abstract class DashEvent extends Equatable {
 
}

class TabChangeRequested extends DashEvent {
  final NavbarItems tab;

  TabChangeRequested(this.tab);

  @override
  List<Object?> get props => [
    tab
  ];
}


// When the user signing out this event is called and the [AuthRepository] is called to sign out the user
class SignOutRequested extends DashEvent {

  @override
  List<Object?> get props => [

  ];
}


