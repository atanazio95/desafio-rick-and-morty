import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewModeNotifier extends StateNotifier<bool> {
  ViewModeNotifier() : super(false);

  void toggleView() {
    state = !state;
  }
}

final isGridViewProvider = StateNotifierProvider<ViewModeNotifier, bool>((ref) {
  return ViewModeNotifier();
});
