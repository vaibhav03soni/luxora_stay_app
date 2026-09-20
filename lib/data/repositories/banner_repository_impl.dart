import '../../domain/repositories/banner_repository.dart';
import '../models/banner_model.dart';
import '../mock/mock_data.dart';
import '../../core/config/app_config.dart';
import '../../core/services/firestore/firestore_service.dart';
import 'package:flutter/foundation.dart';

class BannerRepositoryImpl implements BannerRepository {
  final FirestoreService _firestoreService;

  BannerRepositoryImpl({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  @override
  Future<List<BannerModel>> getBanners({BannerType? type}) async {
    if (AppConfig.isMock) {
      return _getMockBanners(type);
    }

    try {
      final List<BannerModel> banners = await _firestoreService.streamCollection<BannerModel>(
        path: 'banners',
        builder: (data, id) => BannerModel(
          id: id,
          title: data['title'],
          subtitle: data['subtitle'],
          description: data['description'],
          imageUrl: data['imageUrl'],
          bannerType: BannerType.values.firstWhere((e) => e.toString() == data['bannerType']),
          ctaText: data['ctaText'],
          ctaType: data['ctaType'] != null ? CtaType.values.firstWhere((e) => e.toString() == data['ctaType']) : null,
          ctaValue: data['ctaValue'],
          hotelId: data['hotelId'],
          destinationId: data['destinationId'],
          discount: data['discount']?.toDouble(),
          couponCode: data['couponCode'],
          displayOrder: data['displayOrder'] ?? 0,
          isActive: data['isActive'] ?? true,
          startDate: data['startDate'] != null ? DateTime.parse(data['startDate']) : null,
          endDate: data['endDate'] != null ? DateTime.parse(data['endDate']) : null,
        ),
        queryBuilder: (query) {
          if (type != null) {
            query = query.where('bannerType', isEqualTo: type.toString());
          }
          return query.where('isActive', isEqualTo: true).orderBy('displayOrder');
        },
      ).first;

      if (banners.isEmpty) {
        return _getMockBanners(type);
      }
      return banners.where((b) => b.isCurrentlyActive).toList();
    } catch (e) {
      debugPrint('Error fetching banners: $e');
      return _getMockBanners(type);
    }
  }

  List<BannerModel> _getMockBanners(BannerType? type) {
    var results = MockData.banners;
    if (type != null) {
      results = results.where((b) => b.bannerType == type).toList();
    }
    return results.where((b) => b.isCurrentlyActive).toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  @override
  Future<BannerModel> getBannerById(String id) async {
    if (AppConfig.isMock) {
       return MockData.banners.firstWhere((b) => b.id == id);
    }
    // Real implementation if needed...
    return MockData.banners.firstWhere((b) => b.id == id);
  }
}
