import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _yearController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _passwordError;
  String? _emailError;
  String? _nimError;
  String? _phoneError;

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _yearController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _passwordError = 'Password tidak cocok';
      });
    } else {
      setState(() {
        _passwordError = null;
      });
    }
  }

  void _validateEmail() {
    final email = _emailController.text.trim();
    if (!email.endsWith('@student.telkomuniversity.ac.id')) {
      setState(() {
        _emailError = 'Gunakan @student.telkomuniversity.ac.id';
      });
    } else {
      setState(() {
        _emailError = null;
      });
    }
  }

  void _validateNIM() {
    final nim = _nimController.text.trim();
    if (!RegExp(r'^\d+$').hasMatch(nim)) {
      setState(() {
        _nimError = 'NIM harus berupa angka';
      });
    } else {
      setState(() {
        _nimError = null;
      });
    }
  }

  void _validatePhone() {
    final phone = _phoneController.text.trim();
    if (!RegExp(r'^\d+$').hasMatch(phone)) {
      setState(() {
        _phoneError = 'Nomor telepon harus berupa angka';
      });
    } else {
      setState(() {
        _phoneError = null;
      });
    }
  }

  Future<void> _selectYear() async {
    final DateTime? picked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pilih Tahun Masuk"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(2010),
              lastDate: DateTime.now(),
              initialDate: DateTime.now(),
              selectedDate: _yearController.text.isNotEmpty
                  ? DateTime(int.parse(_yearController.text))
                  : DateTime.now(),
              onChanged: (DateTime dateTime) {
                Navigator.pop(context, dateTime);
              },
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _yearController.text = picked.year.toString();
      });
    }
  }

  Future<void> _handleSignup() async {
    // Validate all fields
    _validatePassword();
    _validateEmail();
    _validateNIM();
    _validatePhone();

    // Check if there are any errors
    if (_passwordError != null ||
        _emailError != null ||
        _nimError != null ||
        _phoneError != null ||
        _nameController.text.trim().isEmpty ||
        _yearController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon periksa kembali semua field'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final name = _nameController.text.trim();
    final nim = _nimController.text.trim();
    final year = _yearController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final url =
        Uri.parse('https://bookwise.azurewebsites.net/api/users/register/student');

    final body = jsonEncode({
      "name": name,
      "nim": nim,
      "year": year,
      "phone": phone,
      "email": email,
      "password": password,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 201) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Berhasil'),
              content: const Text('Akun berhasil dibuat!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal mendaftar: ${response.body}'),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
        ),
      );
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _navigateToLogin,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo/Illustration
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.book,
                      size: 60,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Header Text
                  const Text(
                    'Buat akun baru',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Masukkan informasi Anda di bawah ini untuk membuat akun',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Form Card
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name Field
                          _buildTextField(
                            'Nama Lengkap',
                            'Masukkan nama lengkap',
                            _nameController,
                            prefixIcon: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),

                          // NIM Field
                          _buildTextField(
                            'NIM',
                            'Masukkan NIM',
                            _nimController,
                            prefixIcon: Icons.badge_outlined,
                            keyboardType: TextInputType.number,
                            errorText: _nimError,
                            onChanged: (_) => _validateNIM(),
                          ),
                          const SizedBox(height: 16),

                          // Year Field
                          _buildTextField(
                            'Tahun Masuk',
                            'Pilih tahun masuk',
                            _yearController,
                            prefixIcon: Icons.calendar_today_outlined,
                            readOnly: true,
                            onTap: _selectYear,
                          ),
                          const SizedBox(height: 16),

                          // Phone Number Field
                          _buildTextField(
                            'Nomor Telepon',
                            'Masukkan nomor telepon',
                            _phoneController,
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            errorText: _phoneError,
                            onChanged: (_) => _validatePhone(),
                          ),
                          const SizedBox(height: 16),

                          // Email Field
                          _buildTextField(
                            'Email',
                            'contoh@student.telkomuniversity.ac.id',
                            _emailController,
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            errorText: _emailError,
                            onChanged: (_) => _validateEmail(),
                          ),
                          const SizedBox(height: 16),

                          // Password Field
                          _buildTextField(
                            'Password',
                            '••••••••',
                            _passwordController,
                            prefixIcon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            onChanged: (_) => _validatePassword(),
                          ),
                          const SizedBox(height: 16),

                          // Confirm Password Field
                          _buildTextField(
                            'Konfirmasi Password',
                            '••••••••',
                            _confirmPasswordController,
                            prefixIcon: Icons.lock_outline,
                            obscureText: _obscureConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                            errorText: _passwordError,
                            onChanged: (_) => _validatePassword(),
                          ),
                          const SizedBox(height: 24),

                          // Signup Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleSignup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Daftar',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Login Link
                          Center(
                            child: TextButton(
                              onPressed: _navigateToLogin,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                              ),
                              child: const Text(
                                'Sudah punya akun? Masuk',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    IconData? prefixIcon,
    Widget? suffixIcon,
    String? errorText,
    bool readOnly = false,
    VoidCallback? onTap,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey) : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            errorText: errorText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
