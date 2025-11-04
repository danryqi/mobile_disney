import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../services/hive_service.dart';

// 🎨 Warna konsisten dengan tema utama
const Color softLavender = Color(0xFFE0BBE4);
const Color palePink = Color(0xFFFFD1DC);
const Color softBlue = Color.fromARGB(255, 113, 196, 255);
const Color deepContrast = Color(0xFF4A4E69);
const Color accentButton = Color(0xFF957DAD);
const Color whiteContrast = Color(0xFFFDFDFD);

class ProfileView extends StatelessWidget {
  final AuthController authController;
  final HiveService hiveService;

  const ProfileView({
    super.key,
    required this.authController,
    required this.hiveService,
  });

  void _logout(BuildContext context) async {
    await authController.logout();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteContrast,
      body: Stack(
        children: [
          // 🌈 Background gradient lembut
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [softLavender, palePink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 🌸 Ornamen lingkaran lembut
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.25),
              ),
            ),
          ),

          // 🌟 Konten utama
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Foto Profil dengan shadow dan border gradient
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [accentButton, softBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: deepContrast.withOpacity(0.15),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const CircleAvatar(
                      radius: 70,
                      backgroundImage:
                          AssetImage('assets/images/nina.jpg'),
                      backgroundColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Nama dan NIM
                  const Text(
                    "Rania Ramadina Abu Bakar",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: deepContrast,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "124230050",
                    style: TextStyle(
                      fontSize: 16,
                      color: deepContrast.withOpacity(0.7),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Card Profil Info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: deepContrast.withOpacity(0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Pesan & Kesan",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: deepContrast,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "✨ Pesan:\n"
                          "Terima kasih kepada dosen dan teman-teman yang sudah banyak membantu "
                          "dalam memahami konsep dan praktik pemrograman aplikasi mobile.\n\n"
                          "💡 Kesan:\n"
                          "Mata kuliah ini sangat menarik karena memberikan pengalaman nyata dalam "
                          "membangun aplikasi berbasis Flutter. Walaupun sempat mengalami kesulitan, "
                          "tapi hasil akhirnya sangat memuaskan!",
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: deepContrast,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Tombol Logout yang elegan
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [accentButton, softBlue],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accentButton.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => _logout(context),
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
