import 'package:disney_nina/services/api_service.dart';
import 'package:flutter/material.dart';
import '../models/character_model.dart';
import '../models/user_model.dart';
import '../controllers/character_controller.dart';
import '../controllers/coin_controller.dart';
import '../services/hive_service.dart';
import '../utils/conversion_util.dart';

// 🎨 Warna konsisten
const Color softLavender = Color(0xFFE0BBE4);
const Color palePink = Color(0xFFFFD1DC);
const Color softBlue = Color.fromARGB(255, 113, 196, 255);
const Color deepContrast = Color(0xFF4A4E69);
const Color accentButton = Color(0xFF957DAD);
const Color whiteContrast = Color(0xFFFDFDFD);

class CharacterDetailView extends StatefulWidget {
  final Character character;
  final HiveService hiveService;
  const CharacterDetailView({
    super.key,
    required this.character,
    required this.hiveService,
  });

  @override
  State<CharacterDetailView> createState() => _CharacterDetailViewState();
}

class _CharacterDetailViewState extends State<CharacterDetailView>
    with SingleTickerProviderStateMixin {
  late User user;
  late CharacterController characterController;
  late CoinController coinController;

  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    characterController = CharacterController(ApiService(), widget.hiveService);
    coinController = CoinController(widget.hiveService);
    final username = widget.hiveService.getSession();
    user = widget.hiveService.getUser(username!)!;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _buyCharacter() async {
    if (coinController.spendCoins(user, widget.character.priceInCoins.toInt())) {
      await characterController.buyCharacter(user, widget.character);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Karakter berhasil dibeli! 🎉')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coins kamu tidak cukup 😅')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.character;

    return Scaffold(
      backgroundColor: whiteContrast,
      appBar: AppBar(
        backgroundColor: accentButton,
        elevation: 0,
        title: Text(
          c.name,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 🌸 Background gradient lembut
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [softLavender, palePink],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          FadeTransition(
            opacity: _fadeIn,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🖼️ Gambar karakter dalam card melayang
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: deepContrast.withOpacity(0.2),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        c.imageUrl,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 250,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image, size: 100),
                        ),
                      ),
                    ),
                  ),

                  // 🌟 Nama & Harga dalam card semi-transparan
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: deepContrast.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          c.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: deepContrast,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.monetization_on,
                                color: accentButton, size: 26),
                            const SizedBox(width: 6),
                            Text(
                              formatCoins(c.priceInCoins.toInt()),
                              style: const TextStyle(
                                fontSize: 20,
                                color: accentButton,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 📝 Deskripsi karakter (kartu dengan gradient halus)
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [whiteContrast.withOpacity(0.8), softBlue.withOpacity(0.2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: deepContrast.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                          "Karakter Disney yang menawan dengan kepribadian khas dan daya tarik yang membuat semua orang terpesona. 🌟",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: deepContrast.withOpacity(0.8),
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // 🛒 Tombol Beli
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [accentButton, softBlue],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accentButton.withOpacity(0.4),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _buyCharacter,
                      icon: const Icon(Icons.shopping_cart_outlined,
                          color: Colors.white),
                      label: const Text(
                        'Beli Karakter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
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
