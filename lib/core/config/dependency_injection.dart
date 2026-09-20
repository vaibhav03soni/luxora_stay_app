import 'package:get_it/get_it.dart';
import 'app_config.dart';
import '../../domain/repositories/hotel_repository.dart';
import '../../data/repositories/hotel_repository_impl.dart';

import '../../core/services/payment_service.dart';

import '../../core/services/auth_service.dart';

import '../../domain/repositories/wishlist_repository.dart';
import '../../data/repositories/wishlist_repository_impl.dart';
import '../../domain/repositories/banner_repository.dart';
import '../../data/repositories/banner_repository_impl.dart';
import '../../domain/repositories/booking/booking_repository.dart';
import '../../data/repositories/booking/booking_repository_impl.dart';
import '../services/firestore/firestore_service.dart';
import '../services/notification_service.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  // Services
  sl.registerLazySingleton<PaymentService>(() => MockPaymentService());
  sl.registerLazySingleton<NotificationService>(() => MockNotificationService());

  final bool useMock = AppConfig.isMock || (AppConfig.isAuto && !AppConfig.isFirebaseAvailable);

  if (useMock) {
    sl.registerLazySingleton<AuthService>(() => MockAuthService());
    // We don't register FirestoreService in Mock mode to avoid Firebase init errors
  } else {
    sl.registerLazySingleton<FirestoreService>(() => FirestoreService());
    sl.registerLazySingleton<AuthService>(() => FirebaseAuthService());
  }

  // Repositories
  if (useMock) {
    sl.registerLazySingleton<HotelRepository>(() => HotelRepositoryImpl());
    sl.registerLazySingleton<WishlistRepository>(() => WishlistRepositoryImpl());
    sl.registerLazySingleton<BannerRepository>(() => BannerRepositoryImpl());
    sl.registerLazySingleton<BookingRepository>(() => BookingRepositoryImpl());
  } else {
    sl.registerLazySingleton<HotelRepository>(() => HotelRepositoryImpl(firestoreService: sl()));
    sl.registerLazySingleton<WishlistRepository>(() => WishlistRepositoryImpl(firestoreService: sl()));
    sl.registerLazySingleton<BannerRepository>(() => BannerRepositoryImpl(firestoreService: sl()));
    sl.registerLazySingleton<BookingRepository>(() => BookingRepositoryImpl(firestoreService: sl()));
  }
}
