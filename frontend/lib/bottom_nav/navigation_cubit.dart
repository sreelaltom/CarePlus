import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/service_locator.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  void navigateTo(int index) async {
    switch (index) {
      case 0:
        await Dependencies.initCancerAnalysis();
        await Dependencies.initFoodClassifier();
        break;
      case 1:
        await Dependencies.initMedicalRecord();

        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        await Dependencies.initAnalysis();
        break;
    }
    emit(index);
  }
}
