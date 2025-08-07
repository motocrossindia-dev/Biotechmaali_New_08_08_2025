import 'package:biotech_maali/core/config/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonTextFormWidget extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final TextInputType? inputType;
  final int? maxLenght;

  final String? Function(String?)? validator; // Optional validator
  final EdgeInsetsGeometry? padding; // Optional padding
  final Function(String)? onChanged;

  const CommonTextFormWidget({
    super.key,
    required this.title,
    required this.hint,
    required this.controller,
    this.inputType,
    this.maxLenght,
    this.validator, // Optional validator
    this.padding, // Optional padding
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: maxLenght == null ? 50 : 65,
            child: TextFormField(
              onChanged: onChanged,
              validator: validator,
              maxLength: maxLenght,
              controller: controller,
              keyboardType: inputType,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.poppins(
                    color: Colors.grey, fontWeight: FontWeight.w300),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: cButtonGreen, // Change color as needed
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
