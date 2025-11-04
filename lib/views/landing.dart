import 'package:flutter/material.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  // --- Palet Warna Soft dan Terang ---
  static const Color softLavender = Color(0xFFE0BBE4); // Lavender Lembut
  static const Color palePink = Color(0xFFFFD1DC);     // Pink Pucat
  static const Color softBlue = Color.fromARGB(255, 113, 196, 255);     // Biru Muda
  static const Color deepContrast = Color(0xFF4A4E69); // Kontras Abu-abu Ungu Gelap (untuk teks)
  static const Color accentButton = Color(0xFF957DAD); // Warna tombol ungu yang lembut

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌌 Background gradient (Lebih Cerah dan Lembut)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                // Transisi dari Lavender Lembut ke Biru Muda
                colors: [softLavender, softBlue], 
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ✨ Decorative shapes (Illusion 3D yang Lebih Soft)
          Positioned(
            top: 80,
            right: -40,
            child: Transform.rotate(
              angle: 0.5,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palePink.withOpacity(0.7), // Warna Pucat
                  boxShadow: [
                    BoxShadow(
                      color: palePink.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            right: 40,
            child: Transform.rotate(
              angle: -0.5,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: softBlue.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: softBlue.withOpacity(0.4),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 40,
            child: Transform.rotate(
              angle: 0.6,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: softLavender.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // 🌈 Main content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Jelajahi Dunia\nDisney yang Menarik!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: deepContrast, // Menggunakan warna kontras gelap
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Mulai petualangan Anda dan kumpulkan\nkarakter-karakter menawan.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: deepContrast,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 60),

                  // 🔹 Login button (Warna Soft Accent)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'), // Mengubah ke /login
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentButton, // Warna ungu lembut
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 5, // Tambah sedikit shadow untuk efek 3D
                      ),
                      child: const Text(
                        "MASUK",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🔹 Sign Up button (Soft Outline)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, '/register'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: accentButton.withOpacity(0.6), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        "DAFTAR",
                        style: TextStyle(
                          fontSize: 18,
                          color: deepContrast, // Teks Kontras Gelap
                          fontWeight: FontWeight.bold,
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
    );
  }
}
