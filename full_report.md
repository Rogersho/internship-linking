# InternLink: Technical Project Report

## 1. Executive Summary
**InternLink** is a modern, premium internship management platform designed to bridge the gap between students seeking opportunities and organizations looking for talent. Built with **Flutter** and **Supabase**, the application features a cinematic user interface, high-performance architecture, and a robust backend security model.

---

## 2. Core Architecture & Tech Stack
The app follows a **feature-first layer architecture** to ensure scalability and maintainability.

- **Frontend**: Flutter (3.x)
- **State Management**: Riverpod (for reactive data binding and dependency injection)
- **Routing**: GoRouter (declarative routing with role-based guards)
- **Backend**: Supabase (PostgreSQL, Auth, RLS)
- **Design Language**: Modern SaaS-style with **Plus Jakarta Sans** typography and glassmorphic elements.

---

## 3. Design System & Theming
The design system is engineered for visual excellence and accessibility across all lighting conditions.

### Highlights:
- **Typography**: Utilizing **Plus Jakarta Sans** for a professional yet approachable aesthetic.
- **Adaptive UI**: A high-contrast palette ensures 100% visibility in both **Light** and **Dark** modes.
- **Micro-interactions**: Subtle shadows and smooth transitions provide a premium feel.

```dart
// Theme Fragment from AppTheme
static const Color primaryLight = Color(0xFF4F46E5); // Indigo 600
static const Color textDarkPrimary = Color(0xFFF8FAFC);

static final darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF818CF8), // Vibrant Indigo for Dark Mode
    surface: Color(0xFF0F172A), // Deep Navy
  ),
);
```

---

## 4. Functional Modules

### A. Student Portal (Explore & Track)
Students can browse internships anonymously but must use a **Registration Number** to track their application status.
- **Slick Internship Cards**: Real-time filtering and search.
- **Status Tracker**: A dedicated portal to check "Accepted", "Rejected", or "Pending" states.

### B. Company Portal (Dashboard)
A comprehensive management suite for recruiters.
- **CRUD Operations**: Post, edit, and delete internship listings.
- **Candidate Management**: View all applications, contact details, and update application statuses instantly.

---

## 5. Security & Backend (Supabase)
InternLink leverages **Row Level Security (RLS)** to protect data.

- **Public Access**: Students can view all active internships via public policies.
- **Private Access**: Only authenticated company owners can view or modify their specific listings and applications.
- **Relational Integrity**: Uses PostgreSQL triggers to automatically synchronize auth users with company profiles.

```sql
-- RLS Policy Example
CREATE POLICY "Companies can manage their own internships" 
ON internships FOR ALL 
USING (auth.uid() = company_id);
```

---

## 6. Key UI Components
We built a library of "Common Widgets" to maintain consistency:
- **`CustomTextField`**: Handles validation, obscure text, and modern icons.
- **`PrimaryButton`**: A reusable, brand-consistent button with built-in loading states.

```dart
// Reusable Primary Button with Loading State
class PrimaryButton extends StatelessWidget {
  final bool isLoading;
  final String text;
  
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading ? CircularProgressIndicator() : Text(text),
    );
  }
}
```

---

## 7. Conclusion
InternLink stands as a state-of-the-art solution for modern recruitment. By combining a **premium design language** with the power of **Supabase**, the application delivers a seamless experience for both students and organizations, ready for production-level deployment.
