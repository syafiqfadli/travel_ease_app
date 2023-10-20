import 'package:flutter/material.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController textController;
  final TextInputType inputType;
  final bool? isObscure;
  final bool hasBorder;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final String? hint;
  final String? Function(String?)? validate;
  final void Function(String?)? onChanged;
  final void Function(String?)? onFieldSubmitted;

  const CustomInputField({
    Key? key,
    required this.textController,
    this.inputType = TextInputType.text,
    this.isObscure = false,
    this.hasBorder = false,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.hint,
    this.validate,
    this.onChanged,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: textController,
      obscureText: isObscure!,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: validate,
      keyboardType: inputType,
      cursorColor: PrimaryColor.navyBlack,
      style: TextStyle(fontSize: 16, color: PrimaryColor.navyBlack),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        prefixIconColor: PrimaryColor.pureGrey,
        suffixIcon: suffixIcon,
        suffixIconColor: PrimaryColor.pureGrey,
        fillColor: PrimaryColor.pureWhite,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: hasBorder
              ? const BorderSide()
              : const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: PrimaryColor.navyBlack),
        ),
        hintText: hint,
        hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
        errorText: null,
        errorStyle: Theme.of(context).inputDecorationTheme.errorStyle,
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}
