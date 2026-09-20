import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../models/hotel_model.dart';
import '../../core/services/firestore/firestore_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/config/dependency_injection.dart';
import '../../core/config/app_config.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final FirestoreService _firestoreService;
  List<HotelModel> _mockWishlist = [];

  WishlistRepositoryImpl({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  String? get _userId => sl<AuthService>().currentUser?.uid;

  Future<void> _loadMockWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('mock_wishlist') ?? [];
    _mockWishlist = data.map((e) => HotelModel.fromJson(jsonDecode(e))).toList();
  }

  Future<void> _saveMockWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _mockWishlist.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('mock_wishlist', data);
  }

  @override
  Future<List<HotelModel>> getWishlist() async {
    if (AppConfig.isMock) {
      await _loadMockWishlist();
      return List.from(_mockWishlist);
    }
    final userId = _userId;
    if (userId == null) return [];

    final List<HotelModel> wishlist = await _firestoreService.streamCollection<HotelModel>(
      path: 'users/$userId/wishlist',
      builder: (data, id) => HotelModel.fromJson({...data, 'id': id}),
    ).first;
    return wishlist;
  }

  @override
  Future<void> addToWishlist(HotelModel hotel) async {
    if (AppConfig.isMock) {
      await _loadMockWishlist();
      if (!_mockWishlist.any((h) => h.id == hotel.id)) {
        _mockWishlist.add(hotel);
        await _saveMockWishlist();
      }
      return;
    }
    final userId = _userId;
    if (userId == null) return;

    await _firestoreService.setData(
      path: 'users/$userId/wishlist/${hotel.id}',
      data: hotel.toJson(),
    );
  }

  @override
  Future<void> removeFromWishlist(String hotelId) async {
    if (AppConfig.isMock) {
      await _loadMockWishlist();
      _mockWishlist.removeWhere((h) => h.id == hotelId);
      await _saveMockWishlist();
      return;
    }
    final userId = _userId;
    if (userId == null) return;

    await _firestoreService.deleteDocument(
      path: 'users/$userId/wishlist/$hotelId',
    );
  }

  @override
  Future<bool> isInWishlist(String hotelId) async {
    if (AppConfig.isMock) {
      await _loadMockWishlist();
      return _mockWishlist.any((h) => h.id == hotelId);
    }
    final userId = _userId;
    if (userId == null) return false;

    final doc = await _firestoreService.getDocument(
      path: 'users/$userId/wishlist/$hotelId',
      builder: (data, id) => true,
    );
    return doc ?? false;
  }
}
