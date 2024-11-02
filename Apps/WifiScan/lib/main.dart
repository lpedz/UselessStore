import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  bool shouldCheckCan = true;

  bool get isStreaming => subscription != null;

  Future<void> _startScan(BuildContext context) async {
    if (shouldCheckCan) {
      final can = await WiFiScan.instance.canStartScan();
      if (can != CanStartScan.yes) {
        if (context.mounted) kShowSnackBar(context, "Cannot start scan: $can");
        return;
      }
    }

    final result = await WiFiScan.instance.startScan();
    if (context.mounted) kShowSnackBar(context, "Start Scan: $result");
    setState(() => accessPoints = <WiFiAccessPoint>[]);
  }

  Future<bool> _canGetScannedResults(BuildContext context) async {
    if (shouldCheckCan) {
      final can = await WiFiScan.instance.canGetScannedResults();
      if (can != CanGetScannedResults.yes) {
        if (context.mounted) {
          kShowSnackBar(context, "Cannot get scanned results: $can");
        }
        accessPoints = <WiFiAccessPoint>[];
        return false;
      }
    }
    return true;
  }

  Future<void> _getScannedResults(BuildContext context) async {
    if (await _canGetScannedResults(context)) {
      final results = await WiFiScan.instance.getScannedResults();
      setState(() => accessPoints = results);
    }
  }

  Future<void> _startListeningToScanResults(BuildContext context) async {
    if (await _canGetScannedResults(context)) {
      subscription = WiFiScan.instance.onScannedResultsAvailable
          .listen((result) => setState(() => accessPoints = result));
    }
  }

  void _stopListeningToScanResults() {
    subscription?.cancel();
    setState(() => subscription = null);
  }

  @override
  void dispose() {
    super.dispose();
    _stopListeningToScanResults();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [],
        ),
        body: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Available Networks',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.perm_scan_wifi),
                      label: const Text('SCAN'),
                      onPressed: () async => _startScan(context),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('GET'),
                      onPressed: () async => _getScannedResults(context),
                    ),
                  ],
                ),
                const Divider(height: 40),
                Expanded(
                  child: accessPoints.isEmpty
                      ? Center(
                          child: const Text("No Scanned Results",
                              style: TextStyle(fontSize: 18)))
                      : ListView.builder(
                          itemCount: accessPoints.length,
                          itemBuilder: (context, i) =>
                              _AccessPointTile(accessPoint: accessPoints[i]),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccessPointTile extends StatelessWidget {
  final WiFiAccessPoint accessPoint;

  const _AccessPointTile({Key? key, required this.accessPoint})
      : super(key: key);

  Widget _buildInfo(String label, dynamic value) => Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            Text(
              "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(child: Text(value.toString()))
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final title = accessPoint.ssid.isNotEmpty ? accessPoint.ssid : "**EMPTY**";
    final signalIcon = accessPoint.level >= -70
        ? Icons.signal_wifi_4_bar
        : accessPoint.level >= -80
            ? Icons.signal_wifi_4_bar
            : Icons.signal_wifi_0_bar;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: ListTile(
        visualDensity: VisualDensity.compact,
        leading: Icon(signalIcon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(accessPoint.capabilities),
        onTap: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInfo("BSSID", accessPoint.bssid),
                _buildInfo("Capability", accessPoint.capabilities),
                _buildInfo("Frequency", "${accessPoint.frequency} MHz"),
                _buildInfo("Level", accessPoint.level),
                _buildInfo("Standard", accessPoint.standard),
                _buildInfo("Center Frequency 0",
                    "${accessPoint.centerFrequency0} MHz"),
                _buildInfo("Center Frequency 1",
                    "${accessPoint.centerFrequency1} MHz"),
                _buildInfo("Channel Width", accessPoint.channelWidth),
                _buildInfo("Is Passpoint", accessPoint.isPasspoint),
                _buildInfo(
                    "Operator Friendly Name", accessPoint.operatorFriendlyName),
                _buildInfo("Venue Name", accessPoint.venueName),
                _buildInfo(
                    "Is 802.11mc Responder", accessPoint.is80211mcResponder),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void kShowSnackBar(BuildContext context, String message) {
  if (kDebugMode) print(message);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
