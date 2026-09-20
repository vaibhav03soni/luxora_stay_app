import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/config/app_router.dart';
import '../../core/config/dependency_injection.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/image_service/image_service.dart';
import '../../data/models/banner_model.dart';
import '../../data/models/destination_model.dart';
import '../../data/models/hotel_model.dart';
import '../../domain/repositories/banner_repository.dart';
import '../../domain/repositories/hotel_repository.dart';
import '../banners/bloc/banner_bloc.dart';
import '../widgets/calendar_widget.dart';
import 'bloc/home_bloc.dart';
import 'widgets/hero_slider.dart';
import 'widgets/promo_carousel.dart';
import 'widgets/promotional_banner.dart';
import '../../core/services/location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _currentLocationName = "India";

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      // In a real app, we'd use geocoding to get the city name.
      // For this demo, let's simulate it.
      setState(() {
        _currentLocationName = "Mumbai, India"; // Simulated geocoding
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(
            hotelRepository: sl<HotelRepository>(),
          )..add(LoadHomeData()),
        ),
        BlocProvider(
          create: (context) => BannerBloc(
            bannerRepository: sl<BannerRepository>(),
          )..add(LoadBanners()),
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, homeState) {
            return BlocBuilder<BannerBloc, BannerState>(
              builder: (context, bannerState) {
                return CustomScrollView(
                  slivers: [
                    _buildAppBar(context),
                    _buildHeroHeader(context),
                    _buildCategoryFilter(context),

                    // Hero Slider
                    if (bannerState is BannersLoaded)
                      SliverToBoxAdapter(
                        child: HeroSlider(
                          banners: bannerState.banners
                              .where((b) => b.bannerType == BannerType.homeHero)
                              .toList(),
                        ),
                      ),

                    _buildSearchCard(context),

                    // Offers Section
                    if (bannerState is BannersLoaded)
                      SliverToBoxAdapter(
                        child: PromoCarousel(
                          title: AppStrings.get(context, 'exclusiveOffers'),
                          banners: bannerState.banners
                              .where((b) => b.bannerType == BannerType.homeOffer)
                              .toList(),
                        ),
                      ),

                    if (homeState is HomeLoading)
                      const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),

                    if (homeState is HomeLoaded) ...[
                      _buildFeaturedSection(context, AppStrings.get(context, 'featuredStays'), homeState.featuredHotels),
                      _buildDestinationsSection(context, AppStrings.get(context, 'popularDestinations'), homeState.popularDestinations),
                      if (homeState.recentlyViewedHotels.isNotEmpty)
                        _buildRecentSection(context, "Recently Viewed", homeState.recentlyViewedHotels),
                      _buildRecommendedSection(context, AppStrings.get(context, 'recommendedForYou'), homeState.recommendedHotels),
                    ],

                    if (bannerState is BannersLoaded)
                      ...bannerState.banners
                          .where((b) => b.bannerType == BannerType.homePromotion)
                          .map((b) => SliverToBoxAdapter(child: PromotionalBanner(banner: b))),

                    if (homeState is HomeError)
                      SliverToBoxAdapter(child: Center(child: Text(homeState.message))),

                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: Text(AppStrings.appName, style: GoogleFonts.playfairDisplay(color: AppColors.primary, fontWeight: FontWeight.bold)),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined, color: AppColors.primary),
          onPressed: () => Navigator.pushNamed(context, AppRouter.notifications),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    final categories = ['Luxury', 'Budget', 'Resort', 'Villa', 'Apartment', 'Premium'];
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ActionChip(
                label: Text(category),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.search,
                    arguments: category,
                  );
                },
                backgroundColor: AppColors.primary.withValues(alpha: 0.05),
                labelStyle: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.get(context, 'homeHeroTitle'),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(height: 1.2),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.get(context, 'tagline'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Hero(
          tag: 'search_card',
          child: Material(
            elevation: 8,
            shadowColor: AppColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, AppRouter.search),
                    child: _buildSearchRow(Icons.location_on_outlined, AppStrings.get(context, 'searchDestination'), _currentLocationName),
                  ),
                  const Divider(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => CalendarWidget.show(
                            context,
                            initialStartDate: _startDate,
                            initialEndDate: _endDate,
                            onDatesSelected: (start, end) {
                              setState(() {
                                _startDate = start;
                                _endDate = end;
                              });
                            },
                          ),
                          child: _buildSearchRow(
                            Icons.calendar_today_outlined,
                            AppStrings.get(context, 'checkIn'),
                            _startDate != null ? DateFormat('MMM dd').format(_startDate!) : "Select Date",
                          ),
                        ),
                      ),
                      const VerticalDivider(),
                      Expanded(
                        child: InkWell(
                          onTap: () => CalendarWidget.show(
                            context,
                            initialStartDate: _startDate,
                            initialEndDate: _endDate,
                            onDatesSelected: (start, end) {
                              setState(() {
                                _startDate = start;
                                _endDate = end;
                              });
                            },
                          ),
                          child: _buildSearchRow(
                            Icons.calendar_today_outlined,
                            AppStrings.get(context, 'checkOut'),
                            _endDate != null ? DateFormat('MMM dd').format(_endDate!) : "Select Date",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRouter.search),
                    child: Text(AppStrings.get(context, 'findPerfectStay')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary, size: 22),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentSection(BuildContext context, String title, List<HotelModel> hotels) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, title),
          SizedBox(
            height: 200,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: hotels.length,
              itemBuilder: (context, index) => _RecentHotelCard(hotel: hotels[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection(BuildContext context, String title, List<HotelModel> hotels) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 600;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, title),
          SizedBox(
            height: isWideScreen ? 380 : 320,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: hotels.length,
              itemBuilder: (context, index) => _HotelCard(
                hotel: hotels[index],
                width: isWideScreen ? 300 : 240,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationsSection(BuildContext context, String title, List<DestinationModel> destinations) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, title),
          SizedBox(
            height: 140,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: destinations.length,
              itemBuilder: (context, index) => _DestinationCard(destination: destinations[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedSection(BuildContext context, String title, List<HotelModel> hotels) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 900;

    if (isWideScreen) {
      return SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, title),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 2.5,
                ),
                itemCount: hotels.length,
                itemBuilder: (context, index) => _HotelListTile(hotel: hotels[index]),
              ),
            ),
          ],
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) return _buildSectionHeader(context, title);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: _HotelListTile(hotel: hotels[index - 1]),
          );
        },
        childCount: hotels.length + 1,
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.search),
            child: const Text('View All', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _RecentHotelCard extends StatelessWidget {
  final HotelModel hotel;
  const _RecentHotelCard({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.hotelDetails, arguments: hotel.id);
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16, bottom: 8),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ImageService.hotel(
                  imageUrl: hotel.images.first,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hotel.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(hotel.city, style: const TextStyle(fontSize: 10, color: Colors.grey)),
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

class _HotelCard extends StatelessWidget {
  final HotelModel hotel;
  final double width;
  const _HotelCard({required this.hotel, this.width = 240});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.hotelDetails, arguments: hotel.id);
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 16, bottom: 8),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    ImageService.hotel(
                      imageUrl: hotel.images.first,
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.secondary, size: 14),
                            const SizedBox(width: 4),
                            Text('${hotel.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(hotel.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey, size: 14),
                          const SizedBox(width: 4),
                          Text(hotel.city, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('₹${hotel.lowestPrice.toInt()}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                          const Text('/night', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final DestinationModel destination;
  const _DestinationCard({required this.destination});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.search, arguments: destination.name);
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            ImageService.destination(
              imageUrl: destination.imageUrl,
              height: 100,
              width: 100,
              borderRadius: BorderRadius.circular(16),
            ),
            const SizedBox(height: 8),
            Text(destination.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _HotelListTile extends StatelessWidget {
  final HotelModel hotel;
  const _HotelListTile({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.hotelDetails, arguments: hotel.id);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            ImageService.hotel(
              imageUrl: hotel.images.first,
              width: 120,
              height: 120,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hotel.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(hotel.city, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.secondary, size: 14),
                            const SizedBox(width: 4),
                            Text('${hotel.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text('₹${hotel.lowestPrice.toInt()}/night', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
