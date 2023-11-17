import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/features/auth/core/presentation/widgets/base_auth.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/loading.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/core/utils/input_validator.dart';
import 'package:travel_ease_app/src/core/utils/services.dart';
import 'package:travel_ease_app/src/features/auth/auth_injector.dart';
import 'package:travel_ease_app/src/features/auth/core/domain/entities/auth_entity.dart';
import 'package:travel_ease_app/src/features/auth/core/presentation/widgets/auth_input_field.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/pages/login_page.dart';
import 'package:travel_ease_app/src/features/auth/features/reset_password/presentation/bloc/reset_password_cubit.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final ResetPasswordCubit resetPasswordCubit =
      authInjector<ResetPasswordCubit>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final InputValidator validator = InputValidator();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: resetPasswordCubit),
      ],
      child: BlocListener<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) async {
          if (state is ResetPasswordError) {
            DialogService.showMessage(
              title: "Error",
              icon: Icons.error,
              message: state.message,
              context: context,
            );
          }

          if (state is ResetPasswordSuccessful) {
            await DialogService.showMessage(
              title: "Successful",
              icon: Icons.check,
              message: state.message,
              context: context,
            );

            _navigateToLoginPage();
          }
        },
        child: BaseAuth(
          title: "Reset Password",
          description: "We people forget thing sometimes, right?",
          backToLogin: true,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                AuthInputField(
                  hint: "Email",
                  icon: Icons.email,
                  textController: emailController,
                  validate: validator.emailValidation,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(passwordNode);
                  },
                ),
                AuthInputField(
                  hint: "New Password",
                  icon: Icons.password,
                  textController: passwordController,
                  isObscure: true,
                  validate: validator.createPasswordValidation,
                  focusNode: passwordNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(confirmNode);
                  },
                ),
                AuthInputField(
                  hint: "Retype New Password",
                  icon: Icons.password,
                  textController: confirmController,
                  isObscure: true,
                  validate: (value) {
                    if (value != passwordController.text) {
                      return "Password does not match";
                    }

                    return null;
                  },
                  focusNode: confirmNode,
                  onFieldSubmitted: (_) {
                    _resetPassword();
                  },
                ),
                const SizedBox(height: 50),
                BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                  builder: (context, state) {
                    if (state is ResetPasswordLoading) {
                      return const CustomLoading();
                    }

                    return ElevatedButton(
                      onPressed: _resetPassword,
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(width, 50),
                        backgroundColor: PrimaryColor.navyBlack,
                      ),
                      child: const Text(
                        "Reset",
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  },
                ),
                TextButton(
                  onPressed: () => _navigateToLoginPage(),
                  child: Text(
                    "Back to Log In",
                    style: TextStyle(
                      color: PrimaryColor.pureGrey,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final String email = emailController.text;
    final String password = passwordController.text;

    final authEntity = AuthEntity(
      email: email,
      password: password,
    );

    await resetPasswordCubit.resetPassword(authEntity);
  }

  void _navigateToLoginPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }
}
