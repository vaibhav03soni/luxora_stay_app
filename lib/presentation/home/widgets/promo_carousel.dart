import 'package:flutter/material.dart';
import '../../../data/models/banner_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/image_service/image_service.dart';
import '../../../core/config/app_router.dart';

class PromoCarousel extends StatelessWidget {
  final List<BannerModel> banners;
  final String title;

  const PromoCarousel({
    super.key,
    required this.banners,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRouter.search),
                child: const Text('View All', style: TextStyle(color: AppColors.secondary)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return _PromoCard(banner: banner);
            },
          ),
        ),
      ],
    );
  }
}

class _PromoCard extends StatelessWidget {
  final BannerModel banner;
  const _PromoCard({required this.banner});

  void _onTap(BuildContext context) {
    switch (banner.ctaType) {
      case CtaType.hotel:
        if (banner.hotelId != null) {
          Navigator.pushNamed(context, AppRouter.hotelDetails, arguments: banner.hotelId);
        }
        break;
      case CtaType.destination:
        if (banner.destinationId != null) {
          Navigator.pushNamed(context, AppRouter.search, arguments: banner.destinationId);
        }
        break;
      case CtaType.search:
      case CtaType.weekend:
      case CtaType.family:
        Navigator.pushNamed(context, AppRouter.search);
        break;
      default:
        Navigator.pushNamed(context, AppRouter.search);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        width: 280,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              ImageService.banner(
                imageUrl: banner.imageUrl,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.black.withValues(alpha: 0.2),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (banner.couponCode != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.secondary),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          banner.couponCode!,
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      banner.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (banner.subtitle != null)
                      Text(
                        banner.subtitle!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => _onTap(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        minimumSize: const Size(80, 28),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Book Now', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
