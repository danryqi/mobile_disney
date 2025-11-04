import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';

// ------------------------------------------------------------------
// 🎨 PALET WARNA BARU (Soft Theme)
// ------------------------------------------------------------------
const Color softLavender = Color(0xFFE0BBE4);     // Lavender Lembut
const Color palePink = Color(0xFFFFD1DC);         // Pink Pucat
const Color softBlue = Color.fromARGB(255, 113, 196, 255); // Biru Muda Cerah
const Color deepContrast = Color(0xFF4A4E69);     // Kontras Abu-abu Ungu Gelap (untuk teks)
const Color accentButton = Color(0xFF957DAD);     // Warna tombol ungu yang lembut
const Color whiteContrast = Color(0xFFF0F0F0);     // Hampir Putih (untuk background input)
const Color softBorder = Color(0xFFC7B1E3);        // Border ungu muda

// ------------------------------------------------------------------
// 🌈 CUSTOM UI COMPONENTS
// ------------------------------------------------------------------

// Helper widget for the soft input style
class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;

  const _CustomTextField({
    required this.controller,
    required this.labelText,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    const double inputHeight = 56.0;

    return Container(
      height: inputHeight,
      decoration: BoxDecoration(
        color: whiteContrast.withOpacity(0.9), // Latar belakang input lebih terang
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: softBorder, width: 1.5), // Border ungu muda
        boxShadow: [
          BoxShadow(
            color: accentButton.withOpacity(0.1), // Shadow ungu soft
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
        style: const TextStyle(
          color: deepContrast, // Teks input gelap
          fontWeight: FontWeight.w600,
          fontSize: 16,
          height: 1.0,
        ),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10),
            child: Icon(icon, color: accentButton, size: 22), // Ikon warna accent
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

// Custom button dengan gradient dan glow yang disesuaikan
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
    // Kombinasi warna soft untuk tombol
    const Color buttonStart = accentButton;       // Ungu Lembut
    const Color buttonEnd = softBorder;           // Ungu Muda

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
        color: onPressed == null ? Colors.grey.shade300 : null, // Warna non-aktif lebih terang
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
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: whiteContrast, strokeWidth: 2),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      color: whiteContrast, // Teks Putih Cerah
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
// 🧩 LOGIN VIEW
// ------------------------------------------------------------------

class LoginView extends StatefulWidget {
  final AuthController controller;
  const LoginView({super.key, required this.controller});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool _isLoading = false;
  // State _rememberMe tidak digunakan dalam implementasi ini, 
  // tetapi dipertahankan untuk kompatibilitas Hive Service jika diaktifkan.
  // bool _rememberMe = false; 

  Future<void> _login() async {
    if (usernameCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username dan password tidak boleh kosong')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final success =
        await widget.controller.login(usernameCtrl.text.trim(), passwordCtrl.text);
    setState(() => _isLoading = false);

    if (success) {
      // Logic Hive Service dihilangkan sementara karena tidak ada Hive yang terimplementasi penuh.
      // Jika Anda menggunakan Hive untuk menyimpan sesi, aktifkan kembali bagian ini.
      /*
      if (_rememberMe) {
        await widget.controller.hiveService.saveSession(usernameCtrl.text.trim());
      }
      */

      if (mounted) {
        // Ganti rute ke /home setelah login berhasil
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username atau password salah')),
      );
    }
  }

  @override
  void dispose() {
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌌 Gradient Background (Soft Lavender to Soft Blue)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [softLavender, softBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 💫 Abstract Glow Shapes (Soft Pink and Soft Violet)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: palePink.withOpacity(0.5),
                borderRadius: BorderRadius.circular(150),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: -80,
            child: Transform.rotate(
              angle: -0.4,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: softBorder.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),

          // 🧍‍♂️ Main Login Form
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20), 

                    Text(
                      'SELAMAT DATANG KEMBALI!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: deepContrast.withOpacity(0.8), // Teks gelap lembut
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '3D World Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: deepContrast, // Teks gelap
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Masuk ke akun Anda',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: deepContrast.withOpacity(0.7),
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 30),

                    _CustomTextField(
                      controller: usernameCtrl,
                      labelText: 'Username',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 14),

                    _CustomTextField(
                      controller: passwordCtrl,
                      labelText: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),

                    const SizedBox(height: 32),

                    _CustomActionButton(
                      text: 'MASUK',
                      isLoading: _isLoading,
                      // Tombol selalu aktif, validasi dilakukan di _login()
                      onPressed: _login,
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Belum punya akun?",
                            style: TextStyle(color: deepContrast.withOpacity(0.7))),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/register'),
                          child: const Text(
                            'Daftar',
                            style: TextStyle(
                                color: accentButton, fontWeight: FontWeight.bold), // Warna accent lembut
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