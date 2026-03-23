import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../commonWidgets/commonDialog/commonDIalog.dart';
import '../logonScreen.dart';
import '../main.dart';
import '../mainScreen.dart';
import '../productDetailScreen/myOrders.dart';
import '../productDetailScreen/productDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeScreen extends StatefulWidget {
  final Function addToCart;
  final bool showLoginNotification;
  final int initialIndex;

  final Function goToCart;

  HomeScreen({
    required this.addToCart,
    required this.goToCart,
    this.showLoginNotification = false,
    this.initialIndex = 0,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String userName = "User";
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    initNotification();

    if (widget.showLoginNotification) {
      Future.delayed(const Duration(milliseconds: 500), () {
        showLoginSuccessNotification();
      });
    }

    loadUserName(); // keep this outside if
  }

  Future<void> initNotification() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSettings = InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(settings: initSettings);
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

  void loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? "User";
    });
  }

  final List categories = [
    "Sarees",
    "Tops",
    "Frock",
    "Western",
    "Gagras",
    "Chudidar",
    "Leggings",
    "Plazo",
    "Jeans",
    "T-Shirts",
    "Shirts",
    "Night Suits",
    "Inner Wears",
    "Feeding Tops",
    "Half Sarees",
  ];

  final List banners = [
    {
      "image": "https://share.google/xC9atzcyND6mD7bbQ",
      "offer": "22% OFF",
      "time": "Ends in 5 days",
    },
    {
      "image": "https://share.google/Jmy8qarkn8K3cRC8V",
      "offer": "22% OFF",
      "time": "Ends in 5 days",
    },
    {
      "image": "https://share.google/vesZn7ffLaZqCjEVG",
      "offer": "22% OFF",
      "time": "Ends in 5 days",
    },
    {
      "image": "https://share.google/nu4CUAhUrppZrknNo",
      "offer": "22% OFF",
      "time": "Ends in 5 days",
    },
    {
      "image": "https://share.google/MmnafCogR35y3b8J7",
      "offer": "22% OFF",
      "time": "Ends in 5 days",
    },
  ];

  // ✅ ADD THIS LIST BELOW categories
  final List images = [
    "assets/images/saree.webp",
    "assets/images/tops.jpg",
    "assets/images/frock.webp",
    "assets/images/westernDress.webp",
    "assets/images/ghagra.jpg",
    "assets/images/chudidar.webp",
    "assets/images/leggins.webp",
    "assets/images/plazo.webp",
    "assets/images/jeans.jpeg",
    "assets/images/tshirts.jpg",
    "assets/images/shirts.webp",
    "assets/images/nightsuits.jpg",
    "assets/images/innerwear.webp",
    "assets/images/feedingtops.jpg",
    "assets/images/halfsaree.webp",
  ];

  // ✅ UPDATE products LIST
  late final List products = List.generate(categories.length, (index) {
    return {
      "name": categories[index],
      "image": images[index], // 🔥 local image here
      "price": (500 + index * 50),
      "rating": (4.0 + (index % 5) * 0.1),
    };
  });

  void showTopSnackBar(BuildContext context, String message) {
    OverlayState overlayState = Overlay.of(context);

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return _TopSnackBarWidget(
          message: message,
          onDismiss: () {
            overlayEntry.remove();
          },
        );
      },
    );

    overlayState.insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF6750A4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Aqsa Fabrics",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),

            drawerItem(Icons.person, "Profile", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(initialIndex: 3),
                ),
              );
            }),
            drawerItem(Icons.shopping_bag, "My Orders", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(initialIndex: 2),
                ),
              );
            }),
            drawerItem(Icons.favorite, "Wishlist", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(initialIndex: 1),
                ),
              );
            }),
            drawerItem(Icons.local_offer, "Offers", () {
              ComingSoonDialog.show(context, feature: "Offers");
            }),
            drawerItem(Icons.location_on, "Address", () {
              ComingSoonDialog.show(context, feature: "Address");
            }),
            drawerItem(Icons.payment, "Payments", () {
              ComingSoonDialog.show(context, feature: "Payments");
            }),
            drawerItem(Icons.notifications, "Notifications", () {
              ComingSoonDialog.show(context, feature: "Notifications");
            }),
            drawerItem(Icons.help, "Help", () {
              ComingSoonDialog.show(context, feature: "Help");
            }),
            drawerItem(Icons.settings, "Settings", () {
              ComingSoonDialog.show(context, feature: "Settings");
            }),

            // 🌙 DARK MODE SWITCH (SAFE VERSION)
            SwitchListTile(
              title: Text("Dark Mode"),
              secondary: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                MyApp.of(
                  context,
                )?.toggleTheme(Theme.of(context).brightness != Brightness.dark);
              },
            ),
            drawerItem(Icons.logout, "Logout", () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logged out successfully')),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            }),
          ],
        ),
      ),

      appBar: AppBar(
        backgroundColor: Color(0xFF6750A4),
        automaticallyImplyLeading: false,
        title: Text("Hey $userName", style: TextStyle(color: Colors.white)),
        actions: [
          // 🌙 DARK / LIGHT MODE TOGGLE
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
              color: Colors.white,
            ),
            onPressed: () {
              MyApp.of(
                context,
              )?.toggleTheme(Theme.of(context).brightness != Brightness.dark);
            },
          ),

          // ☰ DRAWER ICON (RIGHT SIDE → OPEN LEFT DRAWER)
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // ✅ WORKS
                },
                color: Colors.white,
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text(
              'Discounts Offers',
              style: TextStyle(color: Color(0xFF6750A4), fontSize: 15),
            ),
            SizedBox(height: 5),
            ImageCarousel(),
        
            SizedBox(height: 15),
            Text(
              'All Products',
              style: TextStyle(color: Color(0xFF6750A4), fontSize: 15),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(10),
              itemCount: products.length * 4, // repeat 4 times
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final product =
                    products[index % products.length]; // loop through products
            
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          product: product,
                          goToCart: widget.goToCart,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 8,
                    shadowColor: Color(0xFF6750A4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            child: Image.asset(
                              product["image"],
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product["name"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(product["rating"].toString()),
                                ],
                              ),
                              Text(
                                "₹${product["price"]}",
                                style: TextStyle(
                                  color: Color(0xFF6750A4),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Delivery in 2-4 days",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 5),
                              SizedBox(
                                width: double.infinity,
                                child: GestureDetector(
                                  onTap: () {
                                    widget.addToCart(product);
                                    showTopSnackBar(
                                      context,
                                      "${product["name"]} added to cart",
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF6750A4),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Add to Cart",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Drawer Item FIXED
  Widget drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap, // ✅ this handles click
    );
  }
}

class _TopSnackBarWidget extends StatefulWidget {
  final String message;
  final VoidCallback onDismiss;

  const _TopSnackBarWidget({required this.message, required this.onDismiss});

  @override
  State<_TopSnackBarWidget> createState() => _TopSnackBarWidgetState();
}

class _TopSnackBarWidgetState extends State<_TopSnackBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    animation = Tween<Offset>(
      begin: Offset(0, -1), // from top
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller.forward();

    // stay 4 seconds then close
    Future.delayed(Duration(seconds: 4), () {
      controller.reverse().then((_) {
        widget.onDismiss();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 10,
      right: 10,
      child: SlideTransition(
        position: animation,
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF6750A4)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.message,
                    style: TextStyle(color: Color(0xFF6750A4)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageCarousel extends StatefulWidget {
  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final List<String> imageList = List.generate(
    9,
    (index) => 'assets/images/${index + 1}.jpeg',
  );

  late final ScrollController _scrollController;
  bool _isUserScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() async {
    while (true) {
      if (_scrollController.hasClients && !_isUserScrolling) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.offset;
        final target = currentScroll >= maxScroll ? 0.0 : maxScroll;

        await _scrollController.animateTo(
          target,
          duration: Duration(seconds: 60),
          curve: Curves.linear,
        );
      }
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // Detect user scroll start/end
          if (notification is ScrollStartNotification) {
            _isUserScrolling = true;
          } else if (notification is ScrollEndNotification) {
            _isUserScrolling = false;
          }
          return false;
        },
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: imageList.length * 2, // duplicate for seamless loop
          itemBuilder: (context, index) {
            final imagePath = imageList[index % imageList.length];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF6750A4),
                      spreadRadius: 4,
                      blurRadius: 1,
                      offset: Offset(3, 3),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
