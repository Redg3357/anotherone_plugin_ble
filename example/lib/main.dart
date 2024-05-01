import 'package:flutter/material.dart';
import 'dart:async';

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

  List<String> _scannedDevice = [''];

  final _anotheroneBlePlugin = AnotheroneBle();
  StreamSubscription<String?>? _scannedEventSubscription;
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
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bluetooth adapter powered: $_adapterPowered\n',
                style: TextStyle(color: Colors.black, fontSize: 10)),
            Text('Bluetooth adapter discovering: $_adapterDiscovering\n',
                style: TextStyle(color: Colors.black, fontSize: 10)),
            Text('Bluetooth adapter identifier: $_adapterIdentifier\n',
                style: TextStyle(color: Colors.black, fontSize: 10)),
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
                style: TextStyle(color: Colors.black, fontSize: 10)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _pairedList
                  .map((item) => Text(item,
                      style: TextStyle(color: Colors.black, fontSize: 10)))
                  .toList(),
            ),
            Text('Scanning:',
                style: TextStyle(color: Colors.black, fontSize: 10)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _scannedDevice
                  .map((item) => Text(item,
                      style: TextStyle(color: Colors.black, fontSize: 10)))
                  .toList(),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                setState(() {
                  //if (!_adapterDiscovering) startScanning();
                  startScanning();
                });
              },
              child: Text('Start scanning'),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                setState(() {
                  changePlatformState();
                });
              },
              child: Text('Update'),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.info, color: Colors.black, size: 35),
          backgroundColor: Colors.white,
          onPressed: () {
            setState(() {
              //_changeState = changePlatformState();
              //_anotheroneBlePlugin.stopScanning();
              stopScanning();
            });
          },
        ),
      ),
    );
  }
}
