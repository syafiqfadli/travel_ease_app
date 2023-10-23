import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/core/app/presentation/pages/base_auth.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/loading.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/core/utils/input_validator.dart';
import 'package:travel_ease_app/src/core/utils/services.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/pages/app_page.dart';
import 'package:travel_ease_app/src/features/auth/auth_injector.dart';
import 'package:travel_ease_app/src/features/auth/core/domain/entities/auth_entity.dart';
import 'package:travel_ease_app/src/features/auth/core/presentation/widgets/auth_input_field.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/bloc/login_cubit.dart';
import 'package:travel_ease_app/src/features/auth/features/reset_password/presentation/pages/reset_password_page.dart';
import 'package:travel_ease_app/src/features/auth/features/signup/presentation/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginCubit loginCubit = authInjector<LoginCubit>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final InputValidator validator = InputValidator();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: loginCubit),
      ],
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginError) {
            DialogService.showMessage(
              title: "Error",
              icon: Icons.error,
              message: state.message,
              context: context,
            );
          }

          if (state is LoginSuccessful) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const AppPage(),
              ),
              (Route<dynamic> route) => false,
            );
          }
        },
        child: BaseAuth(
          title: "Travel Ease",
          description: "I'm waiting for you, please enter your detail",
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
                  hint: "Password",
                  icon: Icons.password,
                  textController: passwordController,
                  isObscure: true,
                  validate: validator.passwordValidation,
                  focusNode: passwordNode,
                  onFieldSubmitted: (_) {
                    _logIn();
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPasswordPage(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: PrimaryColor.pureGrey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      return const CustomLoading();
                    }

                    return ElevatedButton(
                      onPressed: _logIn,
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(width, 50),
                        backgroundColor: PrimaryColor.navyBlack,
                      ),
                      child: const Text(
                        "Log In",
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  },
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: PrimaryColor.pureGrey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: PrimaryColor.navyBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 50)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _logIn() async {
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

    await loginCubit.logIn(authEntity);
  }
}
