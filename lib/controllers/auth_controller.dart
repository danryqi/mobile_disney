import 'package:disney_nina/utils/hash_util.dart';
import '../models/user_model.dart';
import '../services/hive_service.dart';

class AuthController {
  final HiveService hiveService;

  AuthController(this.hiveService);

  /// REGISTER USER
  Future<bool> register(String username, String email, String password) async {
    // Cek username atau email sudah digunakan
    final existingUser = hiveService.userHive.values.firstWhere(
      (u) => u.username == username || u.email == email,
      orElse: () => User(username: '', email: '', passwordHash: ''),
    );
    if (existingUser.username.isNotEmpty) return false;

    final hashed = hashPassword(password);
    final newUser = User(
      username: username,
      email: email,
      passwordHash: hashed,
    );

    await hiveService.registerUser(newUser);
    return true;
  }

  /// LOGIN USER
  Future<bool> login(String username, String password) async {
    final user = hiveService.getUser(username);
    if (user == null) return false;

    if (verifyPassword(password, user.passwordHash)) {
      await hiveService.saveSession(username);
      return true;
    }
    return false;
  }

  Future<void> logout() async => hiveService.logout();
}
