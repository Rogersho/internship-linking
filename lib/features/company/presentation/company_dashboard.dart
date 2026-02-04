import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers.dart';
import '../data/company_repository.dart';
import '../../auth/presentation/auth_controller.dart';
import '../domain/models.dart';
import 'internship_form_screen.dart';

class CompanyDashboard extends ConsumerStatefulWidget {
  const CompanyDashboard({super.key});

  @override
  ConsumerState<CompanyDashboard> createState() => _CompanyDashboardState();
}

class _CompanyDashboardState extends ConsumerState<CompanyDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    InternshipsTab(),
    ApplicationsTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company Panel',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
            Text(['My Internships', 'Applications', 'Profile'][_currentIndex],
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.logout_rounded,
                  color: Colors.red.shade400, size: 20),
              onPressed: () =>
                  ref.read(authControllerProvider.notifier).signOut(),
            ),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          elevation: 0,
          onDestinationSelected: (index) =>
              setState(() => _currentIndex = index),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.layers_rounded), label: 'Posts'),
            NavigationDestination(
                icon: Icon(Icons.people_alt_rounded), label: 'Talent'),
            NavigationDestination(
                icon: Icon(Icons.business_center_rounded), label: 'Office'),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/company/internship/new'),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Post New'),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }
}

class InternshipsTab extends ConsumerWidget {
  const InternshipsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final internshipsAsync = ref.watch(myInternshipsProvider);

    return internshipsAsync.when(
      data: (internships) {
        if (internships.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.post_add_rounded,
                    size: 64,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withOpacity(0.3)),
                const SizedBox(height: 16),
                Text('No internships posted yet',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: internships.length,
          itemBuilder: (context, index) {
            final internship = internships[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withOpacity(0.1)),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(internship.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(internship.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 13)),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ActionButton(
                      icon: Icons.edit_outlined,
                      color: Theme.of(context).primaryColor,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                InternshipFormScreen(internship: internship)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      icon: Icons.delete_outline_rounded,
                      color: Colors.red.shade400,
                      onPressed: () =>
                          _confirmDeleteInternship(context, ref, internship.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  void _confirmDeleteInternship(
      BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Internship?'),
        content: const Text(
            'This will delete all associated applications. This action is permanent.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              await ref.read(companyRepositoryProvider).deleteInternship(id);
              ref.invalidate(myInternshipsProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  const _ActionButton(
      {required this.icon, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}

class ApplicationsTab extends ConsumerWidget {
  const ApplicationsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(myApplicationsProvider);

    return applicationsAsync.when(
      data: (applications) {
        if (applications.isEmpty) {
          return Center(
              child: Text('No applications received yet.',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)));
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 16, 8),
              child: Row(
                children: [
                  Text('${applications.length} Candidates',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onSurface)),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () =>
                        _confirmDeleteAllApplications(context, ref),
                    icon: const Icon(Icons.delete_sweep_rounded,
                        color: Colors.red, size: 20),
                    label: const Text('Clear All',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: applications.length,
                itemBuilder: (context, index) {
                  final app = applications[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .withOpacity(0.1)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(app.studentName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(app.internship?.title ?? 'Unknown Role',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13)),
                          Text(app.university,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  fontSize: 12)),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _StatusBadge(status: app.status),
                          const Spacer(),
                          GestureDetector(
                            onTap: () =>
                                _confirmDeleteApplication(context, ref, app.id),
                            child: Icon(Icons.close_rounded,
                                size: 18,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant),
                          ),
                        ],
                      ),
                      onTap: () => _showStatusDialog(context, ref, app),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  void _showStatusDialog(BuildContext context, WidgetRef ref, Application app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Status'),
        content: Text('Update application status for ${app.studentName}?'),
        actions: [
          TextButton(
            onPressed: () async {
              await ref
                  .read(companyRepositoryProvider)
                  .updateApplicationStatus(app.id, 'rejected');
              ref.invalidate(myApplicationsProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Reject', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(companyRepositoryProvider)
                  .updateApplicationStatus(app.id, 'accepted');
              ref.invalidate(myApplicationsProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Accept', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteApplication(
      BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Application?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await ref.read(companyRepositoryProvider).deleteApplication(id);
              ref.invalidate(myApplicationsProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAllApplications(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete ALL Applications?'),
        content: const Text(
            'This will delete all applications for all your internships. This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await ref.read(companyRepositoryProvider).deleteAllApplications();
              ref.invalidate(myApplicationsProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child:
                const Text('Delete All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'accepted':
        color = const Color(0xFF10B981);
        break;
      case 'rejected':
        color = const Color(0xFFEF4444);
        break;
      default:
        color = const Color(0xFFF59E0B);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5),
      ),
    );
  }
}

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(companyProfileProvider);

    return profileAsync.when(
      data: (profile) {
        if (profile == null)
          return const Center(child: Text('Profile not found'));
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: profile.logoUrl != null
                    ? NetworkImage(profile.logoUrl!)
                    : null,
                child: profile.logoUrl == null
                    ? const Icon(Icons.business, size: 40)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(profile.name,
                  style: Theme.of(context).textTheme.headlineSmall),
              Text(profile.industry ?? 'Industry not set'),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Description'),
                subtitle: Text(profile.description ?? 'No description'),
              ),
              // TODO: Edit Profile Button
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
