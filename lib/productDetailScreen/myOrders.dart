import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mainScreen.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List orders = [];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> data = prefs.getStringList("orders") ?? [];

    setState(() {
      orders = data.map((e) => jsonDecode(e)).toList();
    });

    print("Loaded Orders: $orders"); // debug
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xFF6750A4),
        title: const Text("My Orders", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Big Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration:  BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 70,
                      color: Color(0xFF6750A4),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Title
                  const Text(
                    "No Orders Yet",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  // Subtitle with small icon
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, size: 18, color: Colors.grey),
                      SizedBox(width: 5),
                      Text(
                        "Start shopping to see orders here",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Button with icon
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6750A4),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(initialIndex: 0),
                        ),
                      ); // 🔥 go back to shopping
                    },
                    child: Text(
                      "Shop Now",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading:
                        order["image"] != null &&
                            order["image"].toString().startsWith("http")
                        ? Image.network(order["image"], width: 50)
                        : Image.asset(
                            order["image"] ?? "assets/images/tops.jpg",
                            width: 50,
                          ),

                    title: Text(order["title"] ?? "No Title"),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Size: ${order["size"] ?? "-"}"),
                        Text("₹${order["price"] ?? 0}"),
                        Text(
                          "Status: ${order["status"] ?? ""}",
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
