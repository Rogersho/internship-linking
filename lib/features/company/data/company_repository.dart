import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/models.dart';

part 'company_repository.g.dart';

@riverpod
CompanyRepository companyRepository(CompanyRepositoryRef ref) {
  return CompanyRepository(Supabase.instance.client);
}

class CompanyRepository {
  final SupabaseClient _client;

  CompanyRepository(this._client);

  String get _currentUserId => _client.auth.currentUser!.id;

  // Internships
  Future<void> createInternship(Internship internship) async {
    final map = internship.toMap();
    map['company_id'] = _currentUserId; // Enforce correct ID
    // Remove ID if empty so DB generates it
    if (internship.id.isEmpty) {
      map.remove('id');
    }
    await _client.from('internships').insert(map);
  }

  Future<List<Internship>> getMyInternships() async {
    final data = await _client
        .from('internships')
        .select()
        .eq('company_id', _currentUserId)
        .order('created_at', ascending: false);
    return (data as List).map((e) => Internship.fromMap(e)).toList();
  }

  Future<void> deleteInternship(String id) async {
    await _client.from('internships').delete().eq('id', id);
  }

  Future<void> updateInternship(Internship internship) async {
    final map = internship.toMap();
    map.remove('id'); // ID is the filter
    map.remove('company_id'); // Don't allow changing company
    await _client.from('internships').update(map).eq('id', internship.id);
  }

  // Applications
  Future<void> deleteApplication(String id) async {
    await _client.from('applications').delete().eq('id', id);
  }

  Future<void> deleteAllApplications() async {
    // This will be filtered by RLS to only those the company can access
    // But since RLS is currently "allow all" in reset script, we target by companyId if possible.
    // However, applications don't have company_id directly. We can filter by those linked to company's internships.

    // Get all my internship IDs first
    final internships = await getMyInternships();
    final ids = internships.map((i) => i.id).toList();

    if (ids.isNotEmpty) {
      await _client
          .from('applications')
          .delete()
          .inFilter('internship_id', ids);
    }
  }

  // Applications
  Future<List<Application>> getApplicationsForInternship(
      String internshipId) async {
    final data = await _client
        .from('applications')
        .select(
            '*, internships(*)') // proper join syntax? Supabase uses select('*, internship:internships(*)')
        .eq('internship_id', internshipId);

    // Note: If join syntax is tricky without relationship setup in dashboard, we assume standard foreign key inference
    return (data as List).map((e) => Application.fromMap(e)).toList();
  }

  // Actually, to get all applications for ANY of my internships:
  Future<List<Application>> getAllReceivedApplications() async {
    // This requires complex query or RLS filtering.
    // RLS policy: "Companies can view applications for their internships"
    // So technically checks against internship ownership.
    // We can just query applications directly, Supabase RLS will filter!

    final data = await _client
        .from('applications')
        .select('*, internships!inner(*)') // !inner compels the join
        .order('created_at', ascending: false);

    return (data as List).map((e) => Application.fromMap(e)).toList();
  }

  Future<void> updateApplicationStatus(String id, String status) async {
    await _client.from('applications').update({'status': status}).eq('id', id);
  }

  // Profile
  Future<CompanyProfile?> getProfile() async {
    final data = await _client
        .from('companies')
        .select()
        .eq('id', _currentUserId)
        .maybeSingle();
    if (data == null) return null;
    return CompanyProfile.fromMap(data);
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    await _client.from('companies').update(updates).eq('id', _currentUserId);
  }
}
