import 'package:flutter_riverpod/flutter_riverpod.dart';

final compatibilityCartridgesProvider =
    StateNotifierProvider<CompatibilityCartridgesState, Set<String>>(
  (ref) => CompatibilityCartridgesState(),
);

class CompatibilityCartridgesState extends StateNotifier<Set<String>> {
  CompatibilityCartridgesState() : super(<String>{});

  void addAll(Set<String> cartridgeNames) {
    state = <String>{...state, ...cartridgeNames};
  }

  void addItem(String cartridgeName) {
    state = {...state, cartridgeName};
  }

  void removeItem(String cartridgeName) {
    state = state.where((element) => element != cartridgeName).toSet();
  }

  void clear() {
    state = <String>{};
  }

  void toggleItem(String cartridgeName) {
    if (state.map((e) => e).toList().contains(cartridgeName)) {
      removeItem(cartridgeName);
    } else {
      addItem(cartridgeName);
    }
  }

  void toggleAll(Set<String> cartridgeNames) {
    if (state.length == cartridgeNames.length) {
      clear();
    } else {
      state = <String>{...cartridgeNames};
    }
  }
}
