// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeLocalBookStatuses)
final homeLocalBookStatusesProvider = HomeLocalBookStatusesProvider._();

final class HomeLocalBookStatusesProvider
    extends $NotifierProvider<HomeLocalBookStatuses, Map<String, ShelfStatus>> {
  HomeLocalBookStatusesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeLocalBookStatusesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeLocalBookStatusesHash();

  @$internal
  @override
  HomeLocalBookStatuses create() => HomeLocalBookStatuses();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, ShelfStatus> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, ShelfStatus>>(value),
    );
  }
}

String _$homeLocalBookStatusesHash() =>
    r'b9f03181370075dd7bb1de91cab7ba0128476ff8';

abstract class _$HomeLocalBookStatuses
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

@ProviderFor(homeHttpClient)
final homeHttpClientProvider = HomeHttpClientProvider._();

final class HomeHttpClientProvider
    extends $FunctionalProvider<http.Client, http.Client, http.Client>
    with $Provider<http.Client> {
  HomeHttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeHttpClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeHttpClientHash();

  @$internal
  @override
  $ProviderElement<http.Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  http.Client create(Ref ref) {
    return homeHttpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(http.Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<http.Client>(value),
    );
  }
}

String _$homeHttpClientHash() => r'41764b6df9696d20ad855101abfb80ba88f10310';

@ProviderFor(homeRepository)
final homeRepositoryProvider = HomeRepositoryProvider._();

final class HomeRepositoryProvider
    extends $FunctionalProvider<HomeRepository, HomeRepository, HomeRepository>
    with $Provider<HomeRepository> {
  HomeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeRepositoryHash();

  @$internal
  @override
  $ProviderElement<HomeRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HomeRepository create(Ref ref) {
    return homeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeRepository>(value),
    );
  }
}

String _$homeRepositoryHash() => r'3a70b5e925a60dde16977bafad66fbc2ea6ab17e';

@ProviderFor(HomeSearchQuery)
final homeSearchQueryProvider = HomeSearchQueryProvider._();

final class HomeSearchQueryProvider
    extends $NotifierProvider<HomeSearchQuery, String> {
  HomeSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeSearchQueryHash();

  @$internal
  @override
  HomeSearchQuery create() => HomeSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$homeSearchQueryHash() => r'5d89c8143a996a3e333487b631f45674c5faa8bd';

abstract class _$HomeSearchQuery extends $Notifier<String> {
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

@ProviderFor(HomeViewMode)
final homeViewModeProvider = HomeViewModeProvider._();

final class HomeViewModeProvider
    extends $NotifierProvider<HomeViewMode, HomeBooksViewMode> {
  HomeViewModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeViewModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeViewModeHash();

  @$internal
  @override
  HomeViewMode create() => HomeViewMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeBooksViewMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeBooksViewMode>(value),
    );
  }
}

String _$homeViewModeHash() => r'286694e2d59c950859866e5a9a5c88a859e7e3e2';

abstract class _$HomeViewMode extends $Notifier<HomeBooksViewMode> {
  HomeBooksViewMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<HomeBooksViewMode, HomeBooksViewMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomeBooksViewMode, HomeBooksViewMode>,
              HomeBooksViewMode,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(homeSearchResults)
final homeSearchResultsProvider = HomeSearchResultsProvider._();

final class HomeSearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HomeBook>>,
          List<HomeBook>,
          FutureOr<List<HomeBook>>
        >
    with $FutureModifier<List<HomeBook>>, $FutureProvider<List<HomeBook>> {
  HomeSearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeSearchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeSearchResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<HomeBook>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HomeBook>> create(Ref ref) {
    return homeSearchResults(ref);
  }
}

String _$homeSearchResultsHash() => r'7cf9820b0e91178792567635a5f25bdd9b99e86e';

@ProviderFor(homeTrendingResults)
final homeTrendingResultsProvider = HomeTrendingResultsProvider._();

final class HomeTrendingResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HomeBook>>,
          List<HomeBook>,
          FutureOr<List<HomeBook>>
        >
    with $FutureModifier<List<HomeBook>>, $FutureProvider<List<HomeBook>> {
  HomeTrendingResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeTrendingResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeTrendingResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<HomeBook>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HomeBook>> create(Ref ref) {
    return homeTrendingResults(ref);
  }
}

String _$homeTrendingResultsHash() =>
    r'eb1830eb4d68d63e3257e75a38c22da8d6b11698';

@ProviderFor(homeBookDetails)
final homeBookDetailsProvider = HomeBookDetailsFamily._();

final class HomeBookDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<HomeBookDetails>,
          HomeBookDetails,
          FutureOr<HomeBookDetails>
        >
    with $FutureModifier<HomeBookDetails>, $FutureProvider<HomeBookDetails> {
  HomeBookDetailsProvider._({
    required HomeBookDetailsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'homeBookDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$homeBookDetailsHash();

  @override
  String toString() {
    return r'homeBookDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<HomeBookDetails> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HomeBookDetails> create(Ref ref) {
    final argument = this.argument as String;
    return homeBookDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HomeBookDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$homeBookDetailsHash() => r'a278e5619aa26adaf9e23e461615eb5f63bb6e32';

final class HomeBookDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<HomeBookDetails>, String> {
  HomeBookDetailsFamily._()
    : super(
        retry: null,
        name: r'homeBookDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HomeBookDetailsProvider call(String bookId) =>
      HomeBookDetailsProvider._(argument: bookId, from: this);

  @override
  String toString() => r'homeBookDetailsProvider';
}

@ProviderFor(homeBookStatus)
final homeBookStatusProvider = HomeBookStatusFamily._();

final class HomeBookStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<ShelfStatus?>,
          ShelfStatus?,
          FutureOr<ShelfStatus?>
        >
    with $FutureModifier<ShelfStatus?>, $FutureProvider<ShelfStatus?> {
  HomeBookStatusProvider._({
    required HomeBookStatusFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'homeBookStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$homeBookStatusHash();

  @override
  String toString() {
    return r'homeBookStatusProvider'
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
    return homeBookStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HomeBookStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$homeBookStatusHash() => r'46c0eedd7386bb9c1c29f8574adcfdb8c10cccbd';

final class HomeBookStatusFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ShelfStatus?>, String> {
  HomeBookStatusFamily._()
    : super(
        retry: null,
        name: r'homeBookStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HomeBookStatusProvider call(String bookId) =>
      HomeBookStatusProvider._(argument: bookId, from: this);

  @override
  String toString() => r'homeBookStatusProvider';
}

@ProviderFor(homeShelfBook)
final homeShelfBookProvider = HomeShelfBookFamily._();

final class HomeShelfBookProvider
    extends
        $FunctionalProvider<
          AsyncValue<ShelfBook?>,
          ShelfBook?,
          FutureOr<ShelfBook?>
        >
    with $FutureModifier<ShelfBook?>, $FutureProvider<ShelfBook?> {
  HomeShelfBookProvider._({
    required HomeShelfBookFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'homeShelfBookProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$homeShelfBookHash();

  @override
  String toString() {
    return r'homeShelfBookProvider'
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
    return homeShelfBook(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HomeShelfBookProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$homeShelfBookHash() => r'62780b45eb4b605ebf3e615fa6f2ec97d42987fa';

final class HomeShelfBookFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ShelfBook?>, String> {
  HomeShelfBookFamily._()
    : super(
        retry: null,
        name: r'homeShelfBookProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HomeShelfBookProvider call(String bookId) =>
      HomeShelfBookProvider._(argument: bookId, from: this);

  @override
  String toString() => r'homeShelfBookProvider';
}

@ProviderFor(homeBookStatuses)
final homeBookStatusesProvider = HomeBookStatusesProvider._();

final class HomeBookStatusesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, ShelfStatus>>,
          Map<String, ShelfStatus>,
          FutureOr<Map<String, ShelfStatus>>
        >
    with
        $FutureModifier<Map<String, ShelfStatus>>,
        $FutureProvider<Map<String, ShelfStatus>> {
  HomeBookStatusesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeBookStatusesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeBookStatusesHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, ShelfStatus>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, ShelfStatus>> create(Ref ref) {
    return homeBookStatuses(ref);
  }
}

String _$homeBookStatusesHash() => r'a23cf4bd0c1b706729b68c849be62c7d88a420af';

@ProviderFor(HomeShelfActionController)
final homeShelfActionControllerProvider = HomeShelfActionControllerProvider._();

final class HomeShelfActionControllerProvider
    extends $AsyncNotifierProvider<HomeShelfActionController, void> {
  HomeShelfActionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeShelfActionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeShelfActionControllerHash();

  @$internal
  @override
  HomeShelfActionController create() => HomeShelfActionController();
}

String _$homeShelfActionControllerHash() =>
    r'38b016dca495e5519ad8114edd421e43b5d83629';

abstract class _$HomeShelfActionController extends $AsyncNotifier<void> {
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

@ProviderFor(HomeReadingProgressController)
final homeReadingProgressControllerProvider =
    HomeReadingProgressControllerProvider._();

final class HomeReadingProgressControllerProvider
    extends $AsyncNotifierProvider<HomeReadingProgressController, void> {
  HomeReadingProgressControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeReadingProgressControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeReadingProgressControllerHash();

  @$internal
  @override
  HomeReadingProgressController create() => HomeReadingProgressController();
}

String _$homeReadingProgressControllerHash() =>
    r'6e4abb19ec7359d33136830869c8a6b0d12fa795';

abstract class _$HomeReadingProgressController extends $AsyncNotifier<void> {
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
