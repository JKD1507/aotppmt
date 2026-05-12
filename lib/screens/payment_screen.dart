import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final String upiId = "yourname@upi"; // Replace with your real UPI ID
  final String amount = "50.00";
  final String businessName = "Aotppmt Services";

  // This function opens the UPI apps on the phone
  Future<void> _initiatePayment() async {
    final String url = 
      'upi://pay?pa=$upiId&pn=$businessName&am=$amount&cu=INR';
    
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      // In a real scenario, you'd wait for a callback. 
      // For this test project, we simulate success:
      _handlePaymentSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No UPI app found. Please scan the QR.")),
      );
    }
  }

  // Your logic: Update SQLite to 'Y' and set Expiry
  Future<void> _handlePaymentSuccess() async {
    final dbHelper = DbHelper();
    final db = await dbHelper.database;

    String today = DateFormat('dd/MM/yyyy').format(DateTime.now());
    // Calculate Expiry: Today + 30 days
    String expiry = DateFormat('dd/MM/yyyy').format(
      DateTime.now().add(const Duration(days: 30))
    );

    await db.update(
      'User_Mst',
      {
        'Pmt_Flag': 'Y',
        'U_Reg_Date': today,
        'U_Exp_Date': expiry,
      },
      where: 'U_Mobile = ?',
      whereArgs: ['9409273414'], // Updating the test user
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Successful! Database Updated.")),
    );

    // Redirect to home or refresh state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment Gateway")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text("Pay Premium Fees", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("Amount: ₹50.00", style: TextStyle(fontSize: 18, color: Colors.green)),
            
            // 3D-style QR Card
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(5, 5))
                ],
              ),
              child: Image.asset('assets/jkqr.jpg', height: 250), // Your asset
            ),

            const Text("Scan QR or Click Below"),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton.icon(
                onPressed: _initiatePayment,
                icon: const Icon(Icons.account_balance_wallet),
                label: const Text("PAY VIA UPI APP"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
