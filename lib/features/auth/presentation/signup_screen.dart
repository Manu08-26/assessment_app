import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../core/utils/app_snackbar.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SignupScreenBody();
  }
}

class _SignupScreenBody extends StatefulWidget {
  const _SignupScreenBody();

  @override
  State<_SignupScreenBody> createState() => _SignupScreenBodyState();
}

class _SignupScreenBodyState extends State<_SignupScreenBody> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final controller = AuthController();

  bool loading = false;

  Future<void> signup() async {
    setState(() {
      loading = true;
    });

    try {
      await controller.signup(
        emailController.text,
        passwordController.text,
      );
      if (!mounted) return;
      AppSnackBar.success(context, 'Account created successfully');
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            scheme.primary,
                            scheme.primaryContainer,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: scheme.onPrimary.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.person_add_alt_1,
                              color: scheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create account',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: scheme.onPrimary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'It only takes a minute',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: scheme.onPrimary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Create your account',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Use your email to sign up',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      controller: emailController,
                      labelText: 'Email',
                      hintText: 'name@example.com',
                      prefixIcon: const Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: passwordController,
                      labelText: 'Password',
                      hintText: 'Minimum 6 characters',
                      prefixIcon: const Icon(Icons.lock_outline),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => loading ? null : signup(),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: loading ? 'Creating...' : 'Create account',
                      onPressed: loading ? null : signup,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
