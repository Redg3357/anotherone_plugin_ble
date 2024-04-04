import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'anotherone_ble_platform_interface.dart';

/// An implementation of [AnotheroneBlePlatform] that uses method channels.
class MethodChannelAnotheroneBle extends AnotheroneBlePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('anotherone_ble');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
