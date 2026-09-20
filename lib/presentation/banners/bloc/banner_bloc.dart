import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/banner_model.dart';
import '../../../domain/repositories/banner_repository.dart';

// Events
abstract class BannerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadBanners extends BannerEvent {
  final BannerType? type;
  LoadBanners({this.type});

  @override
  List<Object?> get props => [type];
}

// States
abstract class BannerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BannerInitial extends BannerState {}
class BannerLoading extends BannerState {}
class BannersLoaded extends BannerState {
  final List<BannerModel> banners;
  BannersLoaded(this.banners);

  @override
  List<Object?> get props => [banners];
}
class BannerError extends BannerState {
  final String message;
  BannerError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final BannerRepository bannerRepository;

  BannerBloc({required this.bannerRepository}) : super(BannerInitial()) {
    on<LoadBanners>((event, emit) async {
      emit(BannerLoading());
      try {
        final banners = await bannerRepository.getBanners(type: event.type);
        emit(BannersLoaded(banners));
      } catch (e) {
        emit(BannerError(e.toString()));
      }
    });
  }
}
