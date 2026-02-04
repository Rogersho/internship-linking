import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/common_widgets.dart';
import 'auth_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  // Specific fields
  final _industryController = TextEditingController(); // Company

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _industryController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      final extraData = <String, dynamic>{
        'full_name': _nameController.text.trim(),
        'industry': _industryController.text.trim(),
      };

      ref.read(authControllerProvider.notifier).signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            isCompany: true, // Always company
            additionalData: extraData,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      } else if (next is AsyncData && !next.isLoading) {
        // Maybe show a dialog "Check your email" if email confirmation is on
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Registration successful! Please login.')),
        );
        context.pop(); // Go back to login
      }
    });

    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Organization'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Profile',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Join InternLink to discover top student talent',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 16),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                label: 'Legal Company Name',
                controller: _nameController,
                prefixIcon: const Icon(Icons.business_rounded),
                validator: (v) => v?.isNotEmpty == true ? null : 'Required',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Core Industry',
                controller: _industryController,
                prefixIcon: const Icon(Icons.category_outlined),
                validator: (v) => v?.isNotEmpty == true ? null : 'Required',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Official Email',
                controller: _emailController,
                prefixIcon: const Icon(Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value != null && value.contains('@')
                    ? null
                    : 'Please enter a valid email',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Account Password',
                controller: _passwordController,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                obscureText: true,
                validator: (value) => value != null && value.length >= 6
                    ? null
                    : 'Minimum 6 characters',
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                text: 'Register Organization',
                onPressed: _register,
                isLoading: isLoading,
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () => context.pop(),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 14),
                      children: [
                        const TextSpan(text: 'Already registered? '),
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
