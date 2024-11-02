import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:appcheck/appcheck.dart';

void main() {
  runApp(const AppCheckExample());
}

class AppCheckExample extends StatefulWidget {
  const AppCheckExample({super.key});

  @override
  State<AppCheckExample> createState() => _AppCheckExampleState();
}

class _AppCheckExampleState extends State<AppCheckExample> {
  final appCheck = AppCheck();
  List<AppInfo>? installedApps;

  @override
  void initState() {
    super.initState();
    getApps();
  }

  // Fetch all installed apps
  Future<void> getApps() async {
    if (Platform.isAndroid) {
      // Get installed apps for Android
      installedApps = await appCheck.getInstalledApps();
      debugPrint(installedApps.toString());

      // Sort the installed apps by name (if needed)
      installedApps?.sort(
        (a, b) => a.appName!.toLowerCase().compareTo(b.appName!.toLowerCase()),
      );
    }

    // Update the state to refresh the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Installed Apps Count'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                getApps(); // Refresh the count of installed apps
              },
            ),
          ],
        ),
        body: Center(
          child: installedApps != null
              ? Text(
                  'Number of installed apps: ${installedApps!.length}',
                  style: const TextStyle(fontSize: 24),
                )
              : const Text(
                  'Fetching installed apps...',
                  style: TextStyle(fontSize: 24),
                ),
        ),
      ),
    );
  }
}
