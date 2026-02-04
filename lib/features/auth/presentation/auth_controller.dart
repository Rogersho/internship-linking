import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/auth_repository.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.signInWithEmail(email: email, password: password);

      // Check if company profile exists, create if not
      final user = authRepo.currentUser;
      if (user != null && user.userMetadata?['is_company'] == true) {
        final supabase = Supabase.instance.client;
        final existing = await supabase
            .from('companies')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        if (existing == null) {
          // Create company profile if it doesn't exist
          await supabase.from('companies').insert({
            'id': user.id,
            'name': user.userMetadata?['full_name'] ?? 'Unnamed Company',
            'industry': user.userMetadata?['industry'] ?? 'Not specified',
          });
        }
      }

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required bool isCompany,
    Map<String, dynamic>? additionalData,
  }) async {
    state = const AsyncLoading();
    try {
      final authRepo = ref.read(authRepositoryProvider);
      final response = await authRepo.signUp(
        email: email,
        password: password,
        data: {
          'is_company': isCompany,
          ...?additionalData,
        },
      );

      // If company, create company profile manually
      if (isCompany && response.user != null) {
        final supabase = Supabase.instance.client;
        await supabase.from('companies').insert({
          'id': response.user!.id,
          'name': additionalData?['full_name'] ?? 'Unnamed Company',
          'industry': additionalData?['industry'] ?? 'Not specified',
        });
      }

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).signOut();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
