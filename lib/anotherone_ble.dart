import 'anotherone_ble_platform_interface.dart';

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
 

  Stream<String?> onScanning() {
    return AnotheroneBlePlatform.instance.onScanning();
  }
}
