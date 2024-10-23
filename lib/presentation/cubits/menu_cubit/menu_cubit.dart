import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(MenuState());

  void changeIndex(int index) {
    emit(MenuState()..selectedIndex = index);
  }
}
