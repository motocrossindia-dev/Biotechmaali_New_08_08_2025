import 'package:flutter/material.dart';
import '../../../../../core/config/pallet.dart';

class EditProfileTextForm extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLength;

  const EditProfileTextForm({
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.maxLength,
    this.keyboardType,
    this.onTap,
    this.readOnly = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: cBorderGrey),
        labelText: labelText,
        hintText: hintText,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: cTextFormFieldGrey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: cButtonGreen),
        ),
      ),
    );
  }
}
