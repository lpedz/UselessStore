import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fake Loading Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FakeLoadingScreen(),
    );
  }
}

class FakeLoadingScreen extends StatefulWidget {
  @override
  _FakeLoadingScreenState createState() => _FakeLoadingScreenState();
}

class _FakeLoadingScreenState extends State<FakeLoadingScreen> {
  int _elapsedSeconds = 0;   // Variable to track elapsed seconds
  late Timer _loadingTimer;   // Timer for loading messages
  late Timer _elapsedTimer;    // Timer for elapsed seconds
  List<String> _messages = [
    "Loading your thoughts...",
    "Just a moment...",
    "Please wait while we gather the data...",
    "Thinking really hard...",
    "Did you know? Turtles breathe through their butts!",
    "Your cat is judging you...",
    "Loading the secrets of the universe...",
    "Hang tight! We're almost there...",
    "This is taking longer than expected...",
    "Why do we even need to load?",
    "Checking if the cake is a lie...",
    "Channeling my inner sloth...",
    "Loading your favorite pizza toppings...",
    "Sifting through cat memes...",
    "Gathering data from the intergalactic space cat...",
    "Doing backflips while loading...",
    "Searching for WiFi in the Bermuda Triangle...",
    "Not all who wander are lost, but we definitely are...",
    "Loading... or just contemplating existence?",
    "Counting sheep to make sure everything is okay...",
    "Loading your future (it’s bright, I promise!)",
  ];

  String _currentMessage = "";

  @override
  void initState() {
    super.initState();
    _startLoading();
    _startElapsedTimer();
  }

  void _startLoading() {
    _loadingTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentMessage = _messages[(timer.tick - 1) % _messages.length];
      });
    });
  }

  void _startElapsedTimer() {
    _elapsedTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  @override
  void dispose() {
    _loadingTimer.cancel();
    _elapsedTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              _currentMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Waiting for $_elapsedSeconds seconds...",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
