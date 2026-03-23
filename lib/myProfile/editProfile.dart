import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';

import '../commonWidgets/common.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // editCallAPI
  // final EditController editController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController incomeController = TextEditingController();

  // final LocalDb = GetStorage();

  bool isNameEmpty = false;
  bool isPhoneEmpty = false;
  bool isPincodeEmpty = false;
  bool isIncomeEmpty = false;

  String? selectedEmploymentType;
  bool isExpanded = false;
  String? selectedIncome;
  bool isOpen = false;
  bool isEmploymentTypeEmpty = false;

  final List<String> employmentTypes = [
    "Salaried",
    "Self-Professional",
    "Self-Business",
    "Student",
  ];

  String _normalizeEmploymentType(String value) {
    value = value.trim().toLowerCase();

    if (value == "self-employee" ||
        value == "self employee" ||
        value == "self-employed" ||
        value == "self employed") {
      return "Self-employee";
    }
    if (value == "salaried") {
      return "Salaried";
    }
    if (value == "student") {
      return "Student";
    }

    return value; // fallback
  }


  void _validateAndSave() {
    setState(() {
      isNameEmpty = nameController.text.trim().isEmpty;
      isPhoneEmpty = phoneNoController.text.trim().isEmpty;
      isPincodeEmpty = pincodeController.text.trim().isEmpty;
      isIncomeEmpty = incomeController.text.trim().isEmpty;
      isEmploymentTypeEmpty =
          selectedEmploymentType == null || selectedEmploymentType!.isEmpty;
    });

    if (isNameEmpty ||
        isPhoneEmpty ||
        isPincodeEmpty ||
        isIncomeEmpty ||
        isEmploymentTypeEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ✅ PREMIUM SUCCESS POPUP
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                colors: [Color(0xff517CE3), Color(0xff6FA4FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // White circle with icon
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Color(0xff517CE3),
                    size: 40,
                  ),
                ),
                SizedBox(height: 20),

                Text(
                  "Success",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),

                Text(
                  "Your profile has been updated successfully",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 25),

                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "OK",
                        style: TextStyle(
                          color: Color(0xff517CE3),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
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
    final bool hasText =
        selectedEmploymentType != null && selectedEmploymentType!.isNotEmpty;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          'Edit Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
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
                    'Mobile Number',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 12),
                  CustomPhoneNumberField(
                    controller: phoneNoController,
                    label: 'Enter Phone Number',
                    readOnly: true,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Pincode',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 12),
                  PinCodeInput(
                    pinCodeController: pincodeController,
                    isPincodeEmpty: isPincodeEmpty,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Employment Type',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 12),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isOpen = !isOpen;
                          });
                        },
                        child: Container(
                          height: 55,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isEmploymentTypeEmpty
                                  ? Colors.red
                                  : Colors.black54,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 200),
                                top: hasText ? 17 : 17,
                                child: Text(
                                  hasText ? "" : "Select Employment Type",
                                  style: GoogleFonts.montserrat(
                                    fontSize: hasText ? 14 : 14,
                                    color: isEmploymentTypeEmpty
                                        ? Colors.red
                                        : Colors.grey,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),

                              if (hasText)
                                Positioned(
                                  top: hasText ? 17 : 17,
                                  child: Text(
                                    selectedEmploymentType!,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),

                              Positioned(
                                right: 0,
                                child: Icon(
                                  isOpen
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: const Color(0xff4E7ADC),
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isOpen)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xffCDD4D9)),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: List.generate(
                              employmentTypes.length,
                              (index) => Column(
                                children: [
                                  ListTile(
                                    dense: true,
                                    visualDensity: const VisualDensity(
                                      vertical: -4,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    minVerticalPadding: 0,
                                    title: Text(
                                      employmentTypes[index],
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedEmploymentType =
                                            employmentTypes[index];
                                        isOpen = false;
                                        isEmploymentTypeEmpty = false;
                                      });
                                    },
                                  ),

                                  if (index != employmentTypes.length - 1)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Divider(
                                        thickness: 1,
                                        color: Color(0xffCDD4D9),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Income',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 12),
                  IncomeFieldForm(
                    controller: incomeController,
                    label: 'Enter Income',
                    triggerValidation: isIncomeEmpty,
                  ),
                  Visibility(
                    visible: isIncomeEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Text(
                        'Income is mandatory',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 25, left: 16, right: 16),
        child: InkWell(
          onTap: () {
            _validateAndSave();
          },
          child: CustomButton(
            buttonText: 'Save',
            buttonColor: Color(0xff517CE3),
            textColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
