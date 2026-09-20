# Implementation Plan - Luxora Stay Transformation

This plan outlines the complete transformation of the Luxora Stay app into a premium, production-ready hotel booking platform.

## User Review Required

> [!IMPORTANT]
> The transformation involves replacing current placeholder UI with a high-fidelity "Deep Navy & Gold" luxury theme. Ensure the typography (Google Fonts) and iconography (Material + FontAwesome) meet your expectations for a "Premium" brand.

## Proposed Changes

### 1. Brand Identity & Foundation
- Update [app_colors.dart](file:///C:/luxora_stay_app/lib/core/constants/app_colors.dart) to Deep Navy (#001F3F) primary and Champagne Gold (#C5A059) secondary.
- Update [app_theme.dart](file:///C:/luxora_stay_app/lib/core/theme/app_theme.dart) for both Light and Dark modes.
- Implement `AppBootstrapService` for centralized initialization (Firebase, DI, Config).

### 2. Core Navigation & Home
- Create a `MainTabScaffold` with 5 tabs: Home, Explore, Trips, Wishlist, Profile.
- Redesign the Home Screen with a Hero search card, Promo carousels, and realistic hotel sections.

### 3. Search & Discovery
- Enhance Search with full filtering (price, rating, amenities) and sorting.
- Create the Explore tab with themed categories (Beach, Mountain, City).

### 4. Premium Hotel Details & Booking Flow
- Detailed Hotel view with image gallery, interactive maps (mock), and amenity icons.
- Multi-step booking: Room Selection -> Guest Details -> Review -> Payment.
- Mock Payment Gateway integration (Success/Fail flows).

### 5. Account & Persistence
- Auth flow (Login, Register, Guest) with validation.
- My Trips tab (Upcoming, Past, Cancelled).
- Profile management and Settings (Language/Currency/Theme).

### 6. Data & Content
- Large-scale realistic mock dataset (30+ Indian hotels) with professional images.
- Localization support (English & Hindi) and Skeleton loaders for every screen.

## Verification Plan

### Automated Tests
- Run `flutter test` on updated BLoCs and Services.
- Run `flutter analyze` to ensure zero warnings.

### Manual Verification
- Test all 52+ buttons for correct actions.
- Verify Dark mode legibility across all screens.
- Test the full booking flow from search to success animation.
