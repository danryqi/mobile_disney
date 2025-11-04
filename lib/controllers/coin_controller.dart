import '../models/user_model.dart';
import '../services/hive_service.dart';

class CoinController {
  final HiveService hiveService;
  CoinController(this.hiveService);

  void addCoins(User user, int amount) {
    user.coins += amount;
    hiveService.updateUser(user);
  }

  bool spendCoins(User user, int cost) {
    if (user.coins >= cost) {
      user.coins -= cost;
      hiveService.updateUser(user);
      return true;
    }
    return false;
  }
}
