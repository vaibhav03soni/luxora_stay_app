import 'package:shared_preferences/shared_preferences.dart';

class RecentViewedService {
  static const String _key = 'recently_viewed_hotels';

  static Future<void> addHotel(String hotelId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> ids = prefs.getStringList(_key) ?? [];
    ids.remove(hotelId);
    ids.insert(0, hotelId);
    if (ids.length > 10) {
      ids = ids.sublist(0, 10);
    }
    await prefs.setStringList(_key, ids);
  }

  static Future<List<String>> getRecentHotels() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }
}
