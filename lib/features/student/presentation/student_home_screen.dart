import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../auth/data/auth_repository.dart';
import 'providers.dart';
import '../../common/domain/models.dart';

class StudentHomeScreen extends ConsumerStatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  ConsumerState<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends ConsumerState<StudentHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ExploreTab(),
    MyApplicationsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final authRepo = ref.watch(authRepositoryProvider);
    final isLoggedIn = authRepo.currentUser != null;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome to',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
            Text('InternLink',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: -0.5)),
          ],
        ),
        actions: [
          if (isLoggedIn)
            Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12)),
              child: IconButton(
                icon: Icon(Icons.logout_rounded,
                    color: Colors.red.shade400, size: 20),
                onPressed: () =>
                    ref.read(authControllerProvider.notifier).signOut(),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: TextButton.icon(
                icon: const Icon(Icons.business_center_rounded, size: 18),
                label: const Text('Partner Login',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => context.push('/login'),
              ),
            ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          elevation: 0,
          onDestinationSelected: (index) =>
              setState(() => _currentIndex = index),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.explore_rounded), label: 'Explore'),
            NavigationDestination(
                icon: Icon(Icons.track_changes_rounded), label: 'Tracker'),
          ],
        ),
      ),
    );
  }
}

class ExploreTab extends ConsumerStatefulWidget {
  const ExploreTab({super.key});

  @override
  ConsumerState<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends ConsumerState<ExploreTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final internshipsAsync =
        ref.watch(availableInternshipsProvider(query: _searchController.text));

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find your dream\ninternship',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        letterSpacing: -1,
                      ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search roles or companies...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.tune_rounded),
                      onPressed: () {},
                    ),
                  ),
                  onChanged: (v) => setState(() {}),
                  onSubmitted: (_) => setState(() {}),
                ),
                const SizedBox(height: 24),
                Text(
                  'Featured Internships',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        internshipsAsync.when(
          data: (internships) {
            if (internships.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                    child: Text('No internships found.',
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant))),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      InternshipCard(internship: internships[index]),
                  childCount: internships.length,
                ),
              ),
            );
          },
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, stack) => SliverFillRemaining(
            child: Center(
                child: Text('Error: $err',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error))),
          ),
        ),
      ],
    );
  }
}

class InternshipCard extends StatelessWidget {
  final Internship internship;
  const InternshipCard({super.key, required this.internship});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => context.push('/student/internship/${internship.id}',
            extra: internship),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: internship.company?.logoUrl != null
                        ? Image.network(internship.company!.logoUrl!)
                        : Icon(Icons.business_rounded,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          internship.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          internship.company?.name ?? 'Unknown Company',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (internship.location != null)
                    _Tag(
                        icon: Icons.location_on_rounded,
                        label: internship.location!),
                  if (internship.duration != null)
                    _Tag(
                        icon: Icons.schedule_rounded,
                        label: internship.duration!),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Tag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).primaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class MyApplicationsTab extends ConsumerStatefulWidget {
  const MyApplicationsTab({super.key});

  @override
  ConsumerState<MyApplicationsTab> createState() => _MyApplicationsTabState();
}

class _MyApplicationsTabState extends ConsumerState<MyApplicationsTab> {
  final _regNumController = TextEditingController();
  List<Application>? _trackedApplications;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _regNumController.dispose();
    super.dispose();
  }

  Future<void> _trackApplications() async {
    final regNum = _regNumController.text.trim();
    if (regNum.isEmpty) {
      setState(() => _errorMessage = 'Please enter your registration number');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final supabase = Supabase.instance.client;
      final data = await supabase
          .from('applications')
          .select('*, internships(*, companies(*))')
          .eq('registration_number', regNum)
          .order('created_at', ascending: false);

      setState(() {
        _trackedApplications =
            (data as List).map((e) => Application.fromMap(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Track Your\nApplications',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Keep an eye on your status by using your academic registration number.',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 15),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _regNumController,
            decoration: const InputDecoration(
              hintText: 'Registration Number',
              prefixIcon: Icon(Icons.badge_rounded),
            ),
            onSubmitted: (_) => _trackApplications(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _trackApplications,
            child: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.onPrimary),
                  )
                : const Text('Check Status'),
          ),
          const SizedBox(height: 32),
          if (_errorMessage != null) _ErrorAlert(message: _errorMessage!),
          if (_trackedApplications != null) ...[
            Text(
              '${_trackedApplications!.length} Applications found',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: 16),
            ..._trackedApplications!.map((app) => _TrackedAppCard(app: app)),
          ],
        ],
      ),
    );
  }
}

class _TrackedAppCard extends StatelessWidget {
  final Application app;
  const _TrackedAppCard({required this.app});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: Theme.of(context).disabledColor.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          app.internship?.title ?? 'Unknown Internship',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            app.internship?.company?.name ?? 'Unknown Company',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(app.status).withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            app.status.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: _getStatusColor(app.status),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return const Color(0xFF10B981);
      case 'rejected':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFFF59E0B);
    }
  }
}

class _ErrorAlert extends StatelessWidget {
  final String message;
  const _ErrorAlert({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.error_rounded, color: Colors.red.shade400),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message, style: TextStyle(color: Colors.red.shade900)),
          ),
        ],
      ),
    );
  }
}
