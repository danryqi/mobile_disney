import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';

const Color softLavender = Color(0xFFE0BBE4);
const Color palePink = Color(0xFFFFD1DC);
const Color softBlue = Color.fromARGB(255, 113, 196, 255);
const Color deepContrast = Color(0xFF4A4E69);
const Color accentButton = Color(0xFF957DAD);
const Color whiteContrast = Color(0xFFF0F0F0);
const Color softBorder = Color(0xFFC7B1E3);

// ------------------------------------------------------------------
// CUSTOM UI COMPONENTS
// ------------------------------------------------------------------

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final VoidCallback? onChanged;

  const _CustomTextField({
    required this.controller,
    required this.labelText,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const double inputHeight = 56.0;

    return Container(
      height: inputHeight,
      decoration: BoxDecoration(
        color: whiteContrast.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: softBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentButton.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textAlignVertical: TextAlignVertical.center,
        onChanged: (_) => onChanged?.call(),
        style: const TextStyle(
          color: deepContrast,
          fontWeight: FontWeight.w600,
          fontSize: 16,
          height: 1.0,
        ),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10),
            child: Icon(icon, color: accentButton, size: 22),
          ),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(
            color: deepContrast.withOpacity(0.6),
            fontSize: 15,
          ),
          contentPadding:
              const EdgeInsets.only(top: 0, bottom: 8, left: 0, right: 8),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}

// Tombol Aksi
class _CustomActionButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _CustomActionButton({
    required this.text,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const Color buttonStart = accentButton;
    const Color buttonEnd = softBorder;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: onPressed != null
            ? const LinearGradient(
                colors: [buttonStart, buttonEnd],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: onPressed == null ? Colors.grey.shade300 : null,
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: accentButton.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: whiteContrast, strokeWidth: 2),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      color: whiteContrast,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// REGISTER VIEW
// ------------------------------------------------------------------

class RegisterView extends StatefulWidget {
  final AuthController controller;
  const RegisterView({super.key, required this.controller});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  bool _isLoading = false;

  bool get _isFormFilled =>
      usernameCtrl.text.isNotEmpty &&
      emailCtrl.text.isNotEmpty &&
      passwordCtrl.text.isNotEmpty &&
      confirmCtrl.text.isNotEmpty;

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  Future<void> _register() async {
    if (passwordCtrl.text != confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak sama')),
      );
      return;
    }

    if (!_isValidEmail(emailCtrl.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format email tidak valid')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final success = await widget.controller.register(
      usernameCtrl.text.trim(),
      emailCtrl.text.trim(),
      passwordCtrl.text,
    );
    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username atau email sudah digunakan.')),
      );
    }
  }

  @override
  void dispose() {
    usernameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [softLavender, softBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'BUAT AKUN BARU',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: deepContrast,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enchanted Sign Up',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: deepContrast,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // ✅ Tambahkan listener ke setiap field
                    _CustomTextField(
                      controller: usernameCtrl,
                      labelText: 'Username',
                      icon: Icons.person_outline,
                      onChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    _CustomTextField(
                      controller: emailCtrl,
                      labelText: 'Email Address',
                      icon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    _CustomTextField(
                      controller: passwordCtrl,
                      labelText: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      onChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    _CustomTextField(
                      controller: confirmCtrl,
                      labelText: 'Konfirmasi Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      onChanged: () => setState(() {}),
                    ),

                    const SizedBox(height: 30),
                    _CustomActionButton(
                      text: 'DAFTAR',
                      isLoading: _isLoading,
                      onPressed: _isFormFilled && !_isLoading ? _register : null,
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sudah punya akun?",
                          style: TextStyle(color: deepContrast),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, '/login'),
                          child: const Text(
                            'Masuk',
                            style: TextStyle(
                              color: accentButton,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
