import 'package:anotherone_ble/anotherone_ble_method_channel.dart';

import 'anotherone_ble_platform_interface.dart';
import 'modules/device.dart';

class AnotheroneBle {
  Future<bool?> getAdapterPowered() {
    return AnotheroneBlePlatform.instance.getAdapterPowered();
  }

  Future<bool?> getAdapterDiscovering() {
    return AnotheroneBlePlatform.instance.getAdapterDiscovering();
  }

  Future<String?> getAdapterIdentifier() {
    return AnotheroneBlePlatform.instance.getAdapterIdentifier();
  }

  Future<List<String>?> getAdaptersList() {
    return AnotheroneBlePlatform.instance.getAdaptersList();
  }

  Future<List<String>?> getPairedList() {
    return AnotheroneBlePlatform.instance.getPairedList();    
  }
 
  Future<void> startScanning() {
    return AnotheroneBlePlatform.instance.startScanning();    
  }

  Future<void> stopScanning() {
    return AnotheroneBlePlatform.instance.stopScanning();    
  }

  Future<void> clearScanned() {
    return AnotheroneBlePlatform.instance.clearScanned();    
  }
 
  Stream<BluetoothDevice?> onScanning() {
    return AnotheroneBlePlatform.instance.onScanning();
  }

  Future<void> deviceConnect(String address) {
    return AnotheroneBlePlatform.instance.deviceConnect(address);
  }
}
