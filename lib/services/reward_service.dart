import '../models/user_model.dart';
import '../services/hive_service.dart';

class RewardService {
  final HiveService hiveService;
  RewardService(this.hiveService);

  bool canClaim(User user) {
    if (user.lastClaimDate == null) return true;
    final now = DateTime.now();
    return !(now.year == user.lastClaimDate!.year &&
        now.month == user.lastClaimDate!.month &&
        now.day == user.lastClaimDate!.day);
  }

  Future<bool> claimDaily(User user) async {
    if (!canClaim(user)) return false;
    user.coins += 50;
    user.lastClaimDate = DateTime.now();
    await hiveService.updateUser(user);
    return true;
  }
}
