import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashlight App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FlashlightHomePage(),
    );
  }
}

class FlashlightHomePage extends StatefulWidget {
  const FlashlightHomePage({super.key});

  @override
  _FlashlightHomePageState createState() => _FlashlightHomePageState();
}

class _FlashlightHomePageState extends State<FlashlightHomePage> {
  bool _isFlashlightOn = false;

  void _toggleFlashlight() async {
    try {
      if (_isFlashlightOn) {
        await TorchLight.disableTorch(); // Method to turn off the flashlight
      } else {
        await TorchLight.enableTorch(); // Method to turn on the flashlight
      }
      setState(() {
        _isFlashlightOn = !_isFlashlightOn;
      });
    } catch (e) {
      // Handle any errors that may occur
      print("Error toggling flashlight: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashlight App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _toggleFlashlight,
          child: Text(_isFlashlightOn ? 'Turn Off' : 'Turn On'),
        ),
      ),
    );
  }
}