import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:garimpoo/local_storage/local_storage_repository.dart';
import 'package:garimpoo/model/User.dart';
import 'package:garimpoo/repository/client_repository.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../repository/auth_repository.dart';
import '../shared/Credentials.dart';

part 'auth_event.dart';

part 'auth_state.dart';

var logger = Logger();

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final ClientRepository clientRepository;
  final Credentials credentials = Credentials();

  AuthBloc({required this.authRepository, required this.clientRepository})
      : super(UnAuthenticated()) {
    // When User Presses the SignIn Button, we will send the SignInRequested Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signIn(
            email: event.email, password: event.password);
        logger.d(LocalStorageShared.instance.getString("X-Firebase-Auth"));
        String? fcmToken = await FirebaseMessaging.instance.getToken();

        UserRequest userRequest = UserRequest(fcmToken: fcmToken);
        User user = await clientRepository.signIn(
            LocalStorageShared.instance.getString("X-Firebase-Auth")!,
            userRequest);

        credentials.planType = user.planType;
        credentials.filter = user.filter;
        credentials.userId = user.uid;
        credentials.username = user.username;

        emit(Authenticated());
      } catch (e) {
        logger.e(e.toString());
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });
    // When User Presses the SignUp Button, we will send the SignUpRequest Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signUp(
            email: event.email,
            password: event.password,
            username: event.username);

        String? fcmToken = await FirebaseMessaging.instance.getToken();
        UserRequest userRequest = UserRequest(fcmToken: fcmToken, username: event.username);

        await clientRepository.signUp(
            LocalStorageShared.instance.getString("X-Firebase-Auth")!,
            userRequest);

        emit(Registered());
      } catch (e) {
        logger.e(e.toString());
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    // When User Presses the SignOut Button, we will send the SignOutRequested Event to the AuthBloc to handle it and emit the UnAuthenticated State
    on<VerifyCurrentToken>((event, emit) async {
      emit(AuthLoading());
      try {
        bool currentToken = await authRepository.currentStatus();
        if (currentToken) {
          await authRepository.refreshToken();


          String? fcmToken = await FirebaseMessaging.instance.getToken();

          logger.i(fcmToken);

          User user = await clientRepository.signIn(
              LocalStorageShared.instance.getString("X-Firebase-Auth")!,
              UserRequest(fcmToken: fcmToken));

          credentials.planType = user.planType;
          credentials.filter = user.filter;
          credentials.userId = user.uid;
          credentials.username = user.username;

          emit(Authenticated());
        } else {
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });
  }
}
