import 'package:flutter/material.dart';
import '../../../data/models/banner_model.dart';
import '../../../core/services/image_service/image_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/config/app_router.dart';

class PromotionalBanner extends StatelessWidget {
  final BannerModel banner;

  const PromotionalBanner({super.key, required this.banner});

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
        margin: const EdgeInsets.all(20),
        height: 200,
        child: Stack(
          children: [
            ImageService.banner(
              imageUrl: banner.imageUrl,
              borderRadius: BorderRadius.circular(20),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    banner.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (banner.subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        banner.subtitle!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _onTap(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(banner.ctaText ?? 'Explore'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
