import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../common/domain/models.dart';

part 'student_repository.g.dart';

@riverpod
StudentRepository studentRepository(StudentRepositoryRef ref) {
  return StudentRepository(Supabase.instance.client);
}

class StudentRepository {
  final SupabaseClient _client;

  StudentRepository(this._client);

  Future<List<Internship>> getInternships({String? query}) async {
    final box = Hive.box('cache');
    try {
      var builder = _client
          .from('internships')
          .select('*, companies(*)')
          .eq('is_active', true);

      // Simple text search if query provided
      if (query != null && query.isNotEmpty) {
        builder = builder.ilike('title', '%$query%');
      }

      final data = await builder.order('created_at', ascending: false);
      final list = (data as List).map((e) => Internship.fromMap(e)).toList();

      // Cache success result (only if full list / no query, to keep logic simple, or cache everything?)
      // Use query as key? For simplicity, we only cache the main list (query == null)
      if (query == null || query.isEmpty) {
        box.put('internships', data);
      }

      return list;
    } catch (e) {
      // Offline fallback
      if (query == null || query.isEmpty) {
        final cached = box.get('internships');
        if (cached != null) {
          return (cached as List)
              .map((e) => Internship.fromMap(e))
              .cast<Internship>()
              .toList();
        }
      }
      rethrow;
    }
  }

  Future<void> applyForInternship(Application application) async {
    try {
      // 1. Check if already applied
      final existing = await _client
          .from('applications')
          .select('*')
          .eq('internship_id', application.internshipId)
          .eq('registration_number', application.registrationNumber)
          .maybeSingle();

      if (existing != null) {
        throw 'Already applied: You have already submitted an application for this internship using registration number ${application.registrationNumber}.';
      }
    } catch (e) {
      // If it's our custom string error, rethrow it. Otherwise, it might be a DB error (e.g. column missing)
      if (e is String) rethrow;
      // If it's a different error, we'll continue and let the insert fail if there's a real issue,
      // but logging it can help debug.
      print('Check existing application error: $e');
    }

    final userId = _client.auth.currentUser?.id;
    final map = application.toMap();
    if (userId != null) {
      map['student_id'] = userId;
    }

    await _client.from('applications').insert(map);
  }

  Future<List<Application>> getMyApplications() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final data = await _client
        .from('applications')
        .select(
            '*, internships(*, companies(*))') // Fetch internship details and company details
        .eq('student_id', userId)
        .order('created_at', ascending: false);

    return (data as List).map((e) => Application.fromMap(e)).toList();
  }
}
