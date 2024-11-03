import 'package:flutter_bloc/flutter_bloc.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(MenuState());

  void changeIndex(int index) {
    emit(MenuState()..selectedIndex = index);
  }
}
