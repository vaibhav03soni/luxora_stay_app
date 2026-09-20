import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/enums.dart';
import '../../core/config/dependency_injection.dart';
import '../../core/services/image_service/image_service.dart';
import '../../domain/repositories/hotel_repository.dart';
import '../../data/models/hotel_model.dart';
import '../../data/models/amenity_model.dart';
import 'bloc/search_bloc.dart';
import '../wishlist/bloc/wishlist_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/config/app_router.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;
  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late SearchBloc _searchBloc;
  RangeValues _currentPriceRange = const RangeValues(0, 20000);
  int? _selectedStarRating;
  String? _currentSortOption;
  List<String> _recentSearches = [];
  PropertyType? _selectedPropertyType;
  final List<AmenityType> _selectedAmenities = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
    }
    _searchBloc = SearchBloc(hotelRepository: sl<HotelRepository>())
      ..add(SearchHotels(query: widget.initialQuery));
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _saveSearch(String query) async {
    if (query.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    List<String> searches = prefs.getStringList('recent_searches') ?? [];
    searches.remove(query);
    searches.insert(0, query);
    if (searches.length > 5) searches = searches.sublist(0, 5);
    await prefs.setStringList('recent_searches', searches);
    _loadRecentSearches();
  }

  @override
  void dispose() {
    _searchBloc.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Where are you going?',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) {
              _searchBloc.add(SearchSuggestionsRequested(value));
            },
            onSubmitted: (value) {
              if (value.isNotEmpty) _saveSearch(value);
              _searchBloc.add(SearchHotels(
                query: value.isNotEmpty ? value : null,
                starRating: _selectedStarRating,
                minPrice: _currentPriceRange.start,
                maxPrice: _currentPriceRange.end,
                sortBy: _currentSortOption,
                propertyType: _selectedPropertyType,
                amenities: _selectedAmenities.isEmpty ? null : _selectedAmenities,
              ));
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.tune, color: AppColors.primary),
              onPressed: () => _showFilterSheet(context),
            ),
          ],
        ),
        body: Column(
          children: [
            _buildSortBar(context),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is SearchInitial && _recentSearches.isNotEmpty) {
                    return _buildRecentSearches();
                  }
                  if (state is SearchSuggestionsLoaded) {
                    return _buildSuggestions(state.suggestions);
                  }
                  if (state is SearchResults) {
                    if (state.hotels.isEmpty) {
                      return _buildEmptyState();
                    }

                    final bool isWideScreen = MediaQuery.of(context).size.width > 900;

                    if (isWideScreen) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(24),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: state.hotels.length,
                        itemBuilder: (context, index) => _SearchResultCard(hotel: state.hotels[index]),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.hotels.length,
                      itemBuilder: (context, index) => _SearchResultCard(hotel: state.hotels[index]),
                    );
                  }
                  if (state is SearchError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('Enter a destination to start searching.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Search Results", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _currentSortOption = value;
              });
              _searchBloc.add(SearchHotels(
                query: _searchController.text.isNotEmpty ? _searchController.text : null,
                starRating: _selectedStarRating,
                minPrice: _currentPriceRange.start,
                maxPrice: _currentPriceRange.end,
                sortBy: _currentSortOption,
                propertyType: _selectedPropertyType,
                amenities: _selectedAmenities.isEmpty ? null : _selectedAmenities,
              ));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'price_low_to_high', child: Text('Price: Low to High')),
              const PopupMenuItem(value: 'price_high_to_low', child: Text('Price: High to Low')),
              const PopupMenuItem(value: 'rating', child: Text('Star Rating: High to Low')),
            ],
            child: Row(
              children: [
                const Icon(Icons.sort, size: 18, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  _currentSortOption == 'price_low_to_high'
                      ? "Price: Low to High"
                      : _currentSortOption == 'price_high_to_low'
                          ? "Price: High to Low"
                          : _currentSortOption == 'rating'
                              ? "Rating"
                              : "Sort",
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(List<String> suggestions) {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.location_on_outlined, color: Colors.grey),
        title: Text(suggestions[index]),
        onTap: () {
          _searchController.text = suggestions[index];
          _saveSearch(suggestions[index]);
          _searchBloc.add(SearchHotels(
            query: suggestions[index],
            starRating: _selectedStarRating,
            minPrice: _currentPriceRange.start,
            maxPrice: _currentPriceRange.end,
            sortBy: _currentSortOption,
            propertyType: _selectedPropertyType,
            amenities: _selectedAmenities.isEmpty ? null : _selectedAmenities,
          ));
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("No results found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text("Try searching for a different destination", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text("Recent Searches", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        ..._recentSearches.map((query) => ListTile(
              leading: const Icon(Icons.history, color: Colors.grey),
              title: Text(query),
              onTap: () {
                _searchController.text = query;
                _searchBloc.add(SearchHotels(query: query));
              },
            )),
      ],
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.8,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) => Container(
                padding: const EdgeInsets.all(24),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Filters', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              _currentPriceRange = const RangeValues(0, 20000);
                              _selectedStarRating = null;
                              _selectedPropertyType = null;
                              _selectedAmenities.clear();
                            });
                          },
                          child: const Text('Reset', style: TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Price Range: ₹${_currentPriceRange.start.toInt()} - ₹${_currentPriceRange.end.toInt()}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    RangeSlider(
                      values: _currentPriceRange,
                      min: 0,
                      max: 20000,
                      divisions: 20,
                      activeColor: AppColors.primary,
                      labels: RangeLabels(
                        '₹${_currentPriceRange.start.toInt()}',
                        '₹${_currentPriceRange.end.toInt()}',
                      ),
                      onChanged: (values) {
                        setModalState(() {
                          _currentPriceRange = values;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text('Star Rating', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (index) {
                        final star = index + 1;
                        final isSelected = _selectedStarRating == star;
                        return ChoiceChip(
                          label: Text('$star ★'),
                          selected: isSelected,
                          onSelected: (val) {
                            setModalState(() {
                              _selectedStarRating = val ? star : null;
                            });
                          },
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    const Text('Property Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: PropertyType.values.map((type) {
                        final isSelected = _selectedPropertyType == type;
                        return ChoiceChip(
                          label: Text(type.name[0].toUpperCase() + type.name.substring(1)),
                          selected: isSelected,
                          onSelected: (val) {
                            setModalState(() {
                              _selectedPropertyType = val ? type : null;
                            });
                          },
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    const Text('Amenities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: AmenityType.values.map((type) {
                        final isSelected = _selectedAmenities.contains(type);
                        final amenity = AmenityModel.fromType(type);
                        return FilterChip(
                          label: Text(amenity.name),
                          selected: isSelected,
                          onSelected: (val) {
                            setModalState(() {
                              if (val) {
                                _selectedAmenities.add(type);
                              } else {
                                _selectedAmenities.remove(type);
                              }
                            });
                          },
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        _searchBloc.add(SearchHotels(
                          query: _searchController.text.isNotEmpty ? _searchController.text : null,
                          starRating: _selectedStarRating,
                          minPrice: _currentPriceRange.start,
                          maxPrice: _currentPriceRange.end,
                          sortBy: _currentSortOption,
                          propertyType: _selectedPropertyType,
                          amenities: _selectedAmenities.isEmpty ? null : _selectedAmenities,
                        ));
                        Navigator.pop(context);
                      },
                      child: const Text('Apply Filters'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final HotelModel hotel;
  const _SearchResultCard({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.hotelDetails, arguments: hotel.id);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
            children: [
              ImageService.hotel(
                imageUrl: hotel.images.first,
                height: 200,
              ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: BlocBuilder<WishlistBloc, WishlistState>(
                    builder: (context, state) {
                      final isFavorite = state is WishlistLoaded && state.hotels.any((h) => h.id == hotel.id);
                      return CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: AppColors.primary,
                          ),
                          onPressed: () {
                            context.read<WishlistBloc>().add(ToggleWishlist(hotel));
                          },
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(8)),
                    child: const Text('Free Cancellation', style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(hotel.name, style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.secondary, size: 16),
                          const SizedBox(width: 4),
                          Text('${hotel.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey, size: 14),
                      const SizedBox(width: 4),
                      Text(hotel.city, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildAmenityIcon(Icons.wifi),
                      _buildAmenityIcon(Icons.pool),
                      _buildAmenityIcon(Icons.restaurant),
                      _buildAmenityIcon(Icons.ac_unit),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('₹${(hotel.lowestPrice * 1.2).toInt()}', style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 12)),
                          Text('₹${hotel.lowestPrice.toInt()}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          const Text('/night', style: TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRouter.hotelDetails, arguments: hotel.id);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          minimumSize: const Size(0, 44),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                        ),
                        child: const Text('Book Now'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenityIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
      child: Icon(icon, size: 14, color: Colors.grey[600]),
    );
  }
}
