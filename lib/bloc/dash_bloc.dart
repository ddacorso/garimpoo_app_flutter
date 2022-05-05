import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../presentation/Dashboard/dashboard.dart';
import '../repository/auth_repository.dart';

part 'dash_event.dart';

part 'dash_state.dart';

class DashBloc extends Bloc<DashEvent, DashState> {
  final AuthRepository authRepository;

  DashBloc({required this.authRepository}) : super(ShowSearch()) {
    // When User Presses the SignIn Button, we will send the SignInRequested Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<TabChangeRequested>((event, emit) async {
      if (event.tab == NavbarItems.Filter) {
        emit(ShowFilter());
      }

      if (event.tab == NavbarItems.Search) {
        emit(ShowSearch());
      }


      if (event.tab == NavbarItems.Notifications) {
        emit(ShowNotification());
      }

    });
    // When User Presses the SignOut Button, we will send the SignOutRequested Event to the AuthBloc to handle it and emit the UnAuthenticated State
    on<SignOutRequested>((event, emit) async {
      emit(DashLoading());
      await authRepository.signOut();
      emit(LoggedOut());
    });

  }
}
