import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../commonWidgets/common.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool isNameEmpty = false;
  bool isEmailEmpty = false;
  bool isPhoneEmpty = false;
  bool isSubjectEmpty = false;
  bool isMessageEmpty = false;

  String? selectedEmploymentType;
  bool isExpanded = false;

  void _handleSendMessage(String message) {
    print("Message sent: $message");
  }

  void _validateAndSubmit() {
    setState(() {
      isNameEmpty = nameController.text.trim().isEmpty;
      isEmailEmpty = emailController.text.trim().isEmpty;
      isPhoneEmpty = phoneNoController.text.trim().isEmpty;
      isSubjectEmpty = subjectController.text.trim().isEmpty;
      isMessageEmpty = messageController.text.trim().isEmpty;
    });

    // Email format check
    bool isEmailValid = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(emailController.text.trim());

    if (isNameEmpty ||
        isEmailEmpty ||
        isPhoneEmpty ||
        isSubjectEmpty ||
        isMessageEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!isEmailValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a valid email"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ✅ SUCCESS POPUP
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
                SizedBox(height: 16),
                Text(
                  "Success",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Your issue is created successfully and soon our team contact you",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6750A4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("OK",style: TextStyle(
                    color: Colors.white
                  ),),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF6750A4),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, size: 20,color: Colors.white,),
        ),
        centerTitle: true,
        title: Text(
          'Contact Us',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Text(
                        'Name',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 12),
                      CustomTextField(
                        controller: nameController,
                        label: 'Enter Name',
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Email Address',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 12),
                      EmailField(
                        controller: emailController,
                        label: 'Enter Email Address',
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Mobile Number',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 12),
                      CustomPhoneNumberField(
                        controller: phoneNoController,
                        label: 'Enter Mobile Number',
                        readOnly: false,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Subject',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 12),
                      CustomTextField(
                        controller: subjectController,
                        label: 'Enter Subject',
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Reason for Contacting',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 12),
                      MessageInputField(
                        controller: messageController,
                        onSendMessage: _handleSendMessage,
                        hintText: 'Enter The Problem You Are Facing',
                        // hintTextColor: Color(0xffCDD4D9),
                        // Custom hint text (optional)
                      ),
                      // SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 25, left: 16, right: 16),
        child: InkWell(
          onTap: () {
            _validateAndSubmit();
          },
          child: CustomButton(
            buttonText: 'Send',
            buttonColor: Color(0xFF6750A4),
            textColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
