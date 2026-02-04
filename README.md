# InternLink 🚀

InternLink is a premium, feature-rich Flutter application designed to bridge the gap between students seeking internships and companies offering opportunities. Built with a focus on seamless user experience, real-time synchronization, and offline resilience.

---

## ✨ Key Features

### 👤 For Students
- **Smart Discovery**: Browse and search through curated internship listings.
- **One-Click Application**: Apply to multiple internships with your profile auto-filled.
- **Application Tracking**: Monitor the status of your applications in real-time.
- **Offline Access**: View saved and recent internships even without an internet connection.

### 🏢 For Companies
- **Dashboard Overview**: Manage all active internship postings from a central hub.
- **Vacancy Management**: Create, edit, and close internship opportunities easily.
- **Applicant Review**: Review student profiles, motivations, and contact details.
- **Branding**: Customize company profile with logos and descriptions.

### 🛠 Technical Highlights
- **Role-Based Auth**: Secure authentication flows for both Students and Companies.
- **Real-time Sync**: Instant updates using Supabase's real-time capabilities.
- **Offline First**: Local caching powered by Hive.
- **Responsive UI**: Beautifully crafted with Flutter Animate and Google Fonts.

---

## 🚀 Getting Started

Follow these steps to get your local development environment up and running.

### 1. Prerequisites
- **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install) (Stable channel recommended).
- **Supabase Account**: Sign up at [supabase.com](https://supabase.com).
- **IDE**: VS Code (with Flutter extension) or Android Studio.

### 2. Supabase Configuration
InternLink uses Supabase as its backend.
1. **Create Project**: Start a new project in your Supabase dashboard.
2. **Database Setup**:
   - Go to the **SQL Editor** in your Supabase dashboard.
   - Copy the contents of `schema.sql` from the root of this project.
   - Run the script. This will create all necessary tables, triggers, and storage buckets.
3. **Authentication**:
   - Enable **Email/Password** provider in `Authentication -> Providers`.
4. **Storage**:
   - Ensure `company_logos` (public) and `documents` (private) buckets are created (the SQL script should handle this).

### 3. Local Setup
1. **Clone the repository**:
   ```bash
   git clone https://github.com/Rogersho/internship-linking.git
   cd internship-linking
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Configure Environment**:
   - Open `lib/constants.dart`.
   - Update `supabaseUrl` and `supabaseAnonKey` with your project's credentials found in `Project Settings -> API`.

4. **Generate Code**:
   This project uses `riverpod_generator`. Run the builder:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

### 4. Running the App
```bash
flutter run
```

---

## 🏗 Architecture

The project follows **Clean Architecture** principles to ensure scalability and maintainability.

- **`lib/features/`**: Contains domain-driven modules (Auth, Company, Student). Each feature has its own `presentation`, `data`, and `domain` layers.
- **`lib/core/`**: Shared utilities, theme definitions, and global router configuration.
- **`lib/common/`**: Reusable widgets and models shared across the entire app.
- **State Management**: Orchestrated by **Riverpod** for robust and testable states.
- **Navigation**: Structured using **GoRouter**.

---

## 🧪 Testing

We value stability. To run the test suite:
```bash
flutter test
```
Detailed technical breakdowns and architectural insights can be found in `full_report.md`.

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

*Developed with ❤️ by the InternLink Team.*
