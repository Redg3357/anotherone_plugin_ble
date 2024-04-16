import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'anotherone_ble_method_channel.dart';

abstract class AnotheroneBlePlatform extends PlatformInterface {
  /// Constructs a AnotheroneBlePlatform.
  AnotheroneBlePlatform() : super(token: _token);

  static final Object _token = Object();

  static AnotheroneBlePlatform _instance = MethodChannelAnotheroneBle();

  /// The default instance of [AnotheroneBlePlatform] to use.
  ///
  /// Defaults to [MethodChannelAnotheroneBle].
  static AnotheroneBlePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AnotheroneBlePlatform] when
  /// they register themselves.
  static set instance(AnotheroneBlePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> getAdapterPowered() {
    throw UnimplementedError('getAdapterPowered() has not been implemented.');
  }

  Future<String?> getAdapterIdentifier() {
    throw UnimplementedError(
        'getAdapterIdentifier() has not been implemented.');
  }

  Future<List<String>?> getAdaptersList() {
    throw UnimplementedError(
        'getAdaptersList() has not been implemented.');
  }

  Future<List<String>?> getPairedList() {
    throw UnimplementedError(
        'getPairedList() has not been implemented.');
  }


  Stream<bool?> getAdapterPoweredUpdate() {
        throw UnimplementedError(
        'getAdapterPoweredUpdate() has not been implemented.');
  }
}
