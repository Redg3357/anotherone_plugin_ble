
import 'anotherone_ble_platform_interface.dart';

class AnotheroneBle {
  Future<String?> getPlatformVersion() {
    return AnotheroneBlePlatform.instance.getPlatformVersion();
  }
}
