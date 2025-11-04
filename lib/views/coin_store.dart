import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:disney_nina/utils/conversion_util.dart';
import '../services/hive_service.dart';
import '../services/reward_service.dart';
import '../services/currency_service.dart';
import '../models/user_model.dart';

// 🎵 Warna tema yang sama dengan HomeView / CollectionView
const Color softLavender = Color(0xFFE0BBE4);
const Color palePink = Color(0xFFFFD1DC);
const Color deepContrast = Color(0xFF4A4E69);
const Color accentButton = Color(0xFF957DAD);
const Color whiteContrast = Color(0xFFF0F0F0);
const Color softBorder = Color(0xFFC7B1E3);
const Color paleBackground = Color(0xFFFFF0F5);

// ✅ Buat instance global notifikasi
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class CoinStoreView extends StatefulWidget {
  final HiveService hiveService;
  final VoidCallback? onCoinsUpdated;

  const CoinStoreView({
    super.key,
    required this.hiveService,
    this.onCoinsUpdated,
  });

  @override
  State<CoinStoreView> createState() => _CoinStoreViewState();
}

class _CoinStoreViewState extends State<CoinStoreView> {
  late RewardService rewardService;
  late CurrencyService currencyService;
  late User user;
  bool _claimed = false;
  String _selectedCurrency = 'IDR';
  Map<String, double> _rates = {};

  final _coinPackages = [
    {'price': 25000.0, 'coins': 200},
    {'price': 50000.0, 'coins': 400},
    {'price': 100000.0, 'coins': 800},
  ];

  @override
  void initState() {
    super.initState();
    rewardService = RewardService(widget.hiveService);
    currencyService = CurrencyService();

    final username = widget.hiveService.getSession();
    user = widget.hiveService.getUser(username!)!;
    _claimed = !rewardService.canClaim(user);

    _initNotification();
    _loadRates();
  }

  Future<void> _initNotification() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await flutterLocalNotificationsPlugin.initialize(initSettings);

    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  Future<void> _loadRates() async {
    final fetched = await currencyService.getRates();
    setState(() => _rates = fetched);
  }

  Future<void> _claim() async {
    final success = await rewardService.claimDaily(user);
    setState(() => _claimed = !success);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? 'Berhasil klaim +50 Coins!'
            : 'Sudah klaim hari ini 😁'),
      ),
    );
  }

  Future<void> _sendNotification(int coins) async {
    const androidDetails = AndroidNotificationDetails(
      'purchase_channel',
      'Pembelian',
      channelDescription: 'Notifikasi pembelian coins',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const notifDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Pembelian Berhasil 🎉',
      'Kamu mendapatkan $coins coins baru!',
      notifDetails,
    );
  }

  Future<void> _buyCoins(double basePrice, int coins) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Colors.purpleAccent),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) Navigator.of(context, rootNavigator: true).pop();

    user.coins += coins;
    await widget.hiveService.updateUser(user);
    widget.onCoinsUpdated?.call();

    await _sendNotification(coins);

    if (mounted) setState(() {});

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Pembelian Berhasil 🎉'),
        content: Text(
          'Kamu berhasil membeli $coins coins!\nSaldo kamu sekarang: ${user.coins} coins.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Coin Store",
                    style: TextStyle(
                      color: deepContrast,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: softBorder, width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCurrency,
                        icon: Icon(Icons.currency_exchange,
                            color: accentButton),
                        dropdownColor: whiteContrast,
                        style: const TextStyle(
                          color: deepContrast,
                          fontWeight: FontWeight.w600,
                        ),
                        items: ['IDR', 'USD', 'EUR', 'JPY']
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedCurrency = v!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: _rates.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 💰 Saldo
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accentButton.withOpacity(0.8), softBorder],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: deepContrast.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "SALDO COIN ANDA",
                          style: TextStyle(
                            color: whiteContrast,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.monetization_on,
                                color: Colors.amberAccent, size: 28),
                            const SizedBox(width: 6),
                            Text(
                              formatCoins(user.coins),
                              style: const TextStyle(
                                color: whiteContrast,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🎁 Klaim harian
                  ElevatedButton(
                    onPressed: _claimed ? null : _claim,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _claimed ? Colors.grey : accentButton,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: _claimed ? 0 : 4,
                    ),
                    child: Text(
                      _claimed ? 'Sudah Diklaim Hari Ini' : 'Klaim +50 Coins',
                      style: const TextStyle(
                        color: whiteContrast,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Beli Coins dengan Uang Asli',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: deepContrast,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 💵 Daftar paket pembelian
                  ..._coinPackages.map((pkg) {
                    final base = pkg['price'] as double;
                    final coins = pkg['coins'] as int;
                    final converted = _selectedCurrency == 'IDR'
                        ? base
                        : base * (_rates[_selectedCurrency] ?? 1.0);
                    final formatted =
                        formatCurrency(converted, _selectedCurrency);

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: whiteContrast,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: softBorder, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: deepContrast.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        leading: const Icon(Icons.monetization_on_outlined,
                            color: Colors.amber, size: 36),
                        title: Text('$coins Coins',
                            style: const TextStyle(
                                color: deepContrast,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        subtitle: Text('Harga: $formatted',
                            style: TextStyle(
                                color: deepContrast.withOpacity(0.7))),
                        trailing: ElevatedButton(
                          onPressed: () => _buyCoins(base, coins),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentButton,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text(
                            'Beli',
                            style: TextStyle(color: whiteContrast),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
    );
  }
}
