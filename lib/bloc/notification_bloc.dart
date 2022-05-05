import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:garimpoo/local_storage/local_storage_repository.dart';
import 'package:garimpoo/model/ProductNotification.dart';
import 'package:garimpoo/repository/auth_repository.dart';
import 'package:garimpoo/repository/client_repository.dart';
import 'package:meta/meta.dart';

import '../shared/Credentials.dart';

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final ClientRepository clientRepository;
  final AuthRepository authRepository;

  NotificationBloc({required this.clientRepository, required this.authRepository})
      : super(Loading()) {
    on<NotificationLoad>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.refreshToken();
        List<ProductNotification> products = await clientRepository.getAllNotifications(
            LocalStorageShared.instance.getString("X-Firebase-Auth")!);

        if (products.isEmpty)  {
          emit(NotificationsNothingToLoad());
        } else {
          emit(NotificationsLoadedSuccess(products));
        }


      } catch (e) {
        emit(NotificationsError(e.toString()));
      }
    });

  }
}
