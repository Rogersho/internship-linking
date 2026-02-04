import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/company_repository.dart';
import '../domain/models.dart';

part 'providers.g.dart';

@riverpod
Future<List<Internship>> myInternships(MyInternshipsRef ref) async {
  return ref.read(companyRepositoryProvider).getMyInternships();
}

@riverpod
Future<List<Application>> myApplications(MyApplicationsRef ref) async {
  return ref.read(companyRepositoryProvider).getAllReceivedApplications();
}

@riverpod
Future<CompanyProfile?> companyProfile(CompanyProfileRef ref) async {
  return ref.read(companyRepositoryProvider).getProfile();
}
