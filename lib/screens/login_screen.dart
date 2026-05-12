import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
 
  void _handleLogin() {
    String mobile = _mobileController.text.trim();
    String pass = _passwordController.text.trim();

    // 1. Admin Login Logic
    if (mobile == '9879015142' && pass == 'jkdmjd') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Admin Login Successful")),
      );
      // Navigate to Admin Dashboard (to be created)
      return;
    }

    // 2. General User OTP Logic
    if (mobile.length == 10) {
      // Here we will trigger the SMS Manager/OTP logic in the next step
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sending OTP to $mobile...")),
      );
      Navigator.pushNamed(context, '/payment'); // Proceeding to Payment for now
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 10-digit number")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Aotppmt Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 3D-style Input Decoration
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Mobile Number",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.phone_android),
              ),
            ),
            const SizedBox(height: 20),
            if (mobile == '9879015142') // Show password field only for admin
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Admin Password",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("LOGIN / VERIFY OTP"),
            ),
          ],
        ),
      ),
    );
  }
  
  // Quick getter for cleaner logic
  String get mobile => _mobileController.text;
}
