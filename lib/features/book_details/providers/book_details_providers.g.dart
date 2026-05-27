// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_details_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookDetails)
final bookDetailsProvider = BookDetailsFamily._();

final class BookDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<HomeBookDetails>,
          HomeBookDetails,
          FutureOr<HomeBookDetails>
        >
    with $FutureModifier<HomeBookDetails>, $FutureProvider<HomeBookDetails> {
  BookDetailsProvider._({
    required BookDetailsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bookDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookDetailsHash();

  @override
  String toString() {
    return r'bookDetailsProvider'
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
    return bookDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BookDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookDetailsHash() => r'f0ca1f777ada0e0c6117e22d43e81cf8227b0d77';

final class BookDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<HomeBookDetails>, String> {
  BookDetailsFamily._()
    : super(
        retry: null,
        name: r'bookDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BookDetailsProvider call(String bookId) =>
      BookDetailsProvider._(argument: bookId, from: this);

  @override
  String toString() => r'bookDetailsProvider';
}

@ProviderFor(bookShelfStatus)
final bookShelfStatusProvider = BookShelfStatusFamily._();

final class BookShelfStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<ShelfStatus?>,
          ShelfStatus?,
          FutureOr<ShelfStatus?>
        >
    with $FutureModifier<ShelfStatus?>, $FutureProvider<ShelfStatus?> {
  BookShelfStatusProvider._({
    required BookShelfStatusFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bookShelfStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookShelfStatusHash();

  @override
  String toString() {
    return r'bookShelfStatusProvider'
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
    return bookShelfStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BookShelfStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookShelfStatusHash() => r'826425117401ce930b49a011ae0c4e91e0eacdd1';

final class BookShelfStatusFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ShelfStatus?>, String> {
  BookShelfStatusFamily._()
    : super(
        retry: null,
        name: r'bookShelfStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BookShelfStatusProvider call(String bookId) =>
      BookShelfStatusProvider._(argument: bookId, from: this);

  @override
  String toString() => r'bookShelfStatusProvider';
}

@ProviderFor(bookShelfEntry)
final bookShelfEntryProvider = BookShelfEntryFamily._();

final class BookShelfEntryProvider
    extends
        $FunctionalProvider<
          AsyncValue<ShelfBook?>,
          ShelfBook?,
          FutureOr<ShelfBook?>
        >
    with $FutureModifier<ShelfBook?>, $FutureProvider<ShelfBook?> {
  BookShelfEntryProvider._({
    required BookShelfEntryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bookShelfEntryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookShelfEntryHash();

  @override
  String toString() {
    return r'bookShelfEntryProvider'
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
    return bookShelfEntry(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BookShelfEntryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookShelfEntryHash() => r'14286e6b736ecc8a6eb306cc3d55500cd6227bd5';

final class BookShelfEntryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ShelfBook?>, String> {
  BookShelfEntryFamily._()
    : super(
        retry: null,
        name: r'bookShelfEntryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BookShelfEntryProvider call(String bookId) =>
      BookShelfEntryProvider._(argument: bookId, from: this);

  @override
  String toString() => r'bookShelfEntryProvider';
}

@ProviderFor(BookShelfActionController)
final bookShelfActionControllerProvider = BookShelfActionControllerProvider._();

final class BookShelfActionControllerProvider
    extends $AsyncNotifierProvider<BookShelfActionController, void> {
  BookShelfActionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookShelfActionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookShelfActionControllerHash();

  @$internal
  @override
  BookShelfActionController create() => BookShelfActionController();
}

String _$bookShelfActionControllerHash() =>
    r'8d201cf07c3cc930f55fbf838ddd0451023e658a';

abstract class _$BookShelfActionController extends $AsyncNotifier<void> {
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

@ProviderFor(BookReadingProgressController)
final bookReadingProgressControllerProvider =
    BookReadingProgressControllerProvider._();

final class BookReadingProgressControllerProvider
    extends $AsyncNotifierProvider<BookReadingProgressController, void> {
  BookReadingProgressControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookReadingProgressControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookReadingProgressControllerHash();

  @$internal
  @override
  BookReadingProgressController create() => BookReadingProgressController();
}

String _$bookReadingProgressControllerHash() =>
    r'36809be13c6e0b8e433a2182cc8fe9532c56b2b8';

abstract class _$BookReadingProgressController extends $AsyncNotifier<void> {
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
