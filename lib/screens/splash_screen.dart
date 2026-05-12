import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class SplashScreen extends StatefulWidget {
  // Fixed: Added named 'key' parameter to the constructor
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Fixed: Removed library_private_types_in_public_api warning
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final dbHelper = DbHelper();
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> user = await db.query('User_Mst', limit: 1);
    
    await Future.delayed(const Duration(seconds: 3));

    // Fixed: Added 'mounted' checks for all BuildContext usage across async gaps
    if (!mounted) return;

    if (user.isNotEmpty) {
      if (user.first['Pmt_Flag'] == 'Y') {
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
