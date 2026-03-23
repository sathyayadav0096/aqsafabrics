// import 'dart:io';
//
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:chitchat/Home/viewProfile.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../FriendsRequest/request.dart';
// import '../VideoCall/videoCall.dart';
// import 'DrawerScreen/drawer.dart';
// import 'favouriteScreen.dart';
// import 'notification.dart';
//
// class HomePage extends StatefulWidget {
//   final Function(bool) onScroll;
//
//   const HomePage({
//     super.key,
//     required this.onScroll,
//     required int initialIndex,
//   });
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final String imageUrl =
//       "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e";
//
//   final ScrollController _scrollController = ScrollController();
//
//   ScrollDirection? lastDirection;
//   File? _image;
//
//   @override
//   void initState() {
//     FavoriteController.loadFavorites();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void handleAddImage(BuildContext context, Function(File) onImageSelected) {
//     final ImagePicker picker = ImagePicker();
//
//     showModalBottomSheet(
//       context: context,
//       builder: (_) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: Icon(Icons.camera_alt),
//                 title: Text('Camera'),
//                 onTap: () async {
//                   Navigator.pop(context);
//
//                   final XFile? pickedFile =
//                   await picker.pickImage(source: ImageSource.camera);
//
//                   if (pickedFile != null) {
//                     onImageSelected(File(pickedFile.path));
//                   }
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.photo_library),
//                 title: Text('Gallery'),
//                 onTap: () async {
//                   Navigator.pop(context);
//
//                   final XFile? pickedFile =
//                   await picker.pickImage(source: ImageSource.gallery);
//
//                   if (pickedFile != null) {
//                     onImageSelected(File(pickedFile.path));
//                   }
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void _handleScroll(UserScrollNotification notification) {
//     if (notification.direction == ScrollDirection.idle) return;
//
//     if (notification.direction == ScrollDirection.forward) {
//       // ⬇️ scrolling DOWN → HIDE
//       widget.onScroll(true);
//     } else if (notification.direction == ScrollDirection.reverse) {
//       // ⬆️ scrolling UP → SHOW
//       widget.onScroll(false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       drawer: const MyDrawer(),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         automaticallyImplyLeading: false,
//         surfaceTintColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "Chit Chat",
//           style: TextStyle(
//             color: Colors.purple,
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//         actions: [
//           ValueListenableBuilder<int>(
//             valueListenable: FriendRequestController.requestCount,
//             builder: (context, count, child) {
//               return InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const NotificationScreen(),
//                     ),
//                   );
//                 },
//                 child: Stack(
//                   children: [
//                     Icon(
//                       Icons.notifications_none,
//                       color: Colors.black,
//                       size: 25,
//                     ),
//                     // IconButton(
//                     //   icon: const Icon(
//                     //     Icons.notifications_none,
//                     //     color: Colors.black,
//                     //   ),
//                     //   onPressed: () {
//                     //     Navigator.push(
//                     //       context,
//                     //       MaterialPageRoute(
//                     //         builder: (context) => const NotificationScreen(),
//                     //       ),
//                     //     );
//                     //   },
//                     // ),
//                     if (count > 0)
//                       Positioned(
//                         left: 12,
//                         bottom: 8,
//                         child: Container(
//                           padding: const EdgeInsets.all(4),
//                           decoration: const BoxDecoration(
//                             color: Colors.red,
//                             shape: BoxShape.circle,
//                           ),
//                           constraints: const BoxConstraints(
//                             minWidth: 14,
//                             minHeight: 14,
//                           ),
//                           child: Text(
//                             count > 9 ? "9+" : count.toString(),
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 9,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           const SizedBox(width: 16),
//           Builder(
//             builder: (context) {
//               return IconButton(
//                 icon: const Icon(Icons.menu, color: Colors.black),
//                 onPressed: () {
//                   Scaffold.of(context).openDrawer();
//                 },
//               );
//             },
//           ),
//           const SizedBox(width: 12),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 12),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: TextField(
//                           onChanged: (value) {},
//                           decoration: InputDecoration(
//                             hintText: "Search Partner",
//                             icon: Icon(Icons.search),
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     SizedBox(width: 10),
//
//                     GestureDetector(
//                       onTap: () {
//                         handleAddImage(context, (file) {
//                           setState(() {
//                             _image = file;
//                           });
//                         });
//                       },
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min, // ✅ FIX alignment
//                         children: [
//                           Container(
//                             height: 60, // slightly smaller for better fit
//                             width: 60,
//                             decoration: BoxDecoration(
//                               color: Colors.pink,
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             child: Icon(Icons.add, color: Colors.white),
//                           ),
//                           SizedBox(height: 5),
//                           Text("Add"),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 15),
//                 Text(
//                   "Stories",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           CarouselSlider(
//             options: CarouselOptions(
//               height: 95,
//               viewportFraction: 0.20,
//               autoPlay: true,
//               autoPlayInterval: const Duration(milliseconds: 2000),
//               autoPlayAnimationDuration: const Duration(seconds: 2),
//               autoPlayCurve: Curves.linear,
//               enableInfiniteScroll: true,
//               scrollPhysics: const BouncingScrollPhysics(),
//             ),
//             items: List.generate(
//               20,
//                   (index) => StoryItem(
//                 name: "User ${index + 1}",
//                 isOnline: index % 2 == 0,
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Expanded(
//             child: NotificationListener<UserScrollNotification>(
//               onNotification: (notification) {
//                 _handleScroll(notification);
//                 return true;
//               },
//               child: GridView.builder(
//                 controller: _scrollController,
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 physics: const BouncingScrollPhysics(),
//                 itemCount: 40,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 0.72,
//                 ),
//                 itemBuilder: (context, index) {
//                   Map<String, dynamic> profile = {
//                     "id": index,
//                     "name": "Victoria",
//                     "age": 25,
//                     "image": "assets/Images/img2.jpg",
//                     "distance": "3.4 km",
//                   };
//
//                   return InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ProfileCardPage(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         image: DecorationImage(
//                           image: AssetImage(profile["image"]),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       child: Stack(
//                         children: [
//                           Positioned(
//                             bottom: 100,
//                             right: 5,
//                             child:
//                             ValueListenableBuilder<
//                                 List<Map<String, dynamic>>
//                             >(
//                               valueListenable: FavoriteController.favorites,
//                               builder: (context, favorites, _) {
//                                 bool isLiked = favorites.any(
//                                       (p) => p["id"] == profile["id"],
//                                 );
//                                 return InkWell(
//                                   onTap: () =>
//                                       FavoriteController.toggleFavorite(
//                                         profile,
//                                       ),
//                                   child: Container(
//                                     padding: EdgeInsets.all(4),
//                                     decoration: BoxDecoration(
//                                       color: Colors.black54,
//                                       shape: BoxShape.circle,
//                                       border: Border.all(
//                                         color: Colors.green,
//                                         width: 2,
//                                       ),
//                                     ),
//                                     child: Icon(
//                                       Icons.favorite_outlined,
//                                       color: isLiked
//                                           ? Colors.red
//                                           : Colors.white,
//                                       size: 23,
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           Positioned(
//                             bottom: 50,
//                             right: 5,
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => VideoCallScreen(),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.all(4),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black54,
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: Colors.green,
//                                     width: 2,
//                                   ),
//                                 ),
//                                 child: Icon(
//                                   Icons.video_call,
//                                   color: Colors.white,
//                                   size: 23,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             bottom: 4,
//                             left: 4,
//                             right: 4,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 8,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.black54,
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     "${profile["name"]}",
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   Text(
//                                     "Age: ${profile["age"]}",
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class StoryItem extends StatelessWidget {
//   final String name;
//   final bool isOnline;
//
//   const StoryItem({super.key, required this.name, required this.isOnline});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 6),
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(3),
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: LinearGradient(
//                     colors: [Colors.orange, Colors.pink],
//                   ),
//                 ),
//                 child: const CircleAvatar(
//                   radius: 30,
//                   backgroundImage: AssetImage("assets/Images/img1.jpeg"),
//                 ),
//               ),
//               if (isOnline)
//                 Positioned(
//                   right: 2,
//                   bottom: 2,
//                   child: Container(
//                     width: 14,
//                     height: 14,
//                     decoration: BoxDecoration(
//                       color: Colors.green,
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 2),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 5),
//           Text(name, style: const TextStyle(fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }
