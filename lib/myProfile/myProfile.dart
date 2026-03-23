import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logonScreen.dart';
import 'clipperPath.dart';
import 'contactUs.dart';
import 'editProfile.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  // final LoginController loginController = Get.find();

  // final LocalDb = GetStorage();
  String userName = "User";

  void loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? "User";
    });
  }

  @override
  void initState() {
    loadUserName();
    super.initState();
  }

  void _openPrivacyPolicy() async {
    const url = 'https://dev.credbuddha.com/app/privacy_policy';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _termsAndConditions() async {
    const url = 'https://dev.credbuddha.com/app/terms_and_conditions';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _shareLink(BuildContext context, String app) {
    String link;
    switch (app) {
      default:
        link = 'https://shorturl.at/jmHsr';
        break;
    }
    return link;
  }

  Future<void> shareLink(BuildContext context) async {
    String shareLink = _shareLink(context, '');
    Share.share(shareLink, subject: 'Check out this link!');
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double clipperHeight = 148;
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF6750A4), // left
                Color(0xFF6750A4), // right
              ],
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'My Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: GreenClipper(),
            child: Container(
              height: clipperHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF6750A4), // left
                    Color(0xFF6750A4), // right
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 45),
                  Transform.translate(
                    offset: const Offset(0, 20),
                    child: Container(
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        border: Border.all(color: Color(0xFF6750A4)),
                      ),

                      child: Icon(Icons.person, size: 40),
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hey $userName",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                        softWrap: true, // added to ensure wrapping
                        overflow: TextOverflow.visible, // no clip/fade
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.03),

                  _buildProfileOption(
                    icon: Container(height: 25, child: Icon(Icons.edit)),
                    title: 'Edit profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(),
                        ),
                      );
                    },
                    // Get.find<BottomNavController>()
                    //     .openWithIndex(3, EditProfileScreen()),
                    // Get.toNamed(Routes.editProfileScreen),
                    titlePadding: EdgeInsets.only(left: 5.2),
                  ),
                  Divider(thickness: 1.0),
                  _buildProfileOption(
                    icon: Container(
                      // height: 25,
                      child: Icon(Icons.person),
                    ),
                    title: 'Contact Us',

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactUsScreen(),
                        ),
                      );
                    },

                    titlePadding: EdgeInsets.only(left: 5.2),
                  ),
                  Divider(thickness: 1.0),
                  _buildProfileOption(
                    icon: Container(height: 25, child: Icon(Icons.policy)),
                    title: 'Privacy Policy',
                    onTap: _openPrivacyPolicy,
                    titlePadding: EdgeInsets.only(left: 5),
                  ),
                  Divider(thickness: 1.0),
                  _buildProfileOption(
                    icon: Container(
                      // height: 25,
                      child: Icon(Icons.contrast),
                    ),
                    title: 'Terms & Conditions',
                    onTap: _termsAndConditions,
                    titlePadding: EdgeInsets.only(left: 0),
                  ),

                  Divider(thickness: 1.0),
                  _buildProfileOption(
                    icon: Container(
                      height: 25,
                      child: Icon(Icons.share_outlined),
                    ),
                    titlePadding: EdgeInsets.only(left: 4),
                    title: 'Refer',
                    onTap: () async {
                      await shareLink(context);
                    },
                    showArrow: true,
                  ), //
                  Divider(thickness: 1.0),
                  _buildProfileOption(
                    icon: Container(height: 25, child: Icon(Icons.logout)),
                    titlePadding: EdgeInsets.only(left: 4),
                    title: 'Logout',
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logged out successfully')),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                    showArrow: false,
                  ),

                  Divider(thickness: 1.0),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Text(
                        'Follow Us',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialIcon(
                            context,
                            'assets/images/face.png',
                            url:
                                'https://www.facebook.com/profile.php?id=61564432911812#',
                          ),
                          SizedBox(width: 15),
                          _buildSocialIcon(
                            context,
                            'assets/images/insta.png',
                            url: 'https://www.instagram.com/credbuddha',
                          ),
                          SizedBox(width: 15),
                          _buildSocialIcon(
                            context,
                            'assets/images/what.png',
                            url: '',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required Widget icon,
    required String title,
    required VoidCallback onTap,
    bool showArrow = true,
    EdgeInsetsGeometry titlePadding = const EdgeInsets.only(left: 0),
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  icon,
                  SizedBox(width: 17),
                  Padding(
                    padding: titlePadding,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showArrow) Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(
    BuildContext context,
    String assetPath, {
    String? url, // nullable URL
  }) {
    return InkWell(
      onTap: () async {
        if (url == null || url.isEmpty) {
          // No redirect → show message (or do nothing)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Coming soon...',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.pink,
            ),
          );
          return;
        }

        // Launch URL if provided
        if (await canLaunchUrl(Uri.parse(url))) {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not open link')));
        }
      },
      child: SizedBox(height: 30, child: Image.asset(assetPath)),
    );
  }
}
