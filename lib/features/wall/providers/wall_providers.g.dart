// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wall_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WallLocalBookStatuses)
final wallLocalBookStatusesProvider = WallLocalBookStatusesProvider._();

final class WallLocalBookStatusesProvider
    extends $NotifierProvider<WallLocalBookStatuses, Map<String, ShelfStatus>> {
  WallLocalBookStatusesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wallLocalBookStatusesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wallLocalBookStatusesHash();

  @$internal
  @override
  WallLocalBookStatuses create() => WallLocalBookStatuses();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, ShelfStatus> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, ShelfStatus>>(value),
    );
  }
}

String _$wallLocalBookStatusesHash() =>
    r'1c648b68df5990fe6855433d7982156f76a52a19';

abstract class _$WallLocalBookStatuses
    extends $Notifier<Map<String, ShelfStatus>> {
  Map<String, ShelfStatus> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<Map<String, ShelfStatus>, Map<String, ShelfStatus>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, ShelfStatus>, Map<String, ShelfStatus>>,
              Map<String, ShelfStatus>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

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

String _$wallRepositoryHash() => r'3e6f5b74dce0aa47d37ad28f28065d686f8ba0d4';

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

@ProviderFor(WallViewMode)
final wallViewModeProvider = WallViewModeProvider._();

final class WallViewModeProvider
    extends $NotifierProvider<WallViewMode, WallBooksViewMode> {
  WallViewModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wallViewModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wallViewModeHash();

  @$internal
  @override
  WallViewMode create() => WallViewMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WallBooksViewMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WallBooksViewMode>(value),
    );
  }
}

String _$wallViewModeHash() => r'2a132700724c9b9f60408da9f45d0fa2e2cf6699';

abstract class _$WallViewMode extends $Notifier<WallBooksViewMode> {
  WallBooksViewMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<WallBooksViewMode, WallBooksViewMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WallBooksViewMode, WallBooksViewMode>,
              WallBooksViewMode,
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

@ProviderFor(wallBookDetails)
final wallBookDetailsProvider = WallBookDetailsFamily._();

final class WallBookDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<WallBookDetails>,
          WallBookDetails,
          FutureOr<WallBookDetails>
        >
    with $FutureModifier<WallBookDetails>, $FutureProvider<WallBookDetails> {
  WallBookDetailsProvider._({
    required WallBookDetailsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'wallBookDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$wallBookDetailsHash();

  @override
  String toString() {
    return r'wallBookDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<WallBookDetails> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WallBookDetails> create(Ref ref) {
    final argument = this.argument as String;
    return wallBookDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WallBookDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$wallBookDetailsHash() => r'78b6ffe8a666c2fe3eb829d9d2287393ea3fbf43';

final class WallBookDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<WallBookDetails>, String> {
  WallBookDetailsFamily._()
    : super(
        retry: null,
        name: r'wallBookDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WallBookDetailsProvider call(String bookId) =>
      WallBookDetailsProvider._(argument: bookId, from: this);

  @override
  String toString() => r'wallBookDetailsProvider';
}

@ProviderFor(wallBookStatus)
final wallBookStatusProvider = WallBookStatusFamily._();

final class WallBookStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<ShelfStatus?>,
          ShelfStatus?,
          FutureOr<ShelfStatus?>
        >
    with $FutureModifier<ShelfStatus?>, $FutureProvider<ShelfStatus?> {
  WallBookStatusProvider._({
    required WallBookStatusFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'wallBookStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$wallBookStatusHash();

  @override
  String toString() {
    return r'wallBookStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ShelfStatus?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ShelfStatus?> create(Ref ref) {
    final argument = this.argument as String;
    return wallBookStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WallBookStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$wallBookStatusHash() => r'6dad16e0cbc4d4bf138228ad145a131d8729a34f';

final class WallBookStatusFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ShelfStatus?>, String> {
  WallBookStatusFamily._()
    : super(
        retry: null,
        name: r'wallBookStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WallBookStatusProvider call(String bookId) =>
      WallBookStatusProvider._(argument: bookId, from: this);

  @override
  String toString() => r'wallBookStatusProvider';
}

@ProviderFor(wallShelfBook)
final wallShelfBookProvider = WallShelfBookFamily._();

final class WallShelfBookProvider
    extends
        $FunctionalProvider<
          AsyncValue<ShelfBook?>,
          ShelfBook?,
          FutureOr<ShelfBook?>
        >
    with $FutureModifier<ShelfBook?>, $FutureProvider<ShelfBook?> {
  WallShelfBookProvider._({
    required WallShelfBookFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'wallShelfBookProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$wallShelfBookHash();

  @override
  String toString() {
    return r'wallShelfBookProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ShelfBook?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ShelfBook?> create(Ref ref) {
    final argument = this.argument as String;
    return wallShelfBook(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WallShelfBookProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$wallShelfBookHash() => r'14f2073971870c6eba45e2d5c777f77a955fc5d6';

final class WallShelfBookFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ShelfBook?>, String> {
  WallShelfBookFamily._()
    : super(
        retry: null,
        name: r'wallShelfBookProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WallShelfBookProvider call(String bookId) =>
      WallShelfBookProvider._(argument: bookId, from: this);

  @override
  String toString() => r'wallShelfBookProvider';
}

@ProviderFor(wallBookStatuses)
final wallBookStatusesProvider = WallBookStatusesProvider._();

final class WallBookStatusesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, ShelfStatus>>,
          Map<String, ShelfStatus>,
          FutureOr<Map<String, ShelfStatus>>
        >
    with
        $FutureModifier<Map<String, ShelfStatus>>,
        $FutureProvider<Map<String, ShelfStatus>> {
  WallBookStatusesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wallBookStatusesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wallBookStatusesHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, ShelfStatus>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, ShelfStatus>> create(Ref ref) {
    return wallBookStatuses(ref);
  }
}

String _$wallBookStatusesHash() => r'612f4657a7c0dea0db6cf324ea913582fce52d16';

@ProviderFor(WallShelfActionController)
final wallShelfActionControllerProvider = WallShelfActionControllerProvider._();

final class WallShelfActionControllerProvider
    extends $AsyncNotifierProvider<WallShelfActionController, void> {
  WallShelfActionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wallShelfActionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wallShelfActionControllerHash();

  @$internal
  @override
  WallShelfActionController create() => WallShelfActionController();
}

String _$wallShelfActionControllerHash() =>
    r'29af1a5428cb25d1c2126f8ae6db403d088eda88';

abstract class _$WallShelfActionController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(WallReadingProgressController)
final wallReadingProgressControllerProvider =
    WallReadingProgressControllerProvider._();

final class WallReadingProgressControllerProvider
    extends $AsyncNotifierProvider<WallReadingProgressController, void> {
  WallReadingProgressControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wallReadingProgressControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wallReadingProgressControllerHash();

  @$internal
  @override
  WallReadingProgressController create() => WallReadingProgressController();
}

String _$wallReadingProgressControllerHash() =>
    r'd17f1910fd5a5976dccf49c35fa4104b29fad1f1';

abstract class _$WallReadingProgressController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
