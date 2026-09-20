import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../core/config/app_router.dart';
import '../../core/config/dependency_injection.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/enums.dart';
import '../../core/services/image_service/image_service.dart';
import '../../data/models/amenity_model.dart';
import '../../data/models/hotel_model.dart';
import '../../data/models/room_model.dart';
import '../../data/models/review_model.dart';
import '../../domain/repositories/hotel_repository.dart';
import 'bloc/hotel_bloc.dart';
import '../wishlist/bloc/wishlist_bloc.dart';
import '../../domain/repositories/wishlist_repository.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HotelDetailsScreen extends StatelessWidget {
  final String hotelId;
  const HotelDetailsScreen({super.key, required this.hotelId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HotelBloc(
            hotelRepository: sl<HotelRepository>(),
          )..add(LoadHotelDetails(hotelId)),
        ),
        BlocProvider(
          create: (context) => WishlistBloc(
            wishlistRepository: sl<WishlistRepository>(),
          )..add(LoadWishlist()),
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<HotelBloc, HotelState>(
          builder: (context, state) {
            if (state is HotelLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HotelLoaded) {
              return _HotelDetailsBody(hotel: state.hotel);
            }
            if (state is HotelError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _HotelDetailsBody extends StatefulWidget {
  final HotelModel hotel;
  const _HotelDetailsBody({required this.hotel});

  @override
  State<_HotelDetailsBody> createState() => _HotelDetailsBodyState();
}

class _HotelDetailsBodyState extends State<_HotelDetailsBody> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _roomSectionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 900;

    if (isWideScreen) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.hotel.images.length,
              itemBuilder: (context, index) => ImageService.hotel(
                imageUrl: widget.hotel.images[index],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 32),
                        _buildDescription(context),
                        const SizedBox(height: 32),
                        _buildAmenities(context),
                        const SizedBox(height: 32),
                        _buildRoomSection(context, key: _roomSectionKey),
                        const SizedBox(height: 32),
                        _buildReviews(context),
                        const SizedBox(height: 32),
                        _buildLocation(context),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(context),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildSliverAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 24),
                      _buildDescription(context),
                      const SizedBox(height: 24),
                      _buildAmenities(context),
                      const SizedBox(height: 24),
                      _buildRoomSection(context, key: _roomSectionKey),
                      const SizedBox(height: 24),
                      _buildReviews(context),
                      const SizedBox(height: 24),
                      _buildLocation(context),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildBottomBar(context),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.hotel.images.length,
              itemBuilder: (context, index) => ImageService.hotel(
                imageUrl: widget.hotel.images[index],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.hotel.images.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: AppColors.secondary,
                    dotColor: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.4), Colors.transparent, Colors.black.withValues(alpha: 0.6)],
                ),
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sharing hotel details...')));
          },
        ),
        BlocBuilder<WishlistBloc, WishlistState>(
          builder: (context, state) {
            final isFavorite = state is WishlistLoaded && state.hotels.any((h) => h.id == widget.hotel.id);
            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.white,
              ),
              onPressed: () {
                context.read<WishlistBloc>().add(ToggleWishlist(widget.hotel));
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(widget.hotel.name, style: Theme.of(context).textTheme.displaySmall),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text('${widget.hotel.starRating}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, color: AppColors.secondary, size: 16),
            const SizedBox(width: 4),
            Text('${widget.hotel.city}, ${widget.hotel.address}', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(widget.hotel.description, style: const TextStyle(color: Colors.grey, height: 1.6)),
      ],
    );
  }

  Widget _buildAmenities(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Amenities', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: widget.hotel.amenities.take(6).map((a) {
            final type = AmenityType.values.firstWhere((e) => e.name == a.toLowerCase().replaceAll(' ', ''), orElse: () => AmenityType.wifi);
            final amenity = AmenityModel.fromType(type);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[200]!)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(amenity.icon, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(amenity.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRoomSection(BuildContext context, {Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Available Rooms', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Showing all available rooms...')));
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...widget.hotel.rooms.take(2).map((room) => _RoomCard(room: room, hotel: widget.hotel)),
      ],
    );
  }

  Widget _buildReviews(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Reviews (${widget.hotel.reviews.length})', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => _showReviewDialog(context),
              child: const Text('Write a Review'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (widget.hotel.reviews.isEmpty)
          const Text('No reviews yet. Be the first to review!', style: TextStyle(color: Colors.grey))
        else
          ...widget.hotel.reviews.take(3).map((review) => _ReviewItem(review: review)),
        if (widget.hotel.reviews.length > 3)
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('View All Reviews'),
            ),
          ),
      ],
    );
  }

  void _showReviewDialog(BuildContext context) {
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Write a Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RatingBar.builder(
              initialRating: 5,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                // In a real app, update state
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Share your experience...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              // In a real app, this would call a repository to save the review
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review submitted successfully!')));
              Navigator.pop(context);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Location', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.hotel.latitude, widget.hotel.longitude),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(widget.hotel.id),
                  position: LatLng(widget.hotel.latitude, widget.hotel.longitude),
                ),
              },
              liteModeEnabled: true,
              onTap: (_) {
                Navigator.pushNamed(context, AppRouter.mapView, arguments: {
                  'hotels': [widget.hotel],
                  'initialPosition': LatLng(widget.hotel.latitude, widget.hotel.longitude),
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Starting from', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('₹${widget.hotel.lowestPrice.toInt()}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Scrollable.ensureVisible(
                _roomSectionKey.currentContext!,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(180, 56)),
            child: const Text('Select Room'),
          ),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final ReviewModel review;
  const _ReviewItem({required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(review.userImageUrl),
                radius: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(DateFormat('dd MMM yyyy').format(review.date), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating.floor() ? Icons.star : Icons.star_border,
                    size: 14,
                    color: Colors.amber,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review.comment, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final RoomModel room;
  final HotelModel hotel;
  const _RoomCard({required this.room, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: ImageService.room(
              imageUrl: room.images.first,
              height: 160,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(room.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('₹${room.pricePerNight.toInt()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(room.bedType, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRouter.booking,
                      arguments: {'hotel': hotel, 'room': room},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  child: const Text('Book Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
