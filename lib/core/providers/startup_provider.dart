import 'package:firebase_core/firebase_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'startup_provider.g.dart';

@riverpod
Future<void> startup(Ref ref) async {
  // Keep guest flow available even before Firebase is configured.
  try {
    await Firebase.initializeApp();
  } catch (_) {
    await Future<void>.delayed(Duration.zero);
  }
}
