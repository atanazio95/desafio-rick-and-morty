import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewModeNotifier extends StateNotifier<bool> {
  ViewModeNotifier() : super(false);

  // Altera o estado de visualização.
  void toggleView() {
    state = !state;
  }
}

final isGridViewProvider = StateNotifierProvider<ViewModeNotifier, bool>((ref) {
  return ViewModeNotifier();
});
