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
    {
      "name": "Flash",
      "icon": "assets/flsh.jpg",
      "apk": "https://files.catbox.moe/4y3gce.apk"
    },
    {
      "name": "App Counter",
      "icon": "assets/count.jpg",
      "apk": "https://files.catbox.moe/tb487f.apk"
    },
    {
      "name": "Games",
      "icon": "assets/loading.jpg",
      "apk": "https://files.catbox.moe/78ib4o.apk"
    },
    {
      "name": "Orange",
      "icon": "assets/orange.jpg",
      "apk": "https://files.catbox.moe/4yne3v.apk"
    },
    {
      "name": "Wifi Scanner",
      "icon": "assets/wifi.jpg",
      "apk": "https://files.catbox.moe/j195f7.apk"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('App Store'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
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
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                        "Go to the link below to download:\n\n${apps[index]["apk"]}"),
                    actions: [
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
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
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
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
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      print("APK Path: ${apps[index]["apk"]}");
                    },
                    child: Text(
                      '',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
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
        onTap: (index) {},
      ),
    );
  }
}
