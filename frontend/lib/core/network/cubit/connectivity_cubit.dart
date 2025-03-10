import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/network/cubit/connectivity_state.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  late StreamSubscription<InternetStatus> _internetConnectionListener;
  ConnectivityCubit()
      : super(ConnectivityState(internetStatus: InternetStatus.disconnected)) {
    _internetConnectionListener =
        InternetConnection().onStatusChange.listen(updateConnectionStatus);
  }

  void updateConnectionStatus(InternetStatus status) =>
      emit(state.copyWith(internetStatus: status));

  @override
  Future<void> close() {
    _internetConnectionListener.cancel();
    return super.close();
  }
}
