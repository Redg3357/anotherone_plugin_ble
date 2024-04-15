import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'anotherone_ble_platform_interface.dart';

/// An implementation of [AnotheroneBlePlatform] that uses method channels.
class MethodChannelAnotheroneBle extends AnotheroneBlePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('anotherone_ble');

  List<String> splitToList(String? splitingString, String splitSymbol) {
    final splittedList = splitingString!.split(splitSymbol);
    splittedList.removeWhere((element) => element.isEmpty);
    return splittedList;
  }

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

    @override
  Future<List<String>?> getAdaptersList() async {
    final adaptersListString = await methodChannel.invokeMethod<String>('getAdaptersList');
    List<String>? adaptersList = splitToList(adaptersListString!,'&');
    return adaptersList;
  }
}
