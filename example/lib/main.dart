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
  //List<String> _adaptersList = ['Unknown adapters'];
  List<String> _pairedList = ['Unknown device'];
  List<BluetoothDevice> _scannedDevice = [];
  List<int> _it = [1, 2, 3, 4, 5, 6];

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

    //List<String> adaptersList;
    //try {
    //  adaptersList = await _anotheroneBlePlugin.getAdaptersList() ??
    //      ['Unknown adapter2222'];
    //  //adaptersList = ['Unknown', 'adapter', '2222'];
    //} catch (e) {
    //  adaptersList = ["Failed to get adapters list."];
    //}

    List<String> pairedList;
    try {
      pairedList =
          await _anotheroneBlePlugin.getPairedList() ?? ['Unknown device2222'];
      //adaptersList = ['Unknown', 'adapter', '2222'];
    } catch (e) {
      pairedList = ["Failed to get paired devices."];
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _adapterPowered = adapterPowered;
      _adapterDiscovering = adapterDiscovering;
      _adapterIdentifier = adapterIdentifier;
      //_adaptersList = adaptersList;
      _pairedList = pairedList;
    });
  }

  Future<void> changePlatformState() async {
    await getInfo();
  }

  //Future<void> connect(String address) async {
  //  _anotheroneBlePlugin.deviceConnect(address);
  //}

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 53, 53, 53),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 250, 248, 143),
          title: const Text(
            'Bluetooth plugin example',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ListView(
            children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text('Bluetooth adapter powered: $_adapterPowered\n',
                  style: TextStyle(color: Colors.white, fontSize: 10)),
              Text('Bluetooth adapter discovering: $_adapterDiscovering\n',
                  style: TextStyle(color: Colors.white, fontSize: 10)),
              Text('Bluetooth adapter identifier: $_adapterIdentifier\n',
                  style: TextStyle(color: Colors.white, fontSize: 10)),
              Text(
                'Bluetooth adapters list:',
              ),
              //Column(
              //  crossAxisAlignment: CrossAxisAlignment.center,
              //  children: _adaptersList
              //      .map((item) => Text(
              //            item,
              //          ))
              //      .toList(),
              //),
              Text('Bluetooth paired devices:',
                  style: TextStyle(color: Colors.white, fontSize: 10)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _pairedList
                    .map((item) => Text(item,
                        style: TextStyle(color: Colors.white, fontSize: 10)))
                    .toList(),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 250, 248, 143)),
                ),
                onPressed: () {
                  setState(() {
                    //if (!_adapterDiscovering) startScanning();
                    startScanning();
                    print("dart: debug from here");
                    changePlatformState();
                  });
                },
                child: Text('Start scanning'),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 250, 248, 143)),
                ),
                onPressed: () {
                  setState(() {
                    print("dart: before stop scanning");
                    stopScanning();
                    print("dart: after stop scanning");
                    changePlatformState();
                  });
                },
                child: Text('Stop scanning'),
              ),
              Text('Scanning:',
                  style: TextStyle(color: Colors.white, fontSize: 10)),
              //ListView.builder(
              //    itemCount: _it.length,
              //    itemBuilder: (contex, index) {
              //      return Container(
              //        height: 20,
              //        child: Text((_it[index]).toString(),
              //            style: TextStyle(color: Colors.white, fontSize: 8)),
              //      );
              //    }),
              Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: _scannedDevice
                      .map((item) => SizedBox(
                          height: 15,
                          child: TextButton(
                              onPressed: () {
                                changePlatformState();
                                _anotheroneBlePlugin.deviceConnect('${item.address}');
                              },
                              child: Text(
                                  '${item.address} ${item.name} ${item.rssi} C: ${item.connected} P: ${item.paired} ',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 250, 248, 143),
                                      fontSize: 8)))))
                      .toList()
          
                  //TextButton(onPressed: (){},
                  //  child: Text(
                  //    item,
                  //      style: TextStyle(color: Color.fromARGB(255, 250, 248, 143), fontSize: 8))
                  //  )
                  //).toList(),
                  ),
            ],
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.info, color: Colors.white, size: 35),
          backgroundColor: Colors.black,
          onPressed: () {
            setState(() {
              //_changeState = changePlatformState();
              //_anotheroneBlePlugin.stopScanning();
              changePlatformState();
            });
          },
        ),
      ),
    );
  }
}
