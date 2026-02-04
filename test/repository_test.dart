import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:internlink/features/company/data/company_repository.dart';
import 'package:internlink/features/common/domain/models.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class MockPostgrestFilterBuilder extends Mock
    implements PostgrestFilterBuilder {
  @override
  Future<R> then<R>(FutureOr<R> Function(dynamic) onValue,
      {Function? onError}) {
    // Return empty list as success result
    return Future.value([]).then(onValue as dynamic, onError: onError);
  }
}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

void main() {
  late MockSupabaseClient mockSupabaseClient;
  late CompanyRepository companyRepository;
  late MockGoTrueClient mockAuth;
  late MockUser mockUser;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockUser = MockUser();

    when(() => mockSupabaseClient.auth).thenReturn(mockAuth);
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.id).thenReturn('company_123');

    companyRepository = CompanyRepository(mockSupabaseClient);
  });

  test('createInternship inserts data with correct company_id', () async {
    final internship = Internship(
      id: '',
      companyId: '',
      title: 'Dev',
      description: 'Code',
      createdAt: DateTime.now(),
    );

    final mockBuilder = MockSupabaseQueryBuilder();
    final mockFilterBuilder = MockPostgrestFilterBuilder();

    when(() => mockSupabaseClient.from('internships')).thenReturn(mockBuilder);
    when(() => mockBuilder.insert(any())).thenReturn(mockFilterBuilder);

    await companyRepository.createInternship(internship);

    verify(() => mockSupabaseClient.from('internships')).called(1);
    final captured = verify(() => mockBuilder.insert(captureAny())).captured;

    expect(captured.length, 1);
    final insertedData = captured[0] as Map<String, dynamic>;
    expect(insertedData['company_id'], 'company_123');
    expect(insertedData['title'], 'Dev');
  });
}
