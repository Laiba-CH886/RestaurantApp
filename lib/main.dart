import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AdminWebPanel extends StatefulWidget {
  @override
  _AdminWebPanelState createState() => _AdminWebPanelState();
}

class _AdminWebPanelState extends State<AdminWebPanel> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("file:///android_asset/admin/index.html"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('images/logo.png', height: 30), // Logo in AppBar
            SizedBox(width: 10),
            Text("Admin Web Panel"),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration( // Add background image to DrawerHeader
                image: DecorationImage(
                  image: AssetImage('images/header.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column( // Center the logo and add text
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/cooker-img.png', height: 50), // Smaller cooker image
                  SizedBox(height: 10),
                  Text(
                    'Restaurant App',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Handle drawer item tap
              },
            ),
            // ... other drawer list tiles
          ],
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}