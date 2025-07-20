import 'package:flutter_riverpod/flutter_riverpod.dart';

final changeColorProvider = StateProvider.family<bool, bool>(
  (ref, init) => init,
);
