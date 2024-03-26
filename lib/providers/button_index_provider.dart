import 'package:flutter_riverpod/flutter_riverpod.dart';

final buttonIndexProvider = StateProvider.family.autoDispose((ref, id) => 0);