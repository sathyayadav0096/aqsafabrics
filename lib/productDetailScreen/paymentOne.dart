import 'package:aqsafrabrics/productDetailScreen/paymentSecond.dart';
import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  final Map product;
  final String selectedSize;

  const ReviewScreen({
    super.key,
    required this.product,
    required this.selectedSize,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "REVIEW YOUR ORDER",
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // OFFER BAR
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: Colors.green.shade50,
              child: const Text(
                "₹34 OFF on this order",
                style: TextStyle(color: Colors.green),
              ),
            ),

            const SizedBox(height: 8),

            // PRODUCT CARD
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Image.asset(
                    product["image"],
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product["name"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),

                        Row(
                          children: [
                            Text(
                              "₹${product["price"]}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "₹${product["price"] + 34}",
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              "12% Off",
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "Size: $selectedSize • Qty: 1",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // DELIVERY
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.local_shipping, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delivery by Monday, 30th Mar",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Your Address here...",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text("Change"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // PRICE DETAILS
            Container(
              color: Colors.white,
              child: ListTile(
                title: const Text("Price Details"),
                trailing: Text("₹${product["price"]}"),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₹${product["price"]}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    "₹34 OFF",
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ],
              ),

              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentScreen(
                        product: product,
                        selectedSize: selectedSize,
                      ),
                    ),
                  );
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
                    "Payment",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),    );
  }
}