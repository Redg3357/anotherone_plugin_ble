import 'anotherone_ble_platform_interface.dart';

class AnotheroneBle {
  Future<bool?> getAdapterPowered() {
    return AnotheroneBlePlatform.instance.getAdapterPowered();
  }

  Future<String?> getAdapterIdentifier() {
    return AnotheroneBlePlatform.instance.getAdapterIdentifier();
  }

  Future<List<String>?> getAdaptersList() {
    return AnotheroneBlePlatform.instance.getAdaptersList();
  }
}
