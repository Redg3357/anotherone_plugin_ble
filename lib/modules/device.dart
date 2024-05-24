class BluetoothDevice {
  String address;
  String name;
  String rssi;
  bool paired;
  bool connected;
  String alias;

  BluetoothDevice(this.address, this.name, this.rssi, this.paired, this.connected, this.alias);

  factory BluetoothDevice.fromString(String eventScanningChannel){
  List<String> properties = eventScanningChannel.split('/');

  return BluetoothDevice(properties[0],
                        properties[1].length > 1 ? properties[1] : 'not readable',
                        properties[2],
                        properties[3] == '1' ? true : false,
                        properties[4] == '1' ? true : false,
                        properties[5] );
  }
}