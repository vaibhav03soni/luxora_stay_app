import 'package:equatable/equatable.dart';

enum BannerType {
  homeHero,
  homePromotion,
  homeOffer,
  destination,
  hotel,
  room,
  luxury,
  weekend,
  family,
  seasonal
}

enum CtaType {
  hotel,
  destination,
  offer,
  url,
  search,
  weekend,
  family
}

class BannerModel extends Equatable {
  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final String imageUrl;
  final String? mobileImageUrl;
  final String? tabletImageUrl;
  final String? desktopImageUrl;
  final String? videoUrl;
  final BannerType bannerType;
  final String? ctaText;
  final CtaType? ctaType;
  final String? ctaValue;
  final String? hotelId;
  final String? roomId;
  final String? destinationId;
  final String? offerId;
  final String? couponCode;
  final double? discount;
  final DateTime? startDate;
  final DateTime? endDate;
  final int displayOrder;
  final bool isActive;
  final String? backgroundColor;
  final String? textColor;

  const BannerModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    required this.imageUrl,
    this.mobileImageUrl,
    this.tabletImageUrl,
    this.desktopImageUrl,
    this.videoUrl,
    required this.bannerType,
    this.ctaText,
    this.ctaType,
    this.ctaValue,
    this.hotelId,
    this.roomId,
    this.destinationId,
    this.offerId,
    this.couponCode,
    this.discount,
    this.startDate,
    this.endDate,
    this.displayOrder = 0,
    this.isActive = true,
    this.backgroundColor,
    this.textColor,
  });

  bool get isCurrentlyActive {
    if (!isActive) return false;
    final now = DateTime.now();
    if (startDate != null && now.isBefore(startDate!)) return false;
    if (endDate != null && now.isAfter(endDate!)) return false;
    return true;
  }

  @override
  List<Object?> get props => [id, title, imageUrl, bannerType, isActive];
}
