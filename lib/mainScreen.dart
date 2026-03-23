import 'package:aqsafrabrics/productDetailScreen/myOrders.dart';
import 'package:flutter/material.dart';
import 'homeScreen/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'myProfile/myProfile.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'mainScreen.dart';
class MainScreen extends StatefulWidget {
  final int initialIndex;
  final bool showLoginNotification;
  MainScreen({this.initialIndex = 0,this.showLoginNotification = false});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // ✅ typed list (important)
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.initialIndex;
    loadCart();
    initNotification();

    if (widget.showLoginNotification) {
      Future.delayed(const Duration(milliseconds: 500), () {
        showLoginSuccessNotification();
      });
    }
  }


  Future<void> initNotification() async {
    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(
      settings: initSettings,
    );
  }

  Future<void> showLoginSuccessNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'login_channel_v2',
      'Login Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      id: 1,
      title: 'Login Successful',
      body: 'Successfully Logged To Aqsa Fabrics',
      notificationDetails: details,
    );
  }

    void goToCart() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  // ✅ SAVE CART
  Future<void> saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> cartList =
    cartItems.map((item) => jsonEncode(item)).toList();

    await prefs.setStringList('cart', cartList);
  }

  // ✅ LOAD CART
  Future<void> loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartList = prefs.getStringList('cart');

    if (cartList != null) {
      List<Map<String, dynamic>> loadedCart =
      cartList.map((item) => jsonDecode(item) as Map<String, dynamic>).toList();

      if (!mounted) return; // ✅ safety

      setState(() {
        cartItems = loadedCart;
      });
    }
  }

  void increaseQty(int index, BuildContext context) {
    if (cartItems[index]["quantity"] >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Maximum order limit is 10"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      cartItems[index]["quantity"]++;
    });

    saveCart();
  }

  void decreaseQty(int index) {
    setState(() {
      cartItems[index]["quantity"]--;

      if (cartItems[index]["quantity"] <= 0) {
        cartItems.removeAt(index);
      }
    });

    saveCart();
  }

  // ✅ ADD TO CART (fixed cloning issue)
  void addToCart(Map<String, dynamic> product) {
    setState(() {
      int index = cartItems.indexWhere(
            (item) => item["name"] == product["name"],
      );

      if (index != -1) {
        if (cartItems[index]["quantity"] < 10) {
          cartItems[index]["quantity"]++;
        }
      } else {
        // ✅ clone product instead of modifying original
        Map<String, dynamic> newProduct = Map.from(product);
        newProduct["quantity"] = 1;

        cartItems.add(newProduct);
      }
    });

    saveCart();
  }

  void removeFromCart(int index) {
    setState(() {
      cartItems.removeAt(index);
    });

    saveCart();
  }

  @override
  Widget build(BuildContext context) {
    List pages = [
      HomeScreen(
        addToCart: addToCart,
        goToCart: goToCart,
      ),
      CartScreen(
        cartItems: cartItems,
        increaseQty: increaseQty,
        decreaseQty: decreaseQty,
      ),
      MyOrders(),
      MyProfileScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart),

                if (cartItems.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints:
                      BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Center(
                        child: Text(
                          '${cartItems.length}',
                          style:
                          TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            label: "Cart",
          ),

          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "My Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final List cartItems;
  final Function increaseQty;
  final Function decreaseQty;

  CartScreen({
    required this.cartItems,
    required this.increaseQty,
    required this.decreaseQty,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xFF6750A4),
        title: Text("Cart Products",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: cartItems.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🛒 Icon
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF6750A4).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 60,
                color: Color(0xFF6750A4),
              ),
            ),

            SizedBox(height: 20),

            // 📝 Title
            Text(
              "Your Cart is Empty",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            // 📄 Subtitle
            Text(
              "Looks like you haven’t added anything yet",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 25),

            // 🛍️ Button
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
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          cartItems[index]["image"],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),

                      title: Text(cartItems[index]["name"]),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("₹${cartItems[index]["price"]}"),

                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  decreaseQty(index);
                                },
                              ),

                              Text(
                                cartItems[index]["quantity"].toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  increaseQty(index, context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
