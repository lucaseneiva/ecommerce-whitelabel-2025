// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clientConfig)
const clientConfigProvider = ClientConfigProvider._();

final class ClientConfigProvider
    extends
        $FunctionalProvider<
          AsyncValue<ClientConfigModel>,
          ClientConfigModel,
          FutureOr<ClientConfigModel>
        >
    with
        $FutureModifier<ClientConfigModel>,
        $FutureProvider<ClientConfigModel> {
  const ClientConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientConfigHash();

  @$internal
  @override
  $FutureProviderElement<ClientConfigModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ClientConfigModel> create(Ref ref) {
    return clientConfig(ref);
  }
}

String _$clientConfigHash() => r'434a7f9db823a11ec38f04f76a43a5cfd28b63a0';
