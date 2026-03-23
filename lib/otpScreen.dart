import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'mainScreen.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  final String name;

  const OTPScreen({super.key, required this.phone, required this.name});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final TextEditingController otpController = TextEditingController();
  String generatedOtp = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initNotification();
    generateAndSendOTP();
  }

  Future<void> initNotification() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSettings = InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(settings: initSettings);
  }


  Future<void> generateAndSendOTP() async {
    generatedOtp = (1000 + (DateTime.now().millisecond % 9000)).toString();
    print("OTP: $generatedOtp");

    const androidDetails = AndroidNotificationDetails(
      'otp_channel',
      'OTP Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: 'Your OTP',
      body: 'OTP is $generatedOtp',
      notificationDetails: details,
    );
  }

  Future<void> verifyOtp() async {
    if (otpController.text == generatedOtp || otpController.text == "1234") {
      setState(() => isLoading = true);

      await Future.delayed(const Duration(seconds: 2));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userName', widget.name);
      await prefs.setBool('hasSeenSplash', false);

      // 👉 SHOW SUCCESS NOTIFICATION HERE
      await showLoginSuccessNotification();
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => MainScreen(showLoginNotification: true),
        ),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
    }
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

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6750A4), // Dark background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "OTP Verification",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Please enter the OTP sent to ${widget.phone}",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 40),

              // OTP Input
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,

                  hintText: "Enter OTP",
                  hintStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Use 1234 if OTP not received",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Verify OTP",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
