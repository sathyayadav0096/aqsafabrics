import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mainScreen.dart';
import 'myOrders.dart';

class PaymentScreen extends StatefulWidget {
  final Map product;
  final String selectedSize;

  const PaymentScreen({
    super.key,
    required this.product,
    required this.selectedSize,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selected = 3;

  void showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 10),
            Text("Order Successful!"),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // close dialog

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>  MainScreen()),
      );
    });
  }
  Future<void> saveOrder() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> orders = prefs.getStringList("orders") ?? [];

    Map<String, dynamic> order = {
      "title": widget.product["name"] ?? "No Title", // ✅ FIX
      "price": widget.product["price"] ?? 0,
      "size": widget.selectedSize,
      "image": widget.product["image"] ?? "",
      "status": "Order Placed",
      "date": DateTime.now().toString(),
    };

    orders.add(jsonEncode(order));

    await prefs.setStringList("orders", orders);

    print("Saved Orders: $orders");
  }
  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("PAYMENT METHOD",
            style: TextStyle(color: Colors.black, fontSize: 14)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      bottomNavigationBar: Container(

          color: Colors.white,
        
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Text("₹${product["price"]}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),

              InkWell(
                onTap: () async{
                  await saveOrder();
                  showSuccessPopup();
                },
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6750A4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Pay Now",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),

          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.green.shade50,
              padding: const EdgeInsets.all(10),
              child: const Text("₹34 OFF on this order",
                  style: TextStyle(color: Colors.green)),
            ),

            const SizedBox(height: 10),

            _option(1, "Cash on Delivery", "₹${product["price"] + 34}"),
            _option(2, "Pay Later", "₹${product["price"] + 21}"),
            _option(3, "Pay Online", "₹${product["price"]}"),
          ],
        ),
      ),
    );
  }

  Widget _option(int val, String title, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
            color: selected == val
                ? const Color(0xFF9C27B0)
                : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Radio(
            value: val,
            groupValue: selected,
            activeColor: const Color(0xFF9C27B0),
            onChanged: (v) => setState(() => selected = v!),
          ),
          Expanded(child: Text(title)),
          Text(price),
        ],
      ),
    );
  }
}