import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/input_field.dart';
import 'package:travel_ease_app/src/features/auth/core/presentation/bloc/show_password_cubit.dart';

class AuthInputField extends StatefulWidget {
  final String hint;
  final TextEditingController textController;
  final IconData icon;
  final TextInputType inputType;
  final bool? isObscure;
  final FocusNode? focusNode;
  final void Function(String?)? onChanged;
  final void Function(String?)? onFieldSubmitted;
  final String? Function(String?)? validate;

  const AuthInputField({
    super.key,
    required this.hint,
    required this.textController,
    required this.icon,
    this.isObscure = false,
    this.focusNode,
    this.inputType = TextInputType.text,
    this.onChanged,
    this.onFieldSubmitted,
    this.validate,
  });

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  final ShowPasswordCubit showPasswordCubit = ShowPasswordCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => showPasswordCubit,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: BlocBuilder<ShowPasswordCubit, bool>(
          builder: (context, isShow) {
            return CustomInputField(
              textController: widget.textController,
              inputType: widget.inputType,
              hint: widget.hint,
              isObscure: widget.isObscure! ? !isShow : widget.isObscure,
              focusNode: widget.focusNode,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(widget.icon),
              ),
              suffixIcon: widget.isObscure!
                  ? IconButton(
                      icon: Icon(
                        isShow ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        showPasswordCubit.showPassword();
                      },
                    )
                  : null,
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onFieldSubmitted,
              validate: widget.validate,
            );
          },
        ),
      ),
    );
  }
}
