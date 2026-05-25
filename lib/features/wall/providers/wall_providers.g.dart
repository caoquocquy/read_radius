// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wall_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(wallHttpClient)
final wallHttpClientProvider = WallHttpClientProvider._();

final class WallHttpClientProvider
    extends $FunctionalProvider<http.Client, http.Client, http.Client>
    with $Provider<http.Client> {
  WallHttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wallHttpClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wallHttpClientHash();

  @$internal
  @override
  $ProviderElement<http.Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  http.Client create(Ref ref) {
    return wallHttpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(http.Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<http.Client>(value),
    );
  }
}

String _$wallHttpClientHash() => r'f20496076c032c813ecf01dcf05ee47cf86d4797';

@ProviderFor(wallRepository)
final wallRepositoryProvider = WallRepositoryProvider._();

final class WallRepositoryProvider
    extends $FunctionalProvider<WallRepository, WallRepository, WallRepository>
    with $Provider<WallRepository> {
  WallRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wallRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wallRepositoryHash();

  @$internal
  @override
  $ProviderElement<WallRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WallRepository create(Ref ref) {
    return wallRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WallRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WallRepository>(value),
    );
  }
}

String _$wallRepositoryHash() => r'e45fb831ca5658883aa0aba03fdb7017de062456';

@ProviderFor(WallSearchQuery)
final wallSearchQueryProvider = WallSearchQueryProvider._();

final class WallSearchQueryProvider
    extends $NotifierProvider<WallSearchQuery, String> {
  WallSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wallSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wallSearchQueryHash();

  @$internal
  @override
  WallSearchQuery create() => WallSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$wallSearchQueryHash() => r'0181bbb5e2e078cce897e0c3b6871699dc34b213';

abstract class _$WallSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(wallSearchResults)
final wallSearchResultsProvider = WallSearchResultsProvider._();

final class WallSearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WallBook>>,
          List<WallBook>,
          FutureOr<List<WallBook>>
        >
    with $FutureModifier<List<WallBook>>, $FutureProvider<List<WallBook>> {
  WallSearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wallSearchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wallSearchResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<WallBook>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WallBook>> create(Ref ref) {
    return wallSearchResults(ref);
  }
}

String _$wallSearchResultsHash() => r'd753e2575c1def82ec5fb684e70bfcf21af03215';

@ProviderFor(wallTrendingResults)
final wallTrendingResultsProvider = WallTrendingResultsProvider._();

final class WallTrendingResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WallBook>>,
          List<WallBook>,
          FutureOr<List<WallBook>>
        >
    with $FutureModifier<List<WallBook>>, $FutureProvider<List<WallBook>> {
  WallTrendingResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wallTrendingResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wallTrendingResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<WallBook>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WallBook>> create(Ref ref) {
    return wallTrendingResults(ref);
  }
}

String _$wallTrendingResultsHash() =>
    r'8a30237189ed17612700c23363a91984fb202a61';
