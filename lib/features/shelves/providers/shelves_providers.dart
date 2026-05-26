import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:read_radius/features/auth/providers/auth_providers.dart';
import 'package:read_radius/features/shelves/data/firestore_shelves_repository.dart';
import 'package:read_radius/features/shelves/domain/shelves_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shelves_providers.g.dart';

@riverpod
ShelvesRepository shelvesRepository(Ref ref) {
  return FirestoreShelvesRepository(FirebaseFirestore.instance);
}

@riverpod
Future<ShelvesByStatus> shelvesByStatus(Ref ref) async {
  final AuthSessionState state = await ref.watch(authSessionProvider.future);
  if (state != AuthSessionState.authenticated) {
    return emptyShelvesByStatus();
  }

  final User? user = FirebaseAuth.instance.currentUser;
  final String? userId = user?.uid;
  if (userId == null || userId.isEmpty) {
    return emptyShelvesByStatus();
  }

  final ShelvesRepository repository = ref.watch(shelvesRepositoryProvider);
  return repository.fetchShelvesForUser(userId);
}
