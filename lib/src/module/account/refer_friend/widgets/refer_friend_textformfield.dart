import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReferFriendTextformfield extends StatelessWidget {
  final String? title;
  final String hint;
  final TextEditingController controller;
  final TextInputType? inputType;
  final int? maxLenght;
  final String? Function(String?)? validator; // Optional validator
  final EdgeInsetsGeometry? padding; // Optional padding

  const ReferFriendTextformfield({
    super.key,
    this.title,
    required this.hint,
    required this.controller,
    this.inputType,
    this.maxLenght,
    this.validator, // Optional validator
    this.padding, // Optional padding
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title != null
              ? Text(
                  title ?? "",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                )
              : const SizedBox(height: 5),
          SizedBox(
            height: maxLenght == null ? 50 : 65,
            child: TextFormField(
              validator: validator,
              maxLength: maxLenght,
              controller: controller,
              keyboardType: inputType,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.poppins(
                    color: Colors.grey, fontWeight: FontWeight.w300),
                border: InputBorder.none, // Removes underline
                enabledBorder:
                    InputBorder.none, // Removes underline when not focused
                focusedBorder:
                    InputBorder.none, // Removes underline when focused
                errorBorder:
                    InputBorder.none, // Removes underline for validation error
                disabledBorder: InputBorder.none, // Removes underline w
                // enabledBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(8),
                //   borderSide: const BorderSide(
                //     color: Colors.grey,
                //   ),
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
