import 'package:flutter/material.dart';

void main() {
  runApp(AppStoreApp());
}

class AppStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppStoreHome(),
    );
  }
}

class AppStoreHome extends StatelessWidget {
  final List<Map<String, String>> apps = [
    {"name": "Flash", "icon": "assets/flsh.jpg", "apk": "assets/flash.apk"},
    {
      "name": "App Counter",
      "icon": "assets/count.jpg",
      "apk": "assets/app2.apk"
    },
    {"name": "Games", "icon": "assets/loading.jpg", "apk": "assets/app3.apk"},
    {"name": "Orange", "icon": "assets/orange.jpg", "apk": "assets/app4.apk"},
    {
      "name": "Wifi Scanner",
      "icon": "assets/wifi.jpg",
      "apk": "assets/app5.apk"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Change background color to white
      appBar: AppBar(
        title: Text('App Store'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality here
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: apps.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Show install dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Install ${apps[index]["name"]!}"),
                    content: Text("Do you want to install ${apps[index]["name"]}?"),
                    actions: [
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("Install"),
                        onPressed: () {
                          // Handle installation logic
                          installApk(apps[index]["apk"]!);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Card(
              color: Colors.grey[850],
              elevation: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      apps[index]["icon"]!,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    apps[index]["name"]!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.grey[900],
        onTap: (index) {
          // Handle bottom navigation taps
        },
      ),
    );
  }

  void installApk(String apkPath) {
    // This is where you would handle the APK installation
    // Since direct installation is not supported in Flutter,
    // you might need to use a plugin like open_file or platform channels.
    print("Installing APK from $apkPath"); // Placeholder for installation logic
  }
}
