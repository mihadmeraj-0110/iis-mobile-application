import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/providers.dart';
import '../core/firebase_status.dart';
import '../core/theme.dart';
import 'widgets/common.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key, this.message});
  final String? message;
  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _register = false;
  bool _obscure = true;
  bool _resetBusy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _error = null);
    if (_register) {
      await ref
          .read(sessionProvider.notifier)
          .register(
            name: _name.text,
            email: _email.text,
            password: _password.text,
          );
    } else {
      await ref
          .read(sessionProvider.notifier)
          .signIn(email: _email.text, password: _password.text);
    }
    final state = ref.read(sessionProvider);
    if (state.hasError && mounted) {
      setState(() => _error = _authMessage(state.error));
    }
  }

  Future<void> _resetPassword() async {
    if (_email.text.trim().isEmpty || !_email.text.contains('@')) {
      setState(() => _error = 'Enter a valid email address first.');
      return;
    }
    if (!firebaseIsReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connect Firebase to send password reset emails.'),
        ),
      );
      return;
    }
    setState(() {
      _resetBusy = true;
      _error = null;
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _email.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent. Check your inbox.'),
          ),
        );
      }
    } on FirebaseAuthException catch (error) {
      if (mounted) setState(() => _error = _authMessage(error));
    } finally {
      if (mounted) setState(() => _resetBusy = false);
    }
  }

  String _authMessage(Object? error) {
    if (!firebaseIsReady) {
      return 'Demo session could not be saved. Please try again.';
    }
    if (error is FirebaseAuthException) {
      return switch (error.code) {
        'invalid-credential' ||
        'wrong-password' ||
        'user-not-found' => 'Email or password is incorrect.',
        'email-already-in-use' => 'An account with this email already exists.',
        'weak-password' => 'Choose a password with at least 6 characters.',
        'invalid-email' => 'Enter a valid email address.',
        'network-request-failed' =>
          'Connection problem. Check your internet and try again.',
        _ => error.message ?? 'Authentication failed. Please try again.',
      };
    }
    return 'Something went wrong. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final busy = session.isLoading;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(25, 22, 25, 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      height: 76,
                      width: 76,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFFAE79F1), AppColors.violet],
                        ),
                      ),
                      child: const Icon(
                        Icons.spa_rounded,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _register ? 'Create your account' : 'Welcome back',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 9),
                  Text(
                    _register
                        ? 'Begin building a practice that feels like yours.'
                        : 'Sign in and return to your sanctuary.',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                  ),
                  if (!firebaseIsReady) ...[
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6DF),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0xFFB67A0A),
                            size: 19,
                          ),
                          SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              'Preview mode · your session stays on this device.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF72551C),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (widget.message != null || _error != null) ...[
                    const SizedBox(height: 15),
                    Text(
                      _error ?? widget.message!,
                      style: const TextStyle(color: Color(0xFFB82E49)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 28),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (_register) ...[
                          TextFormField(
                            controller: _name,
                            validator: _required,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Your name',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                        TextFormField(
                          controller: _email,
                          validator: (value) {
                            if (_required(value) != null) {
                              return 'Enter your email';
                            }
                            if (!value!.contains('@')) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          decoration: const InputDecoration(
                            labelText: 'Email address',
                            prefixIcon: Icon(Icons.mail_outline),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _password,
                          validator: (value) {
                            if (_required(value) != null) {
                              return 'Enter your password';
                            }
                            if (_register && value!.length < 6) {
                              return 'Use at least 6 characters';
                            }
                            return null;
                          },
                          obscureText: _obscure,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          autofillHints: _register
                              ? const [AutofillHints.newPassword]
                              : const [AutofillHints.password],
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!_register)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _resetBusy ? null : _resetPassword,
                        child: Text(
                          _resetBusy ? 'Sending…' : 'Forgot password?',
                        ),
                      ),
                    ),
                  const SizedBox(height: 11),
                  PrimaryButton(
                    label: _register ? 'Create account' : 'Sign in',
                    busy: busy,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 17),
                  TextButton(
                    onPressed: busy
                        ? null
                        : () => setState(() {
                            _register = !_register;
                            _error = null;
                          }),
                    child: Text(
                      _register
                          ? 'Already have an account?  Sign in'
                          : 'New to the sanctuary?  Create an account',
                      style: const TextStyle(
                        color: AppColors.violet,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'By continuing, you agree to our Terms and Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
