import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/common_widgets.dart';
import '../data/company_repository.dart';
import '../domain/models.dart';
import 'providers.dart';

class InternshipFormScreen extends ConsumerStatefulWidget {
  final Internship? internship;
  const InternshipFormScreen({super.key, this.internship});

  @override
  ConsumerState<InternshipFormScreen> createState() =>
      _InternshipFormScreenState();
}

class _InternshipFormScreenState extends ConsumerState<InternshipFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _reqController;
  late final TextEditingController _durationController;
  late final TextEditingController _locationController;
  DateTime? _deadline;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.internship?.title);
    _descController =
        TextEditingController(text: widget.internship?.description);
    _reqController =
        TextEditingController(text: widget.internship?.requirements);
    _durationController =
        TextEditingController(text: widget.internship?.duration);
    _locationController =
        TextEditingController(text: widget.internship?.location);
    _deadline = widget.internship?.deadline;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _reqController.dispose();
    _durationController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final internship = Internship(
          id: widget.internship?.id ?? '',
          companyId: widget.internship?.companyId ?? 'PLACEHOLDER',
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          requirements: _reqController.text.trim(),
          duration: _durationController.text.trim(),
          location: _locationController.text.trim(),
          deadline: _deadline,
          createdAt: widget.internship?.createdAt ?? DateTime.now(),
        );

        if (widget.internship != null) {
          await ref
              .read(companyRepositoryProvider)
              .updateInternship(internship);
        } else {
          await ref
              .read(companyRepositoryProvider)
              .createInternship(internship);
        }

        // Refresh the list
        ref.invalidate(myInternshipsProvider);

        if (mounted) context.pop();
      } catch (e) {
        if (mounted)
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.internship != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modify Internship' : 'Create New Posting'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Role Details',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              CustomTextField(
                  label: 'Job Title',
                  controller: _titleController,
                  validator: (v) => v?.isNotEmpty == true ? null : 'Required'),
              const SizedBox(height: 20),
              CustomTextField(
                  label: 'Full Description',
                  controller: _descController,
                  /* maxLines: 5, */
                  validator: (v) => v?.isNotEmpty == true ? null : 'Required'),
              const SizedBox(height: 20),
              CustomTextField(
                  label: 'Key Requirements', controller: _reqController),
              const SizedBox(height: 32),
              Text('Logistics',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              CustomTextField(
                  label: 'Duration (e.g. 3 Months)',
                  controller: _durationController),
              const SizedBox(height: 20),
              CustomTextField(
                  label: 'Location (City or Remote)',
                  controller: _locationController),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: Text(
                    _deadline == null
                        ? 'Set Application Deadline'
                        : 'Closing Date: ${_deadline!.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(
                      color: _deadline == null
                          ? const Color(0xFF64748B)
                          : Colors.black,
                      fontWeight: _deadline == null
                          ? FontWeight.normal
                          : FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(Icons.calendar_month_rounded,
                      color: Theme.of(context).primaryColor),
                  onTap: () async {
                    final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2027),
                        initialDate: _deadline ?? DateTime.now());
                    if (picked != null) setState(() => _deadline = picked);
                  },
                ),
              ),
              const SizedBox(height: 48),
              PrimaryButton(
                  text: isEditing ? 'Save Changes' : 'Publish Internship',
                  onPressed: _submit,
                  isLoading: _isLoading),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
