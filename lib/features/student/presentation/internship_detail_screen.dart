import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/domain/models.dart';
import '../../common/widgets/common_widgets.dart';
import '../data/student_repository.dart';
import 'providers.dart';

class InternshipDetailScreen extends ConsumerWidget {
  final Internship internship;

  const InternshipDetailScreen({super.key, required this.internship});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: internship.company?.logoUrl != null
                        ? Image.network(internship.company!.logoUrl!)
                        : Icon(Icons.business_rounded,
                            size: 40, color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    internship.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    internship.company?.name ?? 'Unknown Company',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _DetailBadge(
                          icon: Icons.location_on_rounded,
                          label: internship.location ?? 'Remote'),
                      _DetailBadge(
                          icon: Icons.schedule_rounded,
                          label: internship.duration ?? 'Not set'),
                      _DetailBadge(
                          icon: Icons.calendar_today_rounded,
                          label:
                              'Till ${internship.deadline?.toString().split(' ')[0] ?? 'Open'}'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text('Description',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    internship.description,
                    style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: 24),
                  const Text('Requirements',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    internship.requirements ?? 'None specified',
                    style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: 100), // Space for FAB
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, -5)),
          ],
        ),
        child: PrimaryButton(
          text: 'Apply for this Role',
          onPressed: () => _showApplicationDialog(context, ref, internship.id),
        ),
      ),
    );
  }

  void _showApplicationDialog(
      BuildContext context, WidgetRef ref, String internshipId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: ApplicationForm(internshipId: internshipId),
      ),
    );
  }
}

class _DetailBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _DetailBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}

class ApplicationForm extends ConsumerStatefulWidget {
  final String internshipId;
  const ApplicationForm({super.key, required this.internshipId});

  @override
  ConsumerState<ApplicationForm> createState() => _ApplicationFormState();
}

class _ApplicationFormState extends ConsumerState<ApplicationForm> {
  final _formKey = GlobalKey<FormState>();
  // Fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _regNumController =
      TextEditingController(); // Registration Number for tracking
  final _uniController = TextEditingController();
  final _courseController = TextEditingController();
  final _motivationController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _regNumController.dispose();
    _uniController.dispose();
    _courseController.dispose();
    _motivationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      try {
        final app = Application(
          id: '',
          internshipId: widget.internshipId,
          studentName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          university: _uniController.text.trim(),
          course: _courseController.text.trim(),
          motivation: _motivationController.text.trim(),
          registrationNumber: _regNumController.text.trim(),
          status: 'under_review',
          createdAt: DateTime.now(),
        );

        await ref.read(studentRepositoryProvider).applyForInternship(app);

        if (mounted) {
          Navigator.of(context).pop(); // Close bottom sheet
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Application Submitted! Use registration number ${_regNumController.text} to track status.'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 5),
            ),
          );
          // Refresh applications list
          ref.invalidate(studentApplicationsProvider);
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = e.toString().replaceAll('Exception: ', '');
          });
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Apply for Internship',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
              CustomTextField(
                  label: 'Full Name',
                  controller: _nameController,
                  validator: (v) => v?.isNotEmpty == true ? null : 'Required'),
              const SizedBox(height: 16),
              CustomTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      v?.contains('@') == true ? null : 'Invalid Email'),
              const SizedBox(height: 16),
              CustomTextField(
                  label: 'Phone',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Registration Number (for tracking)',
                controller: _regNumController,
                validator: (v) => v?.isNotEmpty == true
                    ? null
                    : 'Required for tracking your application',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                  label: 'University',
                  controller: _uniController,
                  validator: (v) => v?.isNotEmpty == true ? null : 'Required'),
              const SizedBox(height: 16),
              CustomTextField(
                  label: 'Course',
                  controller: _courseController,
                  validator: (v) => v?.isNotEmpty == true ? null : 'Required'),
              const SizedBox(height: 16),
              CustomTextField(
                  label: 'Motivation Statement',
                  controller: _motivationController,
                  /* maxLines: 4 */ validator: (v) =>
                      v?.isNotEmpty == true ? null : 'Required'),
              const SizedBox(height: 24),
              PrimaryButton(
                  text: 'Submit Application',
                  onPressed: _submit,
                  isLoading: _isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
