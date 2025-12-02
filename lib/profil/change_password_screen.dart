import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  // Password visibility
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  // Password strength
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.grey;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength(String password) {
    setState(() {
      double strength = 0;
      
      if (password.isEmpty) {
        _passwordStrength = 0;
        _passwordStrengthText = '';
        _passwordStrengthColor = Colors.grey;
        return;
      }

      // Length check
      if (password.length >= 8) strength += 0.2;
      if (password.length >= 12) strength += 0.1;
      
      // Contains lowercase
      if (password.contains(RegExp(r'[a-z]'))) strength += 0.2;
      
      // Contains uppercase
      if (password.contains(RegExp(r'[A-Z]'))) strength += 0.2;
      
      // Contains number
      if (password.contains(RegExp(r'[0-9]'))) strength += 0.2;
      
      // Contains special character
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.1;

      _passwordStrength = strength;

      if (strength < 0.3) {
        _passwordStrengthText = 'Lemah';
        _passwordStrengthColor = Color(0xFFF44336);
      } else if (strength < 0.6) {
        _passwordStrengthText = 'Sedang';
        _passwordStrengthColor = Color(0xFFFF9800);
      } else if (strength < 0.8) {
        _passwordStrengthText = 'Kuat';
        _passwordStrengthColor = Color(0xFF4CAF50);
      } else {
        _passwordStrengthText = 'Sangat Kuat';
        _passwordStrengthColor = Color(0xFF2196F3);
      }
    });
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF4CAF50).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Color(0xFF4CAF50),
                    size: 48,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Berhasil!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              'Password Anda berhasil diubah. Silakan login kembali dengan password baru.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Go back to profile
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('OK'),
                ),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              Color(0xFF2196F3),
              Color(0xFF1976D2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Ubah Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Icon Section
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_reset,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),

              // Form Section
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Info Card
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFF2196F3).withOpacity(0.3)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Color(0xFF2196F3),
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Password harus minimal 8 karakter dan mengandung huruf besar, huruf kecil, dan angka.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF1976D2),
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),

                          // Current Password
                          Text(
                            'Password Saat Ini',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          _buildPasswordField(
                            controller: _currentPasswordController,
                            label: 'Masukkan password saat ini',
                            isVisible: _isCurrentPasswordVisible,
                            onVisibilityToggle: () {
                              setState(() {
                                _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password saat ini tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24),

                          // New Password
                          Text(
                            'Password Baru',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          _buildPasswordField(
                            controller: _newPasswordController,
                            label: 'Masukkan password baru',
                            isVisible: _isNewPasswordVisible,
                            onVisibilityToggle: () {
                              setState(() {
                                _isNewPasswordVisible = !_isNewPasswordVisible;
                              });
                            },
                            onChanged: (value) {
                              _checkPasswordStrength(value);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password baru tidak boleh kosong';
                              }
                              if (value.length < 8) {
                                return 'Password minimal 8 karakter';
                              }
                              if (!value.contains(RegExp(r'[A-Z]'))) {
                                return 'Password harus mengandung huruf besar';
                              }
                              if (!value.contains(RegExp(r'[a-z]'))) {
                                return 'Password harus mengandung huruf kecil';
                              }
                              if (!value.contains(RegExp(r'[0-9]'))) {
                                return 'Password harus mengandung angka';
                              }
                              if (value == _currentPasswordController.text) {
                                return 'Password baru harus berbeda dari password lama';
                              }
                              return null;
                            },
                          ),

                          // Password Strength Indicator
                          if (_newPasswordController.text.isNotEmpty) ...[
                            SizedBox(height: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Kekuatan Password',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      _passwordStrengthText,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: _passwordStrengthColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: _passwordStrength,
                                    minHeight: 8,
                                    backgroundColor: Colors.grey[200],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      _passwordStrengthColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          SizedBox(height: 24),

                          // Confirm Password
                          Text(
                            'Konfirmasi Password Baru',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          _buildPasswordField(
                            controller: _confirmPasswordController,
                            label: 'Masukkan ulang password baru',
                            isVisible: _isConfirmPasswordVisible,
                            onVisibilityToggle: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Konfirmasi password tidak boleh kosong';
                              }
                              if (value != _newPasswordController.text) {
                                return 'Password tidak cocok';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 32),

                          // Requirements Checklist
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Syarat Password:',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 12),
                                _buildRequirement(
                                  'Minimal 8 karakter',
                                  _newPasswordController.text.length >= 8,
                                ),
                                _buildRequirement(
                                  'Mengandung huruf besar (A-Z)',
                                  _newPasswordController.text.contains(RegExp(r'[A-Z]')),
                                ),
                                _buildRequirement(
                                  'Mengandung huruf kecil (a-z)',
                                  _newPasswordController.text.contains(RegExp(r'[a-z]')),
                                ),
                                _buildRequirement(
                                  'Mengandung angka (0-9)',
                                  _newPasswordController.text.contains(RegExp(r'[0-9]')),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 32),

                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _changePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2196F3),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.lock_reset),
                                        SizedBox(width: 8),
                                        Text(
                                          'Ubah Password',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          SizedBox(height: 16),

                          // Cancel Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton(
                              onPressed: _isLoading ? null : () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Color(0xFF2196F3),
                                side: BorderSide(color: Color(0xFF2196F3)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Batal',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: !isVisible,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF2196F3), size: 20),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey[600],
              size: 20,
            ),
            onPressed: onVisibilityToggle,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.cancel,
            size: 18,
            color: isMet ? Color(0xFF4CAF50) : Colors.grey[400],
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isMet ? Colors.black87 : Colors.grey[600],
              fontWeight: isMet ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}