import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'anotherone_ble_platform_interface.dart';

/// An implementation of [AnotheroneBlePlatform] that uses method channels.
class MethodChannelAnotheroneBle extends AnotheroneBlePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('anotherone_ble');

  @override
  Future<bool?> getAdapterPowered() async {
    final adapterPowered =
        await methodChannel.invokeMethod<bool>('getAdapterPowered');
    return adapterPowered;
  }

  @override
  Future<String?> getAdapterIdentifier() async {
    final adapterIdentifier =
        await methodChannel.invokeMethod<String>('getAdapterIdentifier');
    return adapterIdentifier;
  }
}
