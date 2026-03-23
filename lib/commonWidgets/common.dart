import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isError;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.isError = false,
    String? errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasText = controller.text.isNotEmpty;
    return Container(
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isError ? Colors.red : Colors.black54),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: hasText ? null : label,
            labelStyle: GoogleFonts.montserrat(
              color: isError ? Colors.red : Colors.grey,
              fontSize: 14,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ),
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            // Allows only alphabets
          ],
          onChanged: (value) {
            if (value.isNotEmpty && !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
              // Show snackbar if non-alphabetic character is entered
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Name field allows only alphabetic characters'),
                  backgroundColor: Colors.white,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class CustomNumberFieldForm extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isError;

  const CustomNumberFieldForm({
    Key? key,
    required this.controller,
    required this.label,
    this.isError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isError ? Colors.red : Color(0xffCDD4D9)),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.montserrat(
              color: isError ? Colors.red : Colors.grey,
              fontSize: 16,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ),
          keyboardType: TextInputType.number,
          // For numeric input
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            // Restricts input to digits only
          ],
          onChanged: (value) {
            if (value.isNotEmpty && !RegExp(r'^\d+$').hasMatch(value)) {
              // Show snackbar if non-numeric character is entered (shouldn't happen with this configuration)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('This field allows only numbers'),
                  backgroundColor: Colors.white,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class CustomTextFieldSmall extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isError;

  const CustomTextFieldSmall({
    Key? key,
    required this.controller,
    required this.label,
    this.isError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isError ? Colors.red : Colors.grey),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.montserrat(
              color: isError ? Colors.red : Colors.grey,
              fontSize: 18,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ),
          keyboardType: TextInputType.text,
        ),
      ),
    );
  }
}

class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return TextEditingValue.empty;
    }

    if (newValue.text.length == 1 &&
        // !RegExp(r'[6789]').hasMatch(newValue.text)) {
        !RegExp(r'[5-9]').hasMatch(newValue.text)) {
      return oldValue;
    }

    final String filteredText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (filteredText.length > 10) {
      return oldValue;
    }

    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: filteredText.length),
    );
  }
}

class CustomPhoneNumberField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool
  triggerValidation; // Added to trigger validation on "Create Account" click
  final bool readOnly; // Added readOnly parameter

  const CustomPhoneNumberField({
    Key? key,
    required this.controller,
    required this.label,
    this.triggerValidation = false, // By default, don't trigger validation
    this.readOnly = false, // Default to false for editability
  }) : super(key: key);

  @override
  _CustomPhoneNumberFieldState createState() => _CustomPhoneNumberFieldState();
}

class _CustomPhoneNumberFieldState extends State<CustomPhoneNumberField> {
  bool isError = false;
  String? errorText;

  @override
  void didUpdateWidget(CustomPhoneNumberField oldWidget) {
    // Check for validation trigger update
    if (widget.triggerValidation && widget.controller.text.isEmpty) {
      setState(() {
        isError = true;
        errorText = "Phone number is required.";
      });
    } else if (widget.triggerValidation) {
      validatePhoneNumber(widget.controller.text);
    }
    super.didUpdateWidget(oldWidget);
  }

  void validatePhoneNumber(String value) {
    if (value.isEmpty) {
      setState(() {
        isError = true;
        errorText = "Phone number is required.";
      });
    } else if (value.length != 10) {
      setState(() {
        isError = true;
        errorText = "Please enter a valid 10-digit phone number.";
      });
    } else if (!RegExp(r'^[6789][0-9]{9}$').hasMatch(value)) {
      // else if (!RegExp(r'^[5-9][0-9]{9}$').hasMatch(value)) {
      setState(() {
        isError = true;
        errorText = "Phone number must start with 6, 7, 8, or 9.";
      });
    } else {
      setState(() {
        isError = false;
        errorText = null;
      });
    }
  }

  // void validatePhoneNumber(String value) {
  //   if (value.isEmpty) {
  //     setState(() {
  //       isError = true;
  //       errorText = "Phone number is required.";
  //     });
  //   } else if (!RegExp(r'^[5-9][0-9]{9}$').hasMatch(value)) {
  //     setState(() {
  //       isError = true;
  //       errorText =
  //           "Phone number must start with 5, 6, 7, 8, or 9 and contain 10 digits.";
  //     });
  //   } else {
  //     setState(() {
  //       isError = false;
  //       errorText = null;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final bool hasText = widget.controller.text.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isError ? Colors.red : Colors.black54),
          ),
          child: Center(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: hasText ? null : widget.label,
                labelStyle: GoogleFonts.montserrat(
                  color: widget.readOnly
                      ? Colors.grey
                      : (isError ? Colors.red : Colors.grey),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                hintText: widget.readOnly ? 'Phone Number' : null,
                // Optional hint if needed
                hintStyle: GoogleFonts.montserrat(
                  color: widget.readOnly
                      ? Colors.grey
                      : Colors.transparent, // Show hint in grey when readOnly
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [PhoneNumberInputFormatter()],
              readOnly: widget.readOnly,
              // Set the readOnly value here
              style: GoogleFonts.montserrat(
                color: widget.readOnly
                    ? Colors.grey
                    : Colors.black, // Text color in grey if readOnly
              ),
              onChanged: (value) {
                if (value.isNotEmpty &&
                    !RegExp(r'^[6789]').hasMatch(value[0])) {
                  widget.controller.clear();
                  setState(() {
                    isError = true;
                    errorText = "Phone number must start with 6, 7, 8, 9.";
                  });
                  return;
                }

                validatePhoneNumber(value);
              },
            ),
          ),
        ),
        if (isError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText ?? "Please enter a valid 10-digit phone number.",
              style: GoogleFonts.montserrat(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class CustomTextFieldForm extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool triggerValidation;
  final String emptyErrorMessage;
  final String invalidErrorMessage;
  final Function(String)? onComplete;

  const CustomTextFieldForm({
    Key? key,
    required this.controller,
    required this.label,
    this.onComplete,
    required this.triggerValidation,
    required this.emptyErrorMessage,
    required this.invalidErrorMessage,
  }) : super(key: key);

  @override
  _CustomTextFieldFormState createState() => _CustomTextFieldFormState();
}

class _CustomTextFieldFormState extends State<CustomTextFieldForm> {
  bool isError = false;
  String? errorText;

  @override
  void didUpdateWidget(CustomTextFieldForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.triggerValidation) {
      validateTextField(widget.controller.text);
    }
  }

  void validateTextField(String value) {
    if (value.isEmpty) {
      setState(() {
        isError = true;
        errorText = widget.emptyErrorMessage;
      });
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      setState(() {
        isError = true;
        errorText = widget.invalidErrorMessage;
      });
    } else {
      setState(() {
        isError = false;
        errorText = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasText = widget.controller.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isError ? Colors.red : Colors.black38),
          ),
          child: Center(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: hasText ? null : widget.label,
                labelStyle: GoogleFonts.montserrat(
                  color: isError ? Colors.red : Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
              onChanged: (value) {
                validateTextField(value);
              },
            ),
          ),
        ),
        if (isError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText ?? "",
              style: GoogleFonts.montserrat(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

// todo this
class PhoneNumberInput extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController nameController;
  final bool isPhoneEmpty;
  final Function()? onFetch;
  final String label;

  const PhoneNumberInput({
    Key? key,
    required this.phoneController,
    required this.nameController,
    required this.isPhoneEmpty,
    required this.onFetch,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isPhoneEmpty ? Colors.red : const Color(0xffCDD4D9),
            ),
          ),
          child: Center(
            child: TextField(
              controller: phoneController,
              onChanged: (value) {
                if (value.length == 10 &&
                    nameController.text.trim().isNotEmpty) {
                  onFetch!(); // 🔥 Fire API
                }
              },
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                labelStyle: GoogleFonts.montserrat(
                  color: isPhoneEmpty ? Colors.red : Colors.grey,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
          ),
        ),
        Visibility(
          visible: isPhoneEmpty,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Text(
              'Mobile Number is mandatory',
              style: GoogleFonts.montserrat(color: Colors.red, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomPhoneNumberFieldForm extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool triggerValidation;
  final bool readOnly;
  final Function(String)? onComplete;

  const CustomPhoneNumberFieldForm({
    Key? key,
    required this.controller,
    required this.label,
    this.onComplete,
    this.triggerValidation = false, // By default, don't trigger validation
    this.readOnly = false, // Default to false for editability
  }) : super(key: key);

  @override
  _CustomPhoneNumberFieldFormState createState() =>
      _CustomPhoneNumberFieldFormState();
} // this

class _CustomPhoneNumberFieldFormState
    extends State<CustomPhoneNumberFieldForm> {
  bool isError = false;
  String? errorText;

  @override
  void didUpdateWidget(CustomPhoneNumberFieldForm oldWidget) {
    // Check for validation trigger update
    if (widget.triggerValidation && widget.controller.text.isEmpty) {
      setState(() {
        isError = true;
        errorText = "Phone number is required.";
      });
    } else if (widget.triggerValidation) {
      validatePhoneNumber(widget.controller.text);
    }
    super.didUpdateWidget(oldWidget);
  }

  void validatePhoneNumber(String value) {
    if (value.isEmpty) {
      setState(() {
        isError = true;
        errorText = "Phone number is required.";
      });
    } else if (value.length != 10) {
      setState(() {
        isError = true;
        errorText = "Please enter a valid 10-digit phone number.";
      });
    }
    if (value.isNotEmpty && !RegExp(r'^[6789]').hasMatch(value[0])) {
      setState(() {
        isError = true;
        errorText = "Phone number must start with 6, 7, 8, 9.";
      });
    } else {
      setState(() {
        isError = false;
        errorText = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasText = widget.controller.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isError ? Colors.red : Colors.black54),
          ),
          child: Center(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: hasText ? null : widget.label,
                labelStyle: GoogleFonts.montserrat(
                  color: widget.readOnly
                      ? Colors.grey
                      : (isError ? Colors.red : Colors.grey),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                hintText: widget.readOnly ? 'Phone Number' : null,
                // Optional hint if needed
                hintStyle: GoogleFonts.montserrat(
                  color: widget.readOnly
                      ? Colors.grey
                      : Colors.transparent, // Show hint in grey when readOnly
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [PhoneNumberInputFormatter()],
              readOnly: widget.readOnly,
              // Set the readOnly value here
              style: GoogleFonts.montserrat(
                color: widget.readOnly
                    ? Colors.grey
                    : Colors.black, // Text color in grey if readOnly
              ),
              onChanged: (value) {
                if (!widget.readOnly) {
                  // Only validate if not read-only
                  validatePhoneNumber(value);
                }
              },
            ),
          ),
        ),
        if (isError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText ?? "Please enter a valid 10-digit phone number.",
              style: GoogleFonts.montserrat(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class CustomTextFieldFormNew extends StatefulWidget {
  final TextEditingController controller;

  final String label;
  final Function(String)? onChange; // ✅ FIXED
  final bool triggerValidation;
  final String emptyErrorMessage;
  final String invalidErrorMessage;

  const CustomTextFieldFormNew({
    Key? key,
    required this.controller,
    required this.label,
    this.onChange,
    required this.triggerValidation,
    required this.emptyErrorMessage,
    required this.invalidErrorMessage,
  }) : super(key: key);

  @override
  _CustomTextFieldFormNewState createState() => _CustomTextFieldFormNewState();
}

class _CustomTextFieldFormNewState extends State<CustomTextFieldFormNew> {
  bool isError = false;
  String? errorText;

  @override
  void didUpdateWidget(CustomTextFieldFormNew oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.triggerValidation) {
      validateTextField(widget.controller.text);
    }
  }

  void validateTextField(String value) {
    if (value.isEmpty) {
      setState(() {
        isError = true;
        errorText = widget.emptyErrorMessage;
      });
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      setState(() {
        isError = true;
        errorText = widget.invalidErrorMessage;
      });
    } else {
      setState(() {
        isError = false;
        errorText = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isError ? Colors.red : const Color(0xffCDD4D9),
            ),
          ),
          child: Center(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: GoogleFonts.montserrat(
                  color: isError ? Colors.red : Colors.grey,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
              onChanged: (value) {
                validateTextField(value);
              },
            ),
          ),
        ),
        if (isError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText ?? "",
              style: GoogleFonts.montserrat(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class PhoneNumberFieldNew extends StatefulWidget {
  final TextEditingController signZPhoneController;
  final String label;
  final Function(String)? onChange; // ✅ FIXED
  final bool triggerValidation;
  final bool readOnly;
  final String emptyErrorMessage;
  final String invalidErrorMessage;

  const PhoneNumberFieldNew({
    Key? key,
    required this.signZPhoneController,
    required this.label,
    this.onChange, // ✅ FIXED
    this.triggerValidation = false,
    this.readOnly = false,
    required this.emptyErrorMessage,
    required this.invalidErrorMessage,
  }) : super(key: key);

  @override
  _PhoneNumberFieldNewState createState() => _PhoneNumberFieldNewState();
}

class _PhoneNumberFieldNewState extends State<PhoneNumberFieldNew> {
  bool isError = false;
  String? errorText;

  @override
  void didUpdateWidget(PhoneNumberFieldNew oldWidget) {
    if (widget.triggerValidation && widget.signZPhoneController.text.isEmpty) {
      setState(() {
        isError = true;
        errorText = "Phone number is required.";
      });
    } else if (widget.triggerValidation) {
      validatePhoneNumber(widget.signZPhoneController.text);
    }
    super.didUpdateWidget(oldWidget);
  }

  void validatePhoneNumber(String value) {
    if (value.isEmpty) {
      setState(() {
        isError = true;
        errorText = "Phone number is required.";
      });
    } else if (value.length != 10) {
      setState(() {
        isError = true;
        errorText = "Please enter a valid 10-digit phone number.";
      });
    } else if (!RegExp(r'^[6789]').hasMatch(value)) {
      setState(() {
        isError = true;
        errorText = "Phone number must start with 6, 7, 8, or 9.";
      });
    } else {
      setState(() {
        isError = false;
        errorText = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isError ? Colors.red : const Color(0xffCDD4D9),
            ),
          ),
          child: Center(
            child: TextField(
              controller: widget.signZPhoneController,
              keyboardType: TextInputType.number,
              readOnly: widget.readOnly,
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: GoogleFonts.montserrat(
                  color: widget.readOnly
                      ? Colors.grey
                      : (isError ? Colors.red : Colors.grey),
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              style: GoogleFonts.montserrat(
                color: widget.readOnly ? Colors.grey : Colors.black,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              onChanged: (value) {
                if (!widget.readOnly) {
                  validatePhoneNumber(value);

                  if (widget.onChange != null) {
                    widget.onChange!(value); // ✅ TRIGGER CALLBACK
                  }
                }
              },
            ),
          ),
        ),
        if (isError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText ?? '',
              style: GoogleFonts.montserrat(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class PinCodeInput extends StatefulWidget {
  final TextEditingController pinCodeController;
  final bool isPincodeEmpty;
  final Function(String)? onChange;
  final String label;

  const PinCodeInput({
    Key? key,
    required this.pinCodeController,
    this.onChange,
    required this.isPincodeEmpty,
    this.label = 'Enter Current Pincode',
  }) : super(key: key);

  @override
  State<PinCodeInput> createState() => _PinCodeInputState();
}

class _PinCodeInputState extends State<PinCodeInput> {
  @override
  Widget build(BuildContext context) {
    final bool hasText = widget.pinCodeController.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isPincodeEmpty ? Colors.red : Colors.black38,
            ),
          ),
          child: Center(
            child: TextField(
              onChanged: (value) {
                setState(() {}); // Rebuild to update label visibility
                widget.onChange?.call(value);
              },
              controller: widget.pinCodeController,
              decoration: InputDecoration(
                labelText: hasText ? null : widget.label,
                labelStyle: GoogleFonts.montserrat(
                  color: widget.isPincodeEmpty ? Colors.red : Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget.isPincodeEmpty,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Text(
              'Pincode is mandatory',
              style: GoogleFonts.montserrat(color: Colors.red, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class IncomeField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isError;

  const IncomeField({
    Key? key,

    required this.controller,
    required this.label,
    this.isError = false,

    String? errorText,

    required,
  }) : super(key: key);

  @override
  State<IncomeField> createState() => _IncomeFieldState();
}

class _IncomeFieldState extends State<IncomeField> {
  @override
  Widget build(BuildContext context) {
    final bool hasText = widget.controller.text.isNotEmpty;
    return Container(
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.isError ? Colors.red : Colors.black38),
      ),
      child: Center(
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: hasText ? null : widget.label,
            labelStyle: GoogleFonts.montserrat(
              color: widget.isError ? Colors.red : Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // Allows only digits
          ],
          onChanged: (value) {
            if (value.isNotEmpty && !RegExp(r'^\d+$').hasMatch(value)) {
              // Show snackbar if non-digit character is entered
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Income field allows only numbers'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class IncomeFieldForm extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool triggerValidation; // Added to trigger validation externally

  const IncomeFieldForm({
    Key? key,
    required this.controller,
    required this.label,
    this.triggerValidation = false, // Default is false
  }) : super(key: key);

  @override
  State<IncomeFieldForm> createState() => _IncomeFieldFormState();
}

class _IncomeFieldFormState extends State<IncomeFieldForm> {
  bool isError = false;
  String? errorMessage;

  @override
  void didUpdateWidget(covariant IncomeFieldForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.triggerValidation && widget.controller.text.isEmpty) {
      validateIncome(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasText = widget.controller.text.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isError ? Colors.red : Colors.black38),
          ),
          child: Center(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: hasText ? null : widget.label,
                labelStyle: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  color: isError ? Colors.red : Colors.grey,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                prefixText: "₹ ",
                prefixStyle: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Allows only numbers
              ],
              onChanged: (value) {
                validateIncome(value);
              },
            ),
          ),
        ),
        if (isError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorMessage ?? '',
              style: GoogleFonts.montserrat(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }

  void validateIncome(String value) {
    setState(() {
      if (value.isEmpty) {
        isError = true;
        errorMessage = 'Loan amount is mandatory.';
      } else if (!RegExp(r'^\d+$').hasMatch(value)) {
        isError = true;
        errorMessage = 'Please enter a valid loan amount.';
      } else {
        isError = false;
        errorMessage = null;
      }
    });
  }
}

class EmailField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const EmailField({Key? key, required this.controller, required this.label})
    : super(key: key);

  @override
  _EmailFieldState createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  bool isError = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final bool hasText = widget.controller.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isError ? Colors.red : Colors.black54),
          ),
          child: Center(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: hasText ? null : widget.label,
                labelStyle: GoogleFonts.montserrat(
                  color: isError ? Colors.red : Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@.]')),
                // Allows only alphanumeric characters and '@', '.'
              ],
              onChanged: (value) {
                validateEmail(value);
              },
            ),
          ),
        ),
        if (isError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorMessage ?? '',
              style: GoogleFonts.montserrat(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }

  void validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        isError = true;
        errorMessage = 'This field is mandatory.';
      } else if (!isValidEmail(value)) {
        isError = true;
        errorMessage = 'Please enter a valid email.';
      } else {
        isError = false;
        errorMessage = null;
      }
    });
  }

  bool isValidEmail(String email) {
    // Regex to validate the email format
    final RegExp regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return regex.hasMatch(email);
  }
}

class EmailFieldForm extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool triggerValidation;

  const EmailFieldForm({
    Key? key,
    required this.controller,
    required this.label,
    this.triggerValidation = false,
  }) : super(key: key);

  @override
  _EmailFieldFormState createState() => _EmailFieldFormState();
}

class _EmailFieldFormState extends State<EmailFieldForm> {
  bool isError = false;
  String? errorMessage;

  @override
  void didUpdateWidget(covariant EmailFieldForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 🔥 IMPORTANT FIX: When emailController.text is updated programmatically,
    // rebuild UI so TextField shows new value.
    if (oldWidget.controller.text != widget.controller.text) {
      setState(() {});
    }

    // External trigger validation
    if (widget.triggerValidation) {
      validateEmail(widget.controller.text);
    }
  }

  void validateEmail(String value) {
    // Regex for basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (value.isEmpty) {
      setState(() {
        isError = true;
        errorMessage = "Email is required.";
      });
    } else if (!emailRegex.hasMatch(value)) {
      setState(() {
        isError = true;
        errorMessage = "Invalid email format.";
      });
    } else {
      setState(() {
        isError = false;
        errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasText = widget.controller.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isError ? Colors.red : Colors.black54),
          ),
          child: Center(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: hasText ? null : widget.label,
                labelStyle: GoogleFonts.montserrat(
                  color: isError ? Colors.red : Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),
              ],
              onChanged: (value) {
                validateEmail(value);
              },
            ),
          ),
        ),
        if (isError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorMessage ?? '',
              style: GoogleFonts.montserrat(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }
}

class PanCardField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const PanCardField({Key? key, required this.controller, required this.label})
    : super(key: key);

  @override
  _PanCardFieldState createState() => _PanCardFieldState();
}

class _PanCardFieldState extends State<PanCardField> {
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final bool hasText = widget.controller.text.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorMessage != null ? Colors.red : Colors.black38,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              labelText: hasText ? null : widget.label,
              labelStyle: GoogleFonts.montserrat(
                color: errorMessage != null ? Colors.red : Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            keyboardType: TextInputType.text,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              LengthLimitingTextInputFormatter(10), // Limit to 10 characters
            ],
            onChanged: (value) {
              // Clear error message as user types
              setState(() {
                errorMessage = null;
              });
              widget.controller.text = value.toUpperCase();
              // Validate the format after every change
              if (value.length == 10) {
                final RegExp panRegExp = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
                if (!panRegExp.hasMatch(value.toUpperCase())) {
                  // If the format is incorrect, show error
                  setState(() {
                    errorMessage =
                        'Please enter a valid PAN card number (e.g., AXCMB9807A)';
                  });
                }
              }
            },
          ),
        ),
        if (errorMessage != null) // Show error message outside the text field
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorMessage!,
              style: GoogleFonts.montserrat(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }
}

class MessageInputField extends StatefulWidget {
  final Function(String) onSendMessage; // Callback for sending messages
  final String hintText; // Hint text for the input field
  final Color hintTextColor; // Color for the hint text
  final TextStyle hintTextStyle; // Font style for hint text
  final TextEditingController controller; // Required TextEditingController

  const MessageInputField({
    Key? key,
    required this.onSendMessage,
    this.hintText = 'Message', // Default hint text
    this.hintTextColor = Colors.grey, // Default hint text color
    this.hintTextStyle = const TextStyle(), // Default font style for hint text
    required this.controller, // Added required controller parameter
  }) : super(key: key);

  @override
  _MessageInputFieldState createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  void _sendMessage() {
    if (widget.controller.text.isNotEmpty) {
      widget.onSendMessage(
        widget.controller.text,
      ); // Send the message via callback
      widget.controller.clear(); // Clear the text field after sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black38), // Set border color
      ),
      child: TextField(
        controller:
            widget.controller, // Use the controller passed from the parent
        maxLines: 3, // Limit to maximum 3 lines
        minLines: 1, // Optional: set minimum number of lines to 1
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.hintTextStyle.copyWith(
            color: widget.hintTextColor, // Set the hint text color and style
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ), // Match with Container's border radius
            borderSide: BorderSide.none, // Maintain the same color when focused
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ), // Match with Container's border radius
            borderSide: BorderSide.none, // Maintain the same color when enabled
          ),
        ),
        onSubmitted: (value) => _sendMessage(), // Call _sendMessage on submit
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String buttonText; // Text to display on the button
  final Color buttonColor; // Background color of the button
  final Color textColor; // Text color of the button

  // Constructor to receive the text, background color, and text color
  const CustomButton({
    Key? key,
    required this.buttonText,
    required this.buttonColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF6750A4), // left
            Color(0xFF6750A4), // right
          ],
        ),
      ),
      child: Center(
        child: Text(
          buttonText,
          style: GoogleFonts.montserrat(
            color: textColor, // Set the text color here
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class CustomButtonHeight extends StatelessWidget {
  final String buttonText; // Text to display on the button
  final Color buttonColor; // Background color of the button
  final Color textColor; // Text color of the button
  final double height; // Height of the button
  final VoidCallback onTap; // onTap callback function

  // Constructor to receive text, background color, text color, height, and onTap function
  const CustomButtonHeight({
    Key? key,
    required this.buttonText,
    required this.buttonColor,
    required this.textColor,
    this.height = 66, // Default height
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle tap event
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: GoogleFonts.montserrat(
              color: textColor, // Set the text color here
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButtons extends StatelessWidget {
  final String buttonText; // Text to display on the button
  final Color buttonColor; // Background color of the button
  final Color textColor; // Text color of the button

  // Constructor to receive the text, background color, and text color
  const CustomButtons({
    Key? key,
    required this.buttonText,
    required this.buttonColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF517CE3), // left
            Color(0xFF3476A7), // right
          ],
        ),
      ),
      child: Center(
        child: Text(
          buttonText,
          style: GoogleFonts.montserrat(
            color: textColor, // Set the text color here
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}

class CustomButtonsHeight extends StatelessWidget {
  final String buttonText; // Text to display on the button
  final Color buttonColor; // Background color of the button
  final Color textColor; // Text color of the button
  final double height; // Height of the button
  final VoidCallback onTap; // onTap callback function

  // Constructor to receive text, background color, text color, height, and onTap function
  const CustomButtonsHeight({
    Key? key,
    required this.buttonText,
    required this.buttonColor,
    required this.textColor,
    this.height = 66, // Default height
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle tap event
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: GoogleFonts.montserrat(
              color: textColor, // Set the text color here
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
