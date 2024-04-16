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
  String _adapterIdentifier = "Unknown";
  List<String> _adaptersList = ['Unknown adapters'];
  List<String> _pairedList = ['Unknown device'];

  final _anotheroneBlePlugin = AnotheroneBle();

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

    String adapterIdentifier;
    try {
      adapterIdentifier =
          await _anotheroneBlePlugin.getAdapterIdentifier() ?? 'null';
    } catch (e) {
      adapterIdentifier = 'Failed to get information about identifier.';
    }

    List<String> adaptersList;
    try {
      adaptersList = await _anotheroneBlePlugin.getAdaptersList() ??
          ['Unknown adapter2222'];
      //adaptersList = ['Unknown', 'adapter', '2222'];
    } catch (e) {
      adaptersList = ["Failed to get adapters list."];
    }

    List<String> pairedList;
    try {
      pairedList = await _anotheroneBlePlugin.getPairedList() ?? ['Unknown device2222'];
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
      _adapterIdentifier = adapterIdentifier;
      _adaptersList = adaptersList;
      _pairedList = pairedList;
    });
  }

  Future<void> changePlatformState() async {
    await getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bluetooth adapter powered: $_adapterPowered\n'),
            Text('Bluetooth adapter identifier: $_adapterIdentifier\n'),
            Text(
              'Bluetooth adapters list:',
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _adaptersList
                  .map((item) => Text(
                        item,
                      ))
                  .toList(),
            ),
            Text(
              'Bluetooth paired devices:',
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _pairedList
                  .map((item) => Text(
                        item,
                      ))
                  .toList(),
            ),
            //Column(
            //  mainAxisAlignment: MainAxisAlignment.start, // Выравнивание элементов по началу столбца
            //  crossAxisAlignment: CrossAxisAlignment.start,
            //  children:  _adaptersList.map((adapter){
            //    return Text(adapter);
            //  }).toList())
            //Text('Bluetooth adapters list: ${_adaptersList.join(", ")}\n')
          ],
        )),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.info, color: Colors.black, size: 35),
          backgroundColor: Colors.white,
          onPressed: () {
            setState(() {
              _changeState = changePlatformState();
              //getNdef();
            });
          },
        ),
      ),
    );
  }
}
