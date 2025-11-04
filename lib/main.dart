import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 🧩 Import semua view
import 'package:disney_nina/views/landing.dart' show LandingView;
import 'package:disney_nina/views/login.dart';
import 'package:disney_nina/views/register.dart';
import 'package:disney_nina/views/homepage.dart';
import 'package:disney_nina/views/character_Detail.dart';
import 'package:disney_nina/views/collection.dart';
import 'package:disney_nina/views/coin_store.dart';

// 🧠 Import controller dan service
import 'controllers/auth_controller.dart';
import 'controllers/character_controller.dart';
import 'services/hive_service.dart';
import 'services/api_service.dart';
import 'models/character_model.dart';

// ✅ Inisialisasi notifikasi
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inisialisasi Hive
  await Hive.initFlutter();
  final hiveService = HiveService();
  await hiveService.init();

  // ✅ Inisialisasi notifikasi Android
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // Jalankan aplikasi
  runApp(MyApp(hiveService: hiveService));
}

class MyApp extends StatefulWidget {
  final HiveService hiveService;
  const MyApp({super.key, required this.hiveService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthController authController;
  late final CharacterController characterController;
  bool _isCheckingSession = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    authController = AuthController(widget.hiveService);
    characterController = CharacterController(ApiService(), widget.hiveService);
    _checkSession();
  }

  // ✅ Cek apakah user sudah login (punya sesi tersimpan di Hive)
  Future<void> _checkSession() async {
    final session = widget.hiveService.getSession();
    setState(() {
      _isLoggedIn = session != null;
      _isCheckingSession = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingSession) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Disney Character Collection',
      theme: ThemeData(primarySwatch: Colors.blue),

      // 🏁 Halaman pertama:
      // jika user sudah login, langsung ke /home
      // jika belum, tampilkan landing page
      home: _isLoggedIn
          ? HomeView(
              authController: authController,
              characterController: characterController,
              hiveService: widget.hiveService,
            )
          : const LandingView(),

      // 🔗 Rute navigasi aplikasi
      routes: {
        '/login': (_) => LoginView(controller: authController),
        '/register': (_) => RegisterView(controller: authController),
        '/home': (_) => HomeView(
              authController: authController,
              characterController: characterController,
              hiveService: widget.hiveService,
            ),
        '/character_detail': (context) {
          final char = ModalRoute.of(context)!.settings.arguments as Character;
          return CharacterDetailView(character: char, hiveService: widget.hiveService);
        },
        '/collection': (_) => CollectionView(hiveService: widget.hiveService),
        '/coin_store': (_) => CoinStoreView(hiveService: widget.hiveService),
        '/landing': (context) => const LandingView(),
      },
    );
  }
}
