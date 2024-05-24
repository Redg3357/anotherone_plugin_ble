import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'anotherone_ble_platform_interface.dart';

import 'modules/device.dart';

/// An implementation of [AnotheroneBlePlatform] that uses method channels.
class MethodChannelAnotheroneBle extends AnotheroneBlePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('anotherone_ble_methods');
  final eventScanningChannel = const EventChannel('anotherone_ble_event_scanning');
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
  Future<bool?> getAdapterDiscovering() async {
    final adapterDiscovering =
        await methodChannel.invokeMethod<bool>('getAdapterDiscovering');
    return adapterDiscovering;
  }

  @override
  Future<String?> getAdapterIdentifier() async {
    final adapterIdentifier =
        await methodChannel.invokeMethod<String>('getAdapterIdentifier');
    return adapterIdentifier;
  }

  @override
  Future<List<String>?> getAdaptersList() async {
    final adaptersListString =
        await methodChannel.invokeMethod<String>('getAdaptersList');
    List<String>? adaptersList = splitToList(adaptersListString!, '&');
    return adaptersList;
  }

  @override
  Future<List<String>?> getPairedList() async {
    final pairedListString =
        await methodChannel.invokeMethod<String>('getPairedList');
    List<String>? pairedList = splitToList(pairedListString!, '&');
    return pairedList;
  }

  @override
  Future<void> startScanning() async {
    await methodChannel.invokeMethod<void>('startScanning');
  }

    @override
  Future<void> stopScanning() async {
    await methodChannel.invokeMethod<void>('stopScanning');
  }
  //Stream<List<String>>? _onScanning;

  @override
  Stream<BluetoothDevice?> onScanning() {
    return eventScanningChannel.receiveBroadcastStream().map((event) => BluetoothDevice.fromString(event as String));
  }
  
  @override
  Future<void> deviceConnect(String address) async {
      await methodChannel.invokeMethod('deviceConnect',<String, String>{
        'address' : address
      });
  }

}

