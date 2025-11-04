import 'package:disney_nina/views/map.dart';
import 'package:disney_nina/views/profile.dart';
import 'package:flutter/material.dart';
import 'package:disney_nina/views/coin_store.dart';
import 'package:disney_nina/views/collection.dart';
import '../controllers/character_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/character_model.dart';
import '../services/hive_service.dart';
import '../utils/conversion_util.dart';

// --- Re-using Colors from login.dart for consistency ---
const Color softLavender = Color(0xFFE0BBE4); // Lavender Lembut
const Color palePink = Color(0xFFFFD1DC); // Pink Pucat
const Color softBlue = Color.fromARGB(255, 113, 196, 255); // Biru Muda Cerah
const Color deepContrast = Color(0xFF4A4E69); // Kontras Abu-abu Ungu Gelap (untuk teks)
const Color accentButton = Color(0xFF957DAD); // Warna tombol ungu yang lembut
const Color whiteContrast = Color(0xFFF0F0F0); // Hampir Putih (untuk background input/card)
const Color softBorder = Color(0xFFC7B1E3); // Border ungu muda
const Color paleBackground = Color(0xFFFFF0F5); // Tambahan: warna background sangat pucat
// -----------------------------------------------------

class HomeView extends StatefulWidget {
  final AuthController authController;
  final CharacterController characterController;
  final HiveService hiveService;

  const HomeView({
    super.key,
    required this.authController,
    required this.characterController,
    required this.hiveService,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Character> _characters = [];
  List<Character> _filtered = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _priceFilter = 'Semua';
  int _selectedIndex = 0;
  String username = "User";
  int _userCoins = 0;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadCharacters();
  }

  void _loadUser() {
    final name = widget.hiveService.getSession();
    if (name != null) {
      final user = widget.hiveService.getUser(name);
      if (user != null) {
        setState(() {
          username = user.username;
          _userCoins = user.coins;
        });
      }
    }
  }

  Future<void> _loadCharacters() async {
    final data = await widget.characterController.getCharacters();
    setState(() {
      _characters = data;
      _filtered = data;
      _isLoading = false;
      _filterCharacters(); // Apply current filters after loading
    });
  }

  void _filterCharacters() {
    setState(() {
      _filtered = _characters.where((c) {
        final matchName =
            c.name.toLowerCase().contains(_searchQuery.toLowerCase());
        bool matchPrice = true;

        switch (_priceFilter) {
          case '< 20 Coins':
            matchPrice = c.priceInCoins < 20;
            break;
          case '20–40 Coins':
            matchPrice = c.priceInCoins >= 20 && c.priceInCoins <= 40;
            break;
          case '> 40 Coins':
            matchPrice = c.priceInCoins > 40;
            break;
        }

        return matchName && matchPrice;
      }).toList();
    });
  }
  
  // ----------------------------------------------------------------
  // 🎨 CUSTOM WIDGETS FOR SOFT 3D THEME (Updated for image similarity)
  // ----------------------------------------------------------------

  Widget _buildCharacterCard(Character c) {
    // Card style with soft elevation/shadow, similar to the image's product cards
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/character_detail',
        arguments: c,
      ).then((_) => _loadUser()), // reload coin saat balik
      child: Container(
        decoration: BoxDecoration(
          color: whiteContrast,
          borderRadius: BorderRadius.circular(20), // More rounded corners
          boxShadow: [
            BoxShadow(
              color: deepContrast.withOpacity(0.08), // Softer shadow
              blurRadius: 18,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
            // Inner shadow for lifted look (optional but enhances soft 3D)
            BoxShadow(
              color: whiteContrast.withOpacity(0.5),
              blurRadius: 2,
              spreadRadius: 0.5,
              offset: const Offset(-2, -2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  c.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(Icons.broken_image,
                        size: 40, color: accentButton.withOpacity(0.6)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Left alignment like image
                children: [
                  Text(
                    c.name,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w700, // Slightly less heavy than 900
                        fontSize: 15,
                        color: deepContrast),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Mengganti Icon koin dengan ikon yang lebih menyerupai bintang/rating jika diperlukan, tapi menjaga konteks koin
                      Icon(Icons.monetization_on, size: 16, color: accentButton), 
                      const SizedBox(width: 4),
                      Text(
                        formatCoins(c.priceInCoins.toInt()),
                        style: TextStyle(
                            color: deepContrast.withOpacity(0.8), // Warna teks harga agak lembut
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomePage() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
          decoration: const BoxDecoration(
            color: paleBackground,
            boxShadow: [
              BoxShadow(
                color: Color(0x30957DAD),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔝 HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Enchanted",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: deepContrast,
                    ),
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: accentButton.withOpacity(0.2),
                    child: Icon(Icons.person, color: accentButton, size: 24),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 🔹 GANTI FILTER PILLS JADI BERDASARKAN COINS
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildFilterPill('Semua'),
                    _buildFilterPill('< 20 Coins'),
                    _buildFilterPill('20–40 Coins'),
                    _buildFilterPill('> 40 Coins'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Container(
                height: 120, // sedikit dinaikkan biar teks tidak terlalu padat
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accentButton.withOpacity(0.8), softBorder],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: deepContrast.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 🔹 Judul saldo
                      Text(
                        "SALDO COIN ANDA",
                        style: TextStyle(
                          color: whiteContrast,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 🔹 Jumlah coin (dipindah ke bawah)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.monetization_on, color: Colors.amberAccent, size: 28),
                          const SizedBox(width: 6),
                          Text(
                            formatCoins(_userCoins),
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                              color: whiteContrast,
                              shadows: [
                                Shadow(
                                  color: deepContrast.withOpacity(0.4),
                                  blurRadius: 4,
                                  offset: const Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),


              const SizedBox(height: 16),

              // 🔍 SEARCH BAR
              _buildSearchField(),
            ],
          ),
        ),

        // 🧱 GRID VIEW
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator(color: accentButton))
              : RefreshIndicator(
                  onRefresh: () async {
                    _loadUser();
                    await _loadCharacters();
                  },
                  color: accentButton,
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final c = _filtered[index];
                      return _buildCharacterCard(c);
                    },
                  ),
                ),
        ),
      ],
    );
  }


  // New: Filter Pill Widget (for aesthetic, non-functional)
  Widget _buildFilterPill(String label) {
    bool isSelected = _priceFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _priceFilter = label;
            _filterCharacters();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? accentButton : whiteContrast.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? accentButton : softBorder,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: deepContrast.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? whiteContrast : deepContrast,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }


  // Soft styled search field (Retained functionality)
  Widget _buildSearchField() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: whiteContrast.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16), // More rounded
        border: Border.all(color: softBorder, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: deepContrast.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari karakter...',
          hintStyle: TextStyle(
            color: deepContrast.withOpacity(0.6),
            height: 1.3, // sedikit menambah jarak vertikal font
          ),
          prefixIcon: Icon(Icons.search, color: accentButton.withOpacity(0.8)),
          border: InputBorder.none,
          // ✅ naikin nilai top padding agar hint turun sedikit
          contentPadding: const EdgeInsets.only(top: 14, bottom: 8, left: 10, right: 10),
          isDense: true,
        ),
        style: TextStyle(color: deepContrast, fontSize: 14),
        onChanged: (val) {
          _searchQuery = val;
          _filterCharacters();
        },
      ),
    );
  }

  // Soft styled filter dropdown (Retained functionality)
  Widget _buildFilterDropdown() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: whiteContrast.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16), // More rounded
        border: Border.all(color: softBorder, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: deepContrast.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: _priceFilter,
          isDense: true,
          style: TextStyle(color: deepContrast, fontSize: 14),
          icon: Icon(Icons.filter_list, color: accentButton.withOpacity(0.8)),
          items: const [
            DropdownMenuItem(value: 'Semua', child: Text('Semua')),
            DropdownMenuItem(value: '< 20 Coins', child: Text('< 20 Coins')),
            DropdownMenuItem(value: '20–40 Coins', child: Text('20–40 Coins')),
            DropdownMenuItem(value: '> 40 Coins', child: Text('> 40 Coins')),
          ],
          onChanged: (val) {
            setState(() {
              _priceFilter = val!;
              _filterCharacters();
            });
          },
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            isDense: true,
          ),
        ),
      ),
    );
  }

  Widget _getCurrentPage() {
    switch (_selectedIndex) {
      case 1:
        return CollectionView(hiveService: widget.hiveService);
      case 2:
        // 🚀 CoinStoreView dengan callback update otomatis
        return CoinStoreView(
          hiveService: widget.hiveService,
          onCoinsUpdated: _loadUser, // <-- panggil ulang saat saldo berubah
        );
      case 3:
        return const MapView();
      case 4:
        return ProfileView(
          authController: widget.authController,
          hiveService: widget.hiveService,
        );
      default:
        return _buildHomePage();
    }
  }


  @override
  Widget build(BuildContext context) {
    // Set background color for a pale, soft look
    return Scaffold(
      backgroundColor: paleBackground, 
      body: _getCurrentPage(),
      // Bottom Navigation Bar is unchanged as requested
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: whiteContrast,
          boxShadow: [
            BoxShadow(
              color: deepContrast.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          backgroundColor: Colors.transparent, // Make it transparent to show Container color
          elevation: 0,
          selectedItemColor: accentButton,
          unselectedItemColor: deepContrast.withOpacity(0.5),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          type: BottomNavigationBarType.fixed, // Ensure items stay in place
          onTap: (index) {
            setState(() => _selectedIndex = index);
            if (index == 0) _loadUser(); 
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
            BottomNavigationBarItem(
                icon: Icon(Icons.collections), label: 'Koleksi'),
            BottomNavigationBarItem(
                icon: Icon(Icons.monetization_on), label: 'Coins'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Peta'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
