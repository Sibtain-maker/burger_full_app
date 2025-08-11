# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter food delivery app (burger_app_full) built with Supabase backend integration. The app features authentication, food browsing by categories, product details, and user profiles.

## Key Dependencies

- **supabase_flutter**: Backend services (authentication, database)
- **flutter_riverpod**: State management
- **iconsax**: Icon library
- **readmore**: Text expansion widget
- **image_picker**: Profile photo selection

## Development Commands

### Build & Run
```bash
flutter run                    # Run in debug mode
flutter run --release         # Run in release mode
flutter build apk             # Build Android APK
flutter build ios             # Build iOS (requires macOS)
```

### Testing & Analysis
```bash
flutter test                  # Run all tests
flutter test test/widget_test.dart  # Run specific test
flutter analyze              # Static analysis
dart fix --apply             # Auto-fix analysis issues
```

### Dependencies
```bash
flutter pub get              # Install dependencies
flutter pub upgrade          # Update dependencies
flutter clean                # Clean build files
```

## Architecture

### Authentication Flow
- Entry point checks authentication state via `Authcheck` widget in `main.dart`
- Unauthenticated users → `LoginScreen`
- Authenticated users → `AppMainScreen` (main navigation)
- Auth service in `lib/service/auth_service.dart` handles login/signup/logout

### Navigation Structure
- `AppMainScreen`: Bottom tab navigation with 4 tabs
  - Home (`FooodAppHomeScreen`)
  - Favorites (placeholder)
  - Profile (`ProfileScreen`) 
  - Cart (placeholder with counter badge)
- Floating search button overlay

### Data Models
- `FoodModel`: Product data with Supabase integration (`fromJson`/`toMap`)
- `CategoryModel`: Food categories with image/name
- `UserProfileModel`: User profile data with comprehensive fields
- Models located in `lib/Core/models/`

### Services
- `AuthService`: Authentication (login/signup/logout)
- `ProfileService`: User profile CRUD operations, favorites management, avatar upload

### Key Screens
- `foood_app_home_screen.dart`: Main food browsing interface
- `Food_detail_screen.dart`: Individual product details
- `view_all_screen.dart`: Category product listings
- `on_bordingscreen.dart`: App introduction
- `Profile_screen.dart`: Comprehensive user profile with sections
- `edit_profile_screen.dart`: Profile editing with image upload
- `favorites_screen.dart`: User's favorite products
- `order_history_screen.dart`: Past orders (mock data)
- Authentication screens in `lib/pages/auth/`

### Supabase Integration
- Database URL: `https://rpdnuahwiupkfhlpdlzt.supabase.co`
- Products and categories fetched from Supabase tables
- User profiles stored in `profiles` table with RLS
- User favorites in `user_favorites` table
- Avatar storage in `avatars` bucket
- Real-time auth state management via StreamBuilder
- Auto-profile creation on user signup

### Styling
- Constants in `lib/Core/Utils/const.dart`
- Color scheme: red (#f54748), orange (#fdc55e), grey tones
- Custom widgets in `lib/widgets/`

## Asset Structure
- Food images: `assets/food-delivery/product/`
- Category icons: `assets/food-delivery/`
- App icons: `assets/food-delivery/icon/`

## Testing
- Basic widget test in `test/widget_test.dart` (needs updating for actual app structure)
- Uses `flutter_test` package

## User Profile Features
- Complete profile management with personal info, contact details, location
- Profile photo upload with image picker
- Favorites system with product management
- Theme preferences (light/dark/system)
- Notification settings toggle
- Order history view (currently mock data)
- Settings sections: Account, Orders, App Settings, Support

## Database Setup
- Run SQL commands in `supabase_setup.md` to create required tables
- Tables: `profiles`, `user_favorites` 
- Storage bucket: `avatars` for profile photos
- RLS policies configured for user data security

## Notes
- App uses MaterialApp with debug banner disabled
- Supabase anon key is exposed in main.dart (consider environment variables for production)
- Order system not yet implemented (only mock data in order history)
- Some features marked as "Coming Soon" in profile settings