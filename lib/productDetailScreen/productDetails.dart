import 'dart:io';
import 'dart:io';
import 'dart:typed_data'; // ✅ For Uint8List
import 'package:aqsafrabrics/productDetailScreen/paymentOne.dart';
import 'package:path_provider/path_provider.dart'; // ✅ For temporary files
import 'package:share_plus/share_plus.dart'; // ✅ Sharing
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map product;

  final Function goToCart;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.goToCart,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int currentIndex = 0;

  late List images;

  String selectedSize = "M";
  final List sizes = ["M", "L", "XL", "XXL"];

  final List similarProducts = [
    "assets/images/frock.webp",
    "assets/images/westernDress.webp",
    "assets/images/frock.webp",
  ];

  @override
  void initState() {
    super.initState();

    // ✅ SAME IMAGE FROM HOME
    images = [
      widget.product["image"],
      widget.product["image"],
      widget.product["image"],
    ];
  }

  String _shareLink(BuildContext context, String app) {
    String link;
    switch (app) {
      default:
        link = 'https://tinywebs.site/qHLWSk';
        break;
    }
    return link;
  }

  Future<void> shareLink(BuildContext context) async {
    final String link = _shareLink(context, '');

    // ✅ Custom share content
    final String shareContent =
    '''
Welcome To Aqsa Fabrics!
Best Selling Offers & Amazing Discounts All Year Round.

🔥 Exclusive Deals on Fashion & Fabrics
🎁 Free Delivery on Selected Items
💳 Pay via UPI or COD Easily
💎 Quality Products Guaranteed

For More Check Out Our Website: $link
''';

    print("Content to share:\n$shareContent"); // Debug

    // Share the content
    await Share.share(shareContent, subject: 'Welcome to Aqsa Fabrics');
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      // 🔝 APP BAR
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        elevation: 0,
        title: Text('Product Details', style: TextStyle()),
        // centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 10),
          Icon(Icons.favorite_border, color: Colors.black),
          SizedBox(width: 10),
          InkWell(
            onTap: () {
              widget.goToCart();
              Navigator.pop(context);
            },
            child: Icon(Icons.shopping_cart_outlined, color: Colors.black),
          ),
          SizedBox(width: 10),
        ],
      ),

      // 🔻 BOTTOM BUTTONS
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        height: 70,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  widget.goToCart();
                  Navigator.pop(context);
                },
                icon: Icon(Icons.shopping_cart_outlined),
                label: Text("Add to Cart"),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewScreen(
                        product: widget.product,
                        selectedSize: selectedSize,
                      ),
                    ),
                  );},
                child: Text("Buy Now", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),

      // 📜 BODY
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 IMAGE SLIDER
            SizedBox(
              height: 350,
              child: PageView.builder(
                itemCount: images.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.asset(images[index], fit: BoxFit.cover);
                },
              ),
            ),

            // 🔘 DOTS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                return Container(
                  margin: EdgeInsets.all(4),
                  width: currentIndex == index ? 10 : 6,
                  height: currentIndex == index ? 10 : 6,
                  decoration: BoxDecoration(
                    color: currentIndex == index ? Colors.pink : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),

            SizedBox(height: 10),

            // 🔥 SIMILAR PRODUCTS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "3 Similar Products",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 10),

            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: similarProducts.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.pink),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(similarProducts[index]),
                  );
                },
              ),
            ),

            SizedBox(height: 15),

            // 🏷 NAME + ACTIONS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      product["name"], // ✅ SAME NAME
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Column(
                    children: [
                      Icon(Icons.favorite, color: Colors.red),
                      Text("Wishlisted", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      await shareLink(context);
                    },
                    child: Column(
                      children: [
                        Icon(Icons.share),
                        Text("Share", style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // 💰 PRICE
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    "₹${product["price"]}", // ✅ SAME PRICE
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "${product["price"] + 23}",
                    style: TextStyle(decoration: TextDecoration.lineThrough),
                  ),
                  SizedBox(width: 8),
                  Text("6% off onwards"),
                ],
              ),
            ),

            SizedBox(height: 10),

            // 🎁 OFFER BOX
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_offer, color: Colors.orange),
                    SizedBox(width: 10),
                    Text("UPI Offer applied for you!"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("₹${product["price"] + 23} with COD"),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Free Delivery",
                style: TextStyle(color: Colors.green),
              ),
            ),

            SizedBox(height: 10),

            // ⭐ RATING
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Text("4.4", style: TextStyle(color: Colors.white)),
                        Icon(Icons.star, color: Colors.white, size: 14),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Text("(18,289 Ratings)"),
                ],
              ),
            ),

            // ✅ SIZE SELECTION (ADDED)
            SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Select Size",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: sizes.map((size) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSize = size;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedSize == size
                              ? Colors.pink
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(size),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
