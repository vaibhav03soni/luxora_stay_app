import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/services/auth_service.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  RegisterRequested(this.email, this.password, this.name);
}

class SendOtpRequested extends AuthEvent {
  final String identifier;
  SendOtpRequested(this.identifier);
}

class VerifyOtpRequested extends AuthEvent {
  final String identifier;
  final String otp;
  VerifyOtpRequested(this.identifier, this.otp);
}

class LogoutRequested extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSent extends AuthState {
  final String identifier;
  OtpSent(this.identifier);
  @override
  List<Object?> get props => [identifier];
}

class Authenticated extends AuthState {
  final String email;
  Authenticated(this.email);
  @override
  List<Object?> get props => [email];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final credential = await authService.login(event.email, event.password);
        if (credential != null) {
          emit(Authenticated(event.email));
        } else {
          emit(AuthError('Authentication failed: Firebase not initialized or invalid credentials'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final credential = await authService.register(event.email, event.password, event.name);
        if (credential != null) {
          // In a production flow, we might send OTP here.
          // For now, let's trigger OtpSent to demonstrate the flow.
          await authService.sendOtp(event.email);
          emit(OtpSent(event.email));
        } else {
          emit(AuthError('Registration failed: The service returned no user credentials.'));
        }
      } catch (e) {
        emit(AuthError('Registration error: $e'));
      }
    });

    on<SendOtpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authService.sendOtp(event.identifier);
        emit(OtpSent(event.identifier));
      } catch (e) {
        emit(AuthError('Failed to send OTP: $e'));
      }
    });

    on<VerifyOtpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final isValid = await authService.verifyOtp(event.identifier, event.otp);
        if (isValid) {
          // If OTP is valid, we consider them authenticated for this demo
          // In real life, we'd complete the Firebase Phone Auth or similar
          final email = authService.currentUser?.email ?? event.identifier;
          emit(Authenticated(email));
        } else {
          emit(AuthError('Invalid OTP. Please try again.'));
        }
      } catch (e) {
        emit(AuthError('Verification error: $e'));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await authService.logout();
      emit(Unauthenticated());
    });
  }
}
