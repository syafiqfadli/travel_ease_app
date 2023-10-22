import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/core/app/presentation/pages/base_auth.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/core/utils/input_validator.dart';
import 'package:travel_ease_app/src/core/utils/services.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/pages/app_page.dart';
import 'package:travel_ease_app/src/features/auth/auth_injector.dart';
import 'package:travel_ease_app/src/features/auth/core/domain/entities/auth_entity.dart';
import 'package:travel_ease_app/src/features/auth/core/presentation/widgets/auth_input_field.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/bloc/login_cubit.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/pages/login_page.dart';
import 'package:travel_ease_app/src/features/auth/features/signup/presentation/bloc/signup_cubit.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final SignUpCubit signUpCubit = authInjector<SignUpCubit>();
  final LoginCubit loginCubit = authInjector<LoginCubit>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final InputValidator validator = InputValidator();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: signUpCubit),
        BlocProvider.value(value: loginCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<SignUpCubit, SignUpState>(
            listener: (context, state) {
              if (state is SignUpError) {
                DialogService.showMessage(
                  title: "Error",
                  icon: Icons.error,
                  message: state.message,
                  context: context,
                );
              }
            },
          ),
          BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccessful) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const AppPage(),
                  ),
                  (Route<dynamic> route) => false,
                );
              }
            },
          ),
        ],
        child: BaseAuth(
          title: "Hi! Welcome",
          description: "Let's create an account",
          child: Form(
            key: formKey,
            child: Column(
              children: [
                AuthInputField(
                  hint: "Name",
                  icon: Icons.person,
                  textController: nameController,
                  validate: validator.nameValidation,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(emailNode);
                  },
                ),
                AuthInputField(
                  hint: "Email",
                  icon: Icons.email,
                  textController: emailController,
                  validate: validator.emailValidation,
                  focusNode: emailNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(passwordNode);
                  },
                ),
                AuthInputField(
                  hint: "Password",
                  icon: Icons.password,
                  textController: passwordController,
                  isObscure: true,
                  validate: validator.createPasswordValidation,
                  focusNode: passwordNode,
                  onFieldSubmitted: (_) {
                    _signUp();
                  },
                ),
                const SizedBox(height: 50),
                BlocBuilder<SignUpCubit, SignUpState>(
                  builder: (context, state) {
                    if (state is SignUpLoading) {
                      return const CircularProgressIndicator();
                    }

                    return ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(width, 50),
                        backgroundColor: PrimaryColor.navyBlack,
                      ),
                      child: const Text(
                        "Sign Up",
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
                      "Have an account?",
                      style: TextStyle(color: PrimaryColor.pureGrey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Text(
                        "Log In",
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

  Future<void> _signUp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final String email = emailController.text;
    final String password = passwordController.text;
    final String name = nameController.text;

    final authEntity = AuthEntity(
      email: email,
      password: password,
      displayName: name,
    );

    await signUpCubit.signUp(authEntity);
    await loginCubit.logIn(authEntity);
  }
}
