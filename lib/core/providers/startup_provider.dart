import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'startup_provider.g.dart';

@riverpod
Future<void> startup(Ref ref) async {
  await Future<void>.delayed(Duration.zero);
}
