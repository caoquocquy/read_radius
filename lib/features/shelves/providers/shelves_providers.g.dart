// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shelves_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(shelvesRepository)
final shelvesRepositoryProvider = ShelvesRepositoryProvider._();

final class ShelvesRepositoryProvider
    extends
        $FunctionalProvider<
          ShelvesRepository,
          ShelvesRepository,
          ShelvesRepository
        >
    with $Provider<ShelvesRepository> {
  ShelvesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shelvesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shelvesRepositoryHash();

  @$internal
  @override
  $ProviderElement<ShelvesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ShelvesRepository create(Ref ref) {
    return shelvesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShelvesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShelvesRepository>(value),
    );
  }
}

String _$shelvesRepositoryHash() => r'ec5b2e8850b53c025fafbbecd31e120c96020efc';

@ProviderFor(shelvesByStatus)
final shelvesByStatusProvider = ShelvesByStatusProvider._();

final class ShelvesByStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<ShelvesByStatus>,
          ShelvesByStatus,
          FutureOr<ShelvesByStatus>
        >
    with $FutureModifier<ShelvesByStatus>, $FutureProvider<ShelvesByStatus> {
  ShelvesByStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shelvesByStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shelvesByStatusHash();

  @$internal
  @override
  $FutureProviderElement<ShelvesByStatus> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ShelvesByStatus> create(Ref ref) {
    return shelvesByStatus(ref);
  }
}

String _$shelvesByStatusHash() => r'5149bd9e48316e5c1a71585413309d9cf3bf90d8';
