// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$availableInternshipsHash() =>
    r'b2c2f5cac5f7b742bdb491f59688cc984908640f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [availableInternships].
@ProviderFor(availableInternships)
const availableInternshipsProvider = AvailableInternshipsFamily();

/// See also [availableInternships].
class AvailableInternshipsFamily extends Family<AsyncValue<List<Internship>>> {
  /// See also [availableInternships].
  const AvailableInternshipsFamily();

  /// See also [availableInternships].
  AvailableInternshipsProvider call({
    String? query,
  }) {
    return AvailableInternshipsProvider(
      query: query,
    );
  }

  @override
  AvailableInternshipsProvider getProviderOverride(
    covariant AvailableInternshipsProvider provider,
  ) {
    return call(
      query: provider.query,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'availableInternshipsProvider';
}

/// See also [availableInternships].
class AvailableInternshipsProvider
    extends AutoDisposeFutureProvider<List<Internship>> {
  /// See also [availableInternships].
  AvailableInternshipsProvider({
    String? query,
  }) : this._internal(
          (ref) => availableInternships(
            ref as AvailableInternshipsRef,
            query: query,
          ),
          from: availableInternshipsProvider,
          name: r'availableInternshipsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$availableInternshipsHash,
          dependencies: AvailableInternshipsFamily._dependencies,
          allTransitiveDependencies:
              AvailableInternshipsFamily._allTransitiveDependencies,
          query: query,
        );

  AvailableInternshipsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String? query;

  @override
  Override overrideWith(
    FutureOr<List<Internship>> Function(AvailableInternshipsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AvailableInternshipsProvider._internal(
        (ref) => create(ref as AvailableInternshipsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Internship>> createElement() {
    return _AvailableInternshipsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableInternshipsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AvailableInternshipsRef
    on AutoDisposeFutureProviderRef<List<Internship>> {
  /// The parameter `query` of this provider.
  String? get query;
}

class _AvailableInternshipsProviderElement
    extends AutoDisposeFutureProviderElement<List<Internship>>
    with AvailableInternshipsRef {
  _AvailableInternshipsProviderElement(super.provider);

  @override
  String? get query => (origin as AvailableInternshipsProvider).query;
}

String _$studentApplicationsHash() =>
    r'ae816d5d7fccc29e674dceca0e1d728dc3b7768f';

/// See also [studentApplications].
@ProviderFor(studentApplications)
final studentApplicationsProvider =
    AutoDisposeFutureProvider<List<Application>>.internal(
  studentApplications,
  name: r'studentApplicationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$studentApplicationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StudentApplicationsRef
    = AutoDisposeFutureProviderRef<List<Application>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
