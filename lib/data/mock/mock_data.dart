import '../models/hotel_model.dart';
import '../models/room_model.dart';
import '../models/destination_model.dart';
import '../models/banner_model.dart';
import '../models/review_model.dart';

class MockData {
  static final List<BannerModel> banners = [
    // Hero Banners
    BannerModel(
      id: 'b1',
      title: 'Luxury Escapes',
      subtitle: 'Experience exceptional stays',
      description: 'Save up to 25% on our premium collections this summer.',
      imageUrl: 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&q=80&w=1200',
      bannerType: BannerType.homeHero,
      ctaText: 'Explore Now',
      ctaType: CtaType.search,
      discount: 25.0,
      displayOrder: 1,
    ),
    BannerModel(
      id: 'b2',
      title: 'Royal Udaipur',
      subtitle: 'Stay in the City of Lakes',
      description: 'Discover the heritage of Rajasthan at The Oberoi Udaivilas.',
      imageUrl: 'https://images.unsplash.com/photo-1590050752117-23a9d7fc21a7?auto=format&fit=crop&q=80&w=1200',
      bannerType: BannerType.homeHero,
      ctaText: 'Book Udaipur',
      ctaType: CtaType.destination,
      ctaValue: 'd1',
      destinationId: 'd1',
      displayOrder: 2,
    ),
    BannerModel(
      id: 'b3',
      title: 'Beachfront Bliss',
      subtitle: 'Sun, Sand, and Luxury in Goa',
      description: 'The ultimate coastal retreat awaits at Taj Exotica.',
      imageUrl: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&q=80&w=1200',
      bannerType: BannerType.homeHero,
      ctaText: 'Explore Goa',
      ctaType: CtaType.hotel,
      ctaValue: 'h3',
      hotelId: 'h3',
      displayOrder: 3,
    ),

    // Offer Banners
    BannerModel(
      id: 'o1',
      title: 'Welcome Offer',
      subtitle: 'Save 20% on your first stay',
      imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&q=80&w=800',
      bannerType: BannerType.homeOffer,
      couponCode: 'WELCOME20',
      discount: 20.0,
      ctaText: 'Claim Now',
      ctaType: CtaType.search,
    ),
    BannerModel(
      id: 'o2',
      title: 'Weekend Special',
      subtitle: 'Flat 15% off on weekend bookings',
      imageUrl: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?auto=format&fit=crop&q=80&w=800',
      bannerType: BannerType.homeOffer,
      couponCode: 'WEEKEND15',
      discount: 15.0,
      ctaText: 'Book Weekend',
      ctaType: CtaType.weekend,
    ),

    // Promotional Banners
    BannerModel(
      id: 'p1',
      title: 'Family Getaways',
      subtitle: 'Creating memories together',
      description: 'Kid-friendly resorts with exclusive family packages.',
      imageUrl: 'https://images.unsplash.com/photo-1540553016722-983e48a2cd10?auto=format&fit=crop&q=80&w=800',
      bannerType: BannerType.homePromotion,
      ctaText: 'View Resorts',
      ctaType: CtaType.family,
    ),
    BannerModel(
      id: 'p2',
      title: 'Romantic Getaways',
      subtitle: 'Unforgettable moments for two',
      description: 'Handpicked romantic retreats with dinner under the stars.',
      imageUrl: 'https://images.unsplash.com/photo-1516541196182-6bdb0516ed27?auto=format&fit=crop&q=80&w=800',
      bannerType: BannerType.homePromotion,
      ctaText: 'Explore Romantic Stays',
      ctaType: CtaType.search,
    ),

    // Destination Banners
    BannerModel(
      id: 'd_b1',
      title: 'Udaipur',
      subtitle: 'The City of Lakes',
      imageUrl: 'https://images.unsplash.com/photo-1590050752117-23a9d7fc21a7?q=80&w=800',
      bannerType: BannerType.destination,
      ctaText: 'Explore',
      ctaType: CtaType.destination,
      ctaValue: 'd1',
      destinationId: 'd1',
    ),
    BannerModel(
      id: 'd_b2',
      title: 'Goa',
      subtitle: 'Beach Paradise',
      imageUrl: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?q=80&w=800',
      bannerType: BannerType.destination,
      ctaText: 'Explore',
      ctaType: CtaType.destination,
      ctaValue: 'd2',
      destinationId: 'd2',
    ),
  ];

  static final List<DestinationModel> destinations = [
    DestinationModel(id: 'd1', name: 'Udaipur', imageUrl: 'https://images.unsplash.com/photo-1590050752117-23a9d7fc21a7?q=80&w=400', description: 'The City of Lakes', hotelCount: 120),
    DestinationModel(id: 'd2', name: 'Goa', imageUrl: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?q=80&w=400', description: 'Sun, Sand, and Sea', hotelCount: 450),
    DestinationModel(id: 'd3', name: 'Jaipur', imageUrl: 'https://images.unsplash.com/photo-1599661046289-e31897846e41?q=80&w=400', description: 'The Pink City', hotelCount: 200),
    DestinationModel(id: 'd4', name: 'Manali', imageUrl: 'https://images.unsplash.com/photo-1594838670678-752a78f8049a?q=80&w=400', description: 'The Valley of the Gods', hotelCount: 180),
    DestinationModel(id: 'd5', name: 'Munnar', imageUrl: 'https://images.unsplash.com/photo-1516690553959-71a414d6b9b6?q=80&w=400', description: 'Tea gardens and misty mountains', hotelCount: 150),
    DestinationModel(id: 'd6', name: 'Mumbai', imageUrl: 'https://images.unsplash.com/photo-1566550944183-f72401572979?q=80&w=400', description: 'The City of Dreams', hotelCount: 500),
    DestinationModel(id: 'd7', name: 'Delhi', imageUrl: 'https://images.unsplash.com/photo-1587474260584-136574528ed5?q=80&w=400', description: 'The Capital City', hotelCount: 400),
    DestinationModel(id: 'd8', name: 'Varanasi', imageUrl: 'https://images.unsplash.com/photo-1561361513-2d000a50f0dc?q=80&w=400', description: 'The Spiritual Capital', hotelCount: 90),
    DestinationModel(id: 'd9', name: 'Shimla', imageUrl: 'https://images.unsplash.com/photo-1597074866923-dc0589150358?q=80&w=400', description: 'The Queen of Hills', hotelCount: 140),
    DestinationModel(id: 'd10', name: 'Kochi', imageUrl: 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?q=80&w=400', description: 'Queen of the Arabian Sea', hotelCount: 160),
  ];

  static List<HotelModel> get hotels => _generateHotels();

  static final List<String> _hotelImages = [
    'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?q=80&w=800',
    'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=800',
    'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=800',
    'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?q=80&w=800',
    'https://images.unsplash.com/photo-1598091383021-15ddea10925d?q=80&w=800',
    'https://images.unsplash.com/photo-1590490360182-c33d57733427?q=80&w=800',
    'https://images.unsplash.com/photo-1561501900-3701fa6a0864?q=80&w=800',
    'https://images.unsplash.com/photo-1551882547-ff43c630f5e1?q=80&w=800',
    'https://images.unsplash.com/photo-1445019980597-93fa8acb246c?q=80&w=800',
    'https://images.unsplash.com/photo-1571896349842-33c89424de2d?q=80&w=800',
  ];

  static List<HotelModel> _generateHotels() {
    List<HotelModel> list = [];
    final amenities = ['wifi', 'pool', 'spa', 'restaurant', 'gym', 'parking', 'ac', 'breakfast'];

    final hotelNames = [
      'The Grand Royal Heritage',
      'Azure Bay Resort',
      'Pineview Mountain Retreat',
      'Luxora Palace & Spa',
      'Crystal Waters Boutique',
      'The Oberoi Heights',
      'Taj Majestic Suites',
      'Emerald Gardens Villa',
      'Sapphire Sands Resort',
      'Mist & Meadows Inn'
    ];

    for (int i = 1; i <= 40; i++) {
      final dest = destinations[(i - 1) % destinations.length];
      final isFeatured = i <= 6;
      final namePrefix = hotelNames[(i - 1) % hotelNames.length];

      list.add(HotelModel(
        id: 'h$i',
        name: i == 1 ? 'The Oberoi Udaivilas' : i == 2 ? 'Taj Lake Palace' : '$namePrefix, ${dest.name}',
        description: 'Experience the pinnacle of luxury at ${dest.name}. Our property offers breathtaking views, award-winning dining, and personalized service that anticipates your every need. Whether you\'re here for a romantic getaway or a family vacation, we provide an oasis of calm and sophistication.',
        address: 'MG Road Sector $i, ${dest.name}',
        city: dest.name,
        destinationId: dest.id,
        rating: 4.5 + (i % 5) / 10,
        reviewCount: 200 + i * 35,
        starRating: 4 + (i % 2),
        images: [
          _hotelImages[(i - 1) % _hotelImages.length],
          _hotelImages[i % _hotelImages.length],
          _hotelImages[(i + 1) % _hotelImages.length],
        ],
        amenities: (List.of(amenities)..shuffle()).take(6).toList(),
        rooms: _generateRooms('h$i', 8000 + (i % 12) * 2500),
        reviews: _generateReviews('h$i'),
        latitude: 20.0 + i * 0.12,
        longitude: 70.0 + i * 0.08,
        isFeatured: isFeatured,
      ));
    }
    return list;
  }

  static List<RoomModel> _generateRooms(String hotelId, double basePrice) {
    return [
      RoomModel(
        id: '\${hotelId}_r1',
        name: 'Deluxe Garden View',
        description: 'Elegantly appointed room with premium bedding and a private balcony overlooking our lush gardens.',
        images: ['https://images.unsplash.com/photo-1611892440504-42a792e24d32?q=80&w=600'],
        pricePerNight: basePrice,
        maxOccupancy: 2,
        bedType: 'Queen Bed',
        roomSize: 400,
        amenities: ['Wi-Fi', 'AC', 'Mini Bar', 'Coffee Maker'],
      ),
      RoomModel(
        id: '\${hotelId}_r2',
        name: 'Premium Lake View',
        description: 'Spacious suite featuring panoramic views, a separate living area, and a luxurious marble bathroom.',
        images: ['https://images.unsplash.com/photo-1618773928121-c32242e63f39?q=80&w=600'],
        pricePerNight: basePrice * 1.4,
        maxOccupancy: 3,
        bedType: 'King Bed',
        roomSize: 650,
        amenities: ['Wi-Fi', 'AC', 'Mini Bar', 'Bathtub', 'Balcony', '24/7 Room Service'],
      ),
      RoomModel(
        id: '\${hotelId}_r3',
        name: 'Luxora Royal Suite',
        description: 'Our most exclusive offering with butler service, private plunge pool, and the finest amenities.',
        images: ['https://images.unsplash.com/photo-1590490360182-c33d57733427?q=80&w=600'],
        pricePerNight: basePrice * 2.5,
        maxOccupancy: 4,
        bedType: 'Grand King Bed',
        roomSize: 1200,
        amenities: ['Wi-Fi', 'AC', 'Mini Bar', 'Bathtub', 'Plunge Pool', 'Butler Service'],
      ),
    ];
  }

  static List<ReviewModel> _generateReviews(String hotelId) {
    final reviewers = [
      {'name': 'Amit Malhotra', 'img': 'https://i.pravatar.cc/150?u=a1'},
      {'name': 'Sarah Jenkins', 'img': 'https://i.pravatar.cc/150?u=s2'},
      {'name': 'Priya Deshmukh', 'img': 'https://i.pravatar.cc/150?u=p3'},
      {'name': 'David Chen', 'img': 'https://i.pravatar.cc/150?u=d4'},
      {'name': 'Elena Rossi', 'img': 'https://i.pravatar.cc/150?u=e5'}
    ];

    final comments = [
      'The attention to detail here is unmatched. From the welcome drink to the turndown service, everything was perfect.',
      'Breathtaking views and exceptionally friendly staff. The breakfast spread was the highlight of our stay.',
      'A true sanctuary of peace. The spa treatments were world-class. Highly recommended for couples.',
      'Perfect for business travel. High-speed internet and a very quiet work environment in the room.',
      'We stayed for a week and didn\'t want to leave. The hospitality made us feel like royalty.'
    ];

    return List.generate(reviewers.length, (index) {
      return ReviewModel(
        id: '\${hotelId}_rev_\$index',
        userId: 'u\$index',
        userName: reviewers[index]['name']!,
        userImageUrl: reviewers[index]['img']!,
        rating: 4.5 + (index % 2 == 0 ? 0.5 : 0.0),
        comment: comments[index],
        date: DateTime.now().subtract(Duration(days: index * 3 + 2)),
      );
    });
  }
}
