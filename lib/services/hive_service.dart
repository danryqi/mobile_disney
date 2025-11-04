import 'package:hive/hive.dart';
import '../models/user_model.dart';
import '../models/owned_character_model.dart';

class HiveService {
  static const userBox = 'users';
  static const sessionBox = 'session';

  Future<void> init() async {
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(OwnedCharacterAdapter());
    await Hive.openBox<User>(userBox);
    await Hive.openBox<String>(sessionBox);
  }

  Box<User> get userHive => Hive.box<User>(userBox);
  Box<String> get sessionHive => Hive.box<String>(sessionBox);

  Future<void> saveSession(String username) async {
    await sessionHive.put('loggedInUser', username);
  }

  String? getSession() => sessionHive.get('loggedInUser');

  Future<void> logout() async {
    await sessionHive.delete('loggedInUser');
  }

  User? getUser(String username) {
    try {
      return userHive.values.firstWhere((u) => u.username == username);
    } catch (_) {
      return null;
    }
  }

  Future<bool> registerUser(User user) async {
    if (getUser(user.username) != null) return false;
    await userHive.add(user);
    return true;
  }

  Future<void> updateUser(User user) async {
    await user.save();
  }
  
}
