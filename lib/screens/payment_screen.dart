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
  final String upiId = "9409273414@paytm"; // Updated with a sample UPI ID format
  final String amount = "50.00";
  final String businessName = "Aotppmt Services";

  // Fixed async gaps by using 'if (!mounted) return;'
  Future<void> _initiatePayment() async {
    final String url = 
      'upi://pay?pa=$upiId&pn=$businessName&am=$amount&cu=INR';
    
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      
      if (!mounted) return; // Guard for async gap
      _handlePaymentSuccess();
    } else {
      if (!mounted) return; // Guard for async gap
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No UPI app found. Please scan the QR.")),
      );
    }
  }

  // Updated logic to ensure context is handled safely
  Future<void> _handlePaymentSuccess() async {
    final dbHelper = DbHelper();
    final db = await dbHelper.database;

    String today = DateFormat('dd/MM/yyyy').format(DateTime.now());
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
      whereArgs: ['9409273414'], 
    );

    if (!mounted) return; // Guard for async gap
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Successful! Database Updated.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment Gateway")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text("Pay Premium Fees", 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("Amount: ₹50.00", 
              style: TextStyle(fontSize: 18, color: Colors.green)),
            
            // 3D-style QR Card
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    // Fixed: using withValues instead of deprecated withOpacity
                    color: Colors.blue.withValues(alpha: 0.3), 
                    blurRadius: 10, 
                    offset: const Offset(5, 5)
                  )
                ],
              ),
              child: Image.asset('assets/jkqr.jpg', height: 250), 
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
