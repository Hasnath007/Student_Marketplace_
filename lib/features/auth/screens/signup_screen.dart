import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _batchController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedDept;

  bool _agreeTerms = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final List<String> _departments = [
    'Computer Science',
    'Electrical Eng',
    'Business Admin',
    'Architecture',
    'Mathematics',
  ];

  // Form text colors
  static const Color _textColor = Color(0xFF0F172A);
  static const Color _labelColor = Color(0xFF1E293B);
  static const Color _hintColor = Color(0xFF94A3B8);
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _inputBackground = Color(0xFFF8FAFC);
  static const Color _primaryColor = Color(0xFF0052CC);

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _batchController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms of Service')),
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      final User? user = userCredential.user;

      if (user == null) {
        throw Exception('User account could not be created.');
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': _nameController.text.trim(),
        'studentId': _studentIdController.text.trim(),
        'email': _emailController.text.trim(),
        'department': _selectedDept,
        'batch': _batchController.text.trim(),
        'role': 'student',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );

      context.go('/marketplace');
    } on FirebaseAuthException catch (e) {
      String message = 'Something went wrong. Please try again.';

      if (e.code == 'email-already-in-use') {
        message = 'This email is already registered.';
      } else if (e.code == 'invalid-email') {
        message = 'Please enter a valid email address.';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak.';
      } else if (e.code == 'operation-not-allowed') {
        message = 'Email/password sign up is not enabled.';
      } else if (e.code == 'network-request-failed') {
        message = 'Network error. Please check your internet connection.';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account could not be created. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCEBFF).withValues(alpha: 0.5),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => context.go('/login'),
            child: const Text(
              'Already have an account? Login',
              style: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 36.0,
                  vertical: 36.0,
                ),

                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // TITLE
                      const Text(
                        'Join Student Market',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: _textColor,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'Sign up with your university credentials.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // GOOGLE BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: OutlinedButton.icon(
                          onPressed: () => context.go('/marketplace'),
                          icon: const Icon(
                            Icons.g_mobiledata_rounded,
                            size: 28,
                            color: _textColor,
                          ),
                          label: const Text(
                            'Continue with Google',
                            style: TextStyle(
                              color: _textColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFEFF6FF),
                            side: const BorderSide(color: Color(0xFFDBEFEF)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // DIVIDER
                      Row(
                        children: [
                          const Expanded(child: Divider(color: _borderColor)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'OR REGISTER WITH EMAIL',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider(color: _borderColor)),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // NAME + STUDENT ID
                      Row(
                        children: [
                          // FULL NAME
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Full Name'),
                                const SizedBox(height: 4),

                                TextFormField(
                                  controller: _nameController,

                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: _textColor,
                                  ),

                                  cursorColor: _primaryColor,

                                  decoration: _inputDeco('Jane Doe'),

                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          // STUDENT ID
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Student ID'),
                                const SizedBox(height: 4),

                                TextFormField(
                                  controller: _studentIdController,

                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: _textColor,
                                  ),

                                  cursorColor: _primaryColor,

                                  decoration: _inputDeco('12345678'),

                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // EMAIL LABEL
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _label('University Email'),
                      ),

                      const SizedBox(height: 4),

                      // EMAIL
                      TextFormField(
                        controller: _emailController,

                        keyboardType: TextInputType.emailAddress,

                        style: const TextStyle(fontSize: 13, color: _textColor),

                        cursorColor: _primaryColor,

                        decoration: _inputDeco('jane.doe@university.edu'),

                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return 'Valid email required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      // DEPARTMENT + BATCH
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // DEPARTMENT
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Department'),

                                const SizedBox(height: 4),

                                DropdownButtonFormField<String>(
                                  initialValue: _selectedDept,

                                  hint: const Text(
                                    'Select Dept',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: _hintColor,
                                    ),
                                  ),

                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: _textColor,
                                  ),

                                  decoration: _inputDeco(''),

                                  dropdownColor: Colors.white,

                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: _textColor,
                                    size: 20,
                                  ),

                                  items: _departments.map((department) {
                                    return DropdownMenuItem<String>(
                                      value: department,

                                      child: Text(
                                        department,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: _textColor,
                                        ),
                                      ),
                                    );
                                  }).toList(),

                                  onChanged: (value) {
                                    setState(() {
                                      _selectedDept = value;
                                    });
                                  },

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Select department';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          // BATCH
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Graduation Batch'),

                                const SizedBox(height: 4),

                                TextFormField(
                                  controller: _batchController,

                                  keyboardType: TextInputType.number,

                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: _textColor,
                                  ),

                                  cursorColor: _primaryColor,

                                  decoration: _inputDeco('2026'),

                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // PASSWORD LABEL
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _label('Password'),
                      ),

                      const SizedBox(height: 4),

                      // PASSWORD
                      TextFormField(
                        controller: _passwordController,

                        obscureText: _obscurePassword,

                        style: const TextStyle(fontSize: 13, color: _textColor),

                        cursorColor: _primaryColor,

                        decoration: _inputDeco(
                          '••••••••',

                          suffix: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,

                              size: 16,

                              color: _textColor,
                            ),

                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),

                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Min 6 chars';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      // CONFIRM PASSWORD LABEL
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _label('Confirm Password'),
                      ),

                      const SizedBox(height: 4),

                      // CONFIRM PASSWORD
                      TextFormField(
                        controller: _confirmPasswordController,

                        obscureText: _obscureConfirmPassword,

                        style: const TextStyle(fontSize: 13, color: _textColor),

                        cursorColor: _primaryColor,

                        decoration: _inputDeco(
                          '••••••••',

                          suffix: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,

                              size: 16,

                              color: _textColor,
                            ),

                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm password';
                          }

                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      // TERMS
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: _agreeTerms,

                              onChanged: (value) {
                                setState(() {
                                  _agreeTerms = value ?? false;
                                });
                              },
                            ),
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                                children: [
                                  const TextSpan(text: 'I agree to the '),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(text: '.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // CREATE ACCOUNT BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 44,

                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSignUp,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,

                            foregroundColor: Colors.white,

                            disabledBackgroundColor: const Color(0xFF94A3B8),

                            disabledForegroundColor: Colors.white,

                            elevation: 0,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,

                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // LABEL
  Widget _label(String title) {
    return Text(
      title,

      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: _labelColor,
      ),
    );
  }

  // INPUT DECORATION
  InputDecoration _inputDeco(String hint, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,

      hintStyle: const TextStyle(color: _hintColor, fontSize: 13),

      suffixIcon: suffix,

      filled: true,

      fillColor: _inputBackground,

      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),

        borderSide: const BorderSide(color: _borderColor),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),

        borderSide: const BorderSide(color: _borderColor),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),

        borderSide: const BorderSide(color: _primaryColor, width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),

        borderSide: const BorderSide(color: Colors.red),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),

        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
