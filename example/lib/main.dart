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
  bool _adapterPowered = false;
  String _adapterIdentifier = "Unknown";
  final _anotheroneBlePlugin = AnotheroneBle();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
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
    } on PlatformException {
      adapterIdentifier = 'Failed to get information about identifier.';
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _adapterPowered = adapterPowered;
      _adapterIdentifier = adapterIdentifier;
    });
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
            Text('Bluetooth adapter identifier: $_adapterIdentifier\n')
          ],
        )),
      ),
    );
  }
}
