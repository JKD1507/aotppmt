import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    // 1. Initialize DB and create the default 'Test User'
    final dbHelper = DbHelper();
    final db = await dbHelper.database;

    // 2. Fetch the user record
    final List<Map<String, dynamic>> user = await db.query('User_Mst', limit: 1);
    
    // Artificial delay to show your Splash UI
    await Future.delayed(const Duration(seconds: 3));

    if (user.isNotEmpty) {
      // Check if payment is already done ('Y')
      if (user[0]['Pmt_Flag'] == 'Y') {
        Navigator.pushReplacementNamed(context, '/payment');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "Aotppmt Project",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
