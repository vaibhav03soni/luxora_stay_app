import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/config/dependency_injection.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../../data/models/hotel_model.dart';
import 'bloc/wishlist_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WishlistBloc(wishlistRepository: sl<WishlistRepository>())..add(LoadWishlist()),
      child: Scaffold(
        appBar: AppBar(title: const Text('My Wishlist')),
        body: BlocBuilder<WishlistBloc, WishlistState>(
          builder: (context, state) {
            if (state is WishlistLoading) return const Center(child: CircularProgressIndicator());
            if (state is WishlistLoaded) {
              if (state.hotels.isEmpty) return const Center(child: Text('Your wishlist is empty.'));
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.hotels.length,
                itemBuilder: (context, index) => _WishlistCard(hotel: state.hotels[index]),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _WishlistCard extends StatelessWidget {
  final HotelModel hotel;
  const _WishlistCard({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(imageUrl: hotel.images.first, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(hotel.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('₹${hotel.lowestPrice.toInt()}/night'),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: AppColors.primary),
          onPressed: () {
            context.read<WishlistBloc>().add(ToggleWishlist(hotel));
          },
        ),
      ),
    );
  }
}
