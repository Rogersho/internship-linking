# InternLink

InternLink is a Flutter application connecting Students and Companies for internship opportunities.

## Features

- **Authentication**: Role-based login (Company/Student) using Supabase Auth.
- **Company Dashboard**: Post internships, manage applications, view profile.
- **Student Portal**: Browse internships, filter/search, apply with one click.
- **Offline Support**: Caches internships for offline viewing using Hive.
- **Realtime Updates**: Built on Supabase for instant data availability.

## Setup

### 1. Prerequisites
- Flutter SDK (Latest Stable)
- Supabase Project

### 2. Supabase Setup
1. Create a new Supabase project.
2. Run the SQL script provided in `supabase_schema.sql` in the Supabase SQL Editor to create tables and policies.
3. Enable Email/Password Auth provider in Supabase.
4. (Optional) Create Storage buckets `company_logos` and `documents` as defined in the schema.

### 3. App Configuration
1. Open `lib/constants.dart`.
2. Replace `supabaseUrl` and `supabaseAnonKey` with your project credentials.

```dart
static const String supabaseUrl = 'YOUR_URL';
static const String supabaseAnonKey = 'YOUR_ANON_KEY';
```

### 4. Running the App
```bash
flutter pub get
flutter run
```

## Architecture
This project follows a Clean Architecture using Riverpod for state management and GoRouter for navigation.
- `lib/features/`: Feature-based modules (Auth, Company, Student).
- `lib/core/`: Shared utilities, theme, router.
- `lib/common/`: Shared domain models and widgets.

## Testing
See `TESTING_GUIDE.md` for instructions on how to test the application workflows.
