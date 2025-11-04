import 'package:flutter/material.dart';
import '../services/hive_service.dart';
import '../utils/conversion_util.dart';

// --- Warna konsisten dari HomeView ---
const Color softLavender = Color(0xFFE0BBE4);
const Color palePink = Color(0xFFFFD1DC);
const Color softBlue = Color.fromARGB(255, 113, 196, 255);
const Color deepContrast = Color(0xFF4A4E69);
const Color accentButton = Color(0xFF957DAD);
const Color whiteContrast = Color(0xFFF0F0F0);
const Color softBorder = Color(0xFFC7B1E3);
const Color paleBackground = Color(0xFFFFF0F5);

class CollectionView extends StatefulWidget {
  final HiveService hiveService;
  const CollectionView({super.key, required this.hiveService});

  @override
  State<CollectionView> createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  String _selectedZone = 'WIB';

  @override
  Widget build(BuildContext context) {
    final username = widget.hiveService.getSession();
    final user = widget.hiveService.getUser(username!)!;
    final owned = user.ownedCharacters;

    return Scaffold(
      backgroundColor: paleBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [softLavender, palePink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x40957DAD),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Koleksi Saya",
                    style: TextStyle(
                      color: deepContrast,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: softBorder, width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedZone,
                        icon: Icon(Icons.access_time, color: accentButton),
                        dropdownColor: whiteContrast,
                        style: TextStyle(
                          color: deepContrast,
                          fontWeight: FontWeight.w600,
                        ),
                        items: ['WIB', 'WITA', 'WIT', 'LONDON']
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedZone = v!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // --- Body List ---
      body: owned.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_dissatisfied,
                      color: accentButton.withOpacity(0.6), size: 60),
                  const SizedBox(height: 10),
                  Text(
                    'Belum ada karakter dibeli 😅',
                    style: TextStyle(
                      color: deepContrast.withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: owned.length,
              itemBuilder: (context, i) {
                final c = owned[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: whiteContrast,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: softBorder.withOpacity(0.3), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: deepContrast.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        c.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 60,
                          height: 60,
                          color: softLavender.withOpacity(0.2),
                          child: Icon(Icons.image_not_supported,
                              color: accentButton.withOpacity(0.6)),
                        ),
                      ),
                    ),
                    title: Text(
                      c.name,
                      style: const TextStyle(
                        color: deepContrast,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Dibeli pada ${convertTimeZone(c.acquiredAt, _selectedZone)}',
                        style: TextStyle(
                          color: deepContrast.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
