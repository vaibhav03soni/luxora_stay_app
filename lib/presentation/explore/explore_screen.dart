import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/config/dependency_injection.dart';
import '../../domain/repositories/banner_repository.dart';
import '../../data/models/banner_model.dart';
import '../banners/bloc/banner_bloc.dart';
import '../../core/services/image_service/image_service.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/config/app_router.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BannerBloc(
        bannerRepository: sl<BannerRepository>(),
      )..add(LoadBanners()),
      child: Scaffold(
        body: BlocBuilder<BannerBloc, BannerState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 120,
                  floating: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text('Explore', style: GoogleFonts.playfairDisplay(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    centerTitle: false,
                    titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                  ),
                ),
                if (state is BannerLoading)
                  const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()))),

                if (state is BannersLoaded) ...[
                  _buildSectionHeader('Popular Destinations'),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final destinations = state.banners.where((b) => b.bannerType == BannerType.destination).toList();
                          return _buildCategoryCard(context, destinations[index]);
                        },
                        childCount: state.banners.where((b) => b.bannerType == BannerType.destination).length,
                      ),
                    ),
                  ),
                  _buildSectionHeader('Special Collections'),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final collections = state.banners.where((b) => b.bannerType == BannerType.luxury).toList();
                          return _buildWideCollectionCard(context, collections[index]);
                        },
                        childCount: state.banners.where((b) => b.bannerType == BannerType.luxury).length,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
        child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildWideCollectionCard(BuildContext context, BannerModel banner) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.search, arguments: banner.title);
      },
      child: Container(
        height: 180,
        margin: const EdgeInsets.only(bottom: 16),
        child: Stack(
          children: [
            ImageService.banner(
              imageUrl: banner.imageUrl,
              borderRadius: BorderRadius.circular(16),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(banner.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(banner.subtitle ?? '', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, BannerModel banner) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          ImageService.banner(
            imageUrl: banner.imageUrl,
            borderRadius: BorderRadius.circular(16),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRouter.search, arguments: banner.title);
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(banner.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
