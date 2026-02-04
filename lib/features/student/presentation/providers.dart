import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../common/domain/models.dart';
import '../data/student_repository.dart';

part 'providers.g.dart';

@riverpod
Future<List<Internship>> availableInternships(AvailableInternshipsRef ref,
    {String? query}) async {
  return ref.read(studentRepositoryProvider).getInternships(query: query);
}

@riverpod
Future<List<Application>> studentApplications(
    StudentApplicationsRef ref) async {
  return ref.read(studentRepositoryProvider).getMyApplications();
}
