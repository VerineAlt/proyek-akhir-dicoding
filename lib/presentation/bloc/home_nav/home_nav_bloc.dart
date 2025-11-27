import 'package:flutter_bloc/flutter_bloc.dart';

class HomeNavCubit extends Cubit<int> {
  // Initial state is 0 (Movies Tab)
  HomeNavCubit() : super(0);

  // Method to change the tab index
  void changeTab(int newIndex) {
    emit(newIndex);
  }
}