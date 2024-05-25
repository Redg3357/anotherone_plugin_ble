import 'package:anotherone_ble/anotherone_ble_method_channel.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:anotherone_ble/modules/device.dart';
import 'package:flutter/services.dart';
import 'package:anotherone_ble/anotherone_ble.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> _changeState;

  bool _adapterPowered = false;
  bool _adapterDiscovering = false;
  String _adapterIdentifier = "Unknown";
  List<String> _pairedList = ['Unknown device'];
  List<BluetoothDevice> _scannedDevice = [];

  final _anotheroneBlePlugin = AnotheroneBle();
  StreamSubscription<BluetoothDevice?>? _scannedEventSubscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    getInfo();
  }

  Future<void> getInfo() async {
    bool adapterPowered;
    try {
      adapterPowered = await _anotheroneBlePlugin.getAdapterPowered() ?? false;
    } catch (e) {
      adapterPowered = false;
    }

    bool adapterDiscovering;
    try {
      adapterDiscovering =
          await _anotheroneBlePlugin.getAdapterDiscovering() ?? false;
    } catch (e) {
      adapterDiscovering = false;
    }

    String adapterIdentifier;
    try {
      adapterIdentifier =
          await _anotheroneBlePlugin.getAdapterIdentifier() ?? 'null';
    } catch (e) {
      adapterIdentifier = 'Failed to get information about identifier.';
    }

    List<String> pairedList;
    try {
      pairedList =
          await _anotheroneBlePlugin.getPairedList() ?? ['Unknown device'];
    } catch (e) {
      pairedList = ["Failed to get paired devices."];
    }

    if (!mounted) return;

    setState(() {
      _adapterPowered = adapterPowered;
      _adapterDiscovering = adapterDiscovering;
      _adapterIdentifier = adapterIdentifier;
      _pairedList = pairedList;
    });
  }

  Future<void> changePlatformState() async {
    await getInfo();
  }

  Future<void> startScanning() async {
    _scannedEventSubscription =
        _anotheroneBlePlugin.onScanning().listen((event) {
      setState(() {
        _scannedDevice.add(event!);
      });
    });
  }

  Future<void> stopScanning() async {
    _scannedEventSubscription?.cancel();
  }

  Future<void> clearScanned() async {
    _anotheroneBlePlugin.clearScanned();
    setState(() {
      _scannedDevice = []; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 53, 53, 53),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 250, 248, 143),
          title: const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Bluetooth Scanner Demo',
              style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bluetooth включен: $_adapterPowered',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              Text('Адрес устройства: $_adapterIdentifier',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              Text('Запущено сканирование: $_adapterDiscovering',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              Divider(color: Colors.white),
              Text('Сопряженные устройства:',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: _pairedList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _pairedList[index],
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    );
                  },
                ),
              ),
              Divider(color: Colors.white),
              Text('Обнаруженные устройства:',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: _scannedDevice.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Card(
                        color: Color.fromARGB(255, 53, 53, 53),
                        child: ListTile(
                          contentPadding: EdgeInsets.only(left: 2.0),
                          title: TextButton(
                            onPressed: () {
                              _anotheroneBlePlugin
                                  .deviceConnect(_scannedDevice[index].address);
                              changePlatformState();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_scannedDevice[index].address} ${_scannedDevice[index].name} ${_scannedDevice[index].rssi}',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 250, 248, 143),
                                      fontSize: 13),
                                ),
                                Text(
                                  'Подключено: ${_scannedDevice[index].connected} Сопряжено: ${_scannedDevice[index].paired}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
               mini: true,
              child: Icon(Icons.info, color: Color.fromARGB(255, 250, 248, 143), size: 25),
              backgroundColor: Color.fromARGB(255, 44, 44, 44),
              onPressed: () {
                setState(() {
                  changePlatformState();
                });
              },
            ),
            SizedBox(height: 10),
            FloatingActionButton(
               mini: true,
              child: Icon(Icons.search, color: Color.fromARGB(255, 250, 248, 143), size: 25),
              backgroundColor: Color.fromARGB(255, 44, 44, 44),
              onPressed: () {
                setState(() {
                  startScanning();
                  changePlatformState();
                });
              },
            ),
            SizedBox(height: 10),
            FloatingActionButton(
               mini: true,
              child: Icon(Icons.stop, color: Color.fromARGB(255, 250, 248, 143), size: 25),
              backgroundColor: Color.fromARGB(255, 44, 44, 44),
              onPressed: () {
                setState(() {
                  stopScanning();
                  changePlatformState();
                });
              },
            ),
            SizedBox(height: 10),
            FloatingActionButton(
               mini: true,
              child: Icon(Icons.delete, color: Color.fromARGB(255, 250, 248, 143), size: 25),
              backgroundColor: Color.fromARGB(255, 44, 44, 44),
              onPressed: () {
                setState(() {
                  clearScanned();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}