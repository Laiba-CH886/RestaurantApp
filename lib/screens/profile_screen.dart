// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign out method
  void _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            user != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${user.displayName ?? 'Not Available'}", style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text("Email: ${user.email ?? 'Not Available'}", style: TextStyle(fontSize: 18)),
              ],
            )
                : Center(child: Text("No user logged in.")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signOut,
              child: Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
