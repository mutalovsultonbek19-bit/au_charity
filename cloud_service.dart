import 'package:supabase_flutter/supabase_flutter.dart';
import '../config.dart';
import '../models/charity_project.dart';

class CloudService {
  CloudService._();
  static final CloudService instance = CloudService._();

  bool get isConfigured => AppConfig.hasSupabase;
  SupabaseClient get client => Supabase.instance.client;
  User? get currentUser => isConfigured ? client.auth.currentUser : null;
  bool get isSignedIn => currentUser != null;

  Future<void> signUp(String email, String password) async {
    if (!isConfigured) throw StateError('Supabase hali sozlanmagan.');
    await client.auth.signUp(email: email.trim(), password: password);
  }

  Future<void> signIn(String email, String password) async {
    if (!isConfigured) throw StateError('Supabase hali sozlanmagan.');
    await client.auth.signInWithPassword(email: email.trim(), password: password);
  }

  Future<void> signOut() async {
    if (isConfigured) await client.auth.signOut();
  }

  Future<List<CharityProject>> publishedProjects() async {
    if (!isConfigured) return [];
    final rows = await client.from('charity_projects')
        .select('id,title_uz,title_ru,title_en,description_uz,description_ru,description_en,target_amount,category')
        .eq('is_public', true).eq('status', 'active')
        .order('created_at', ascending: false);
    final totals = await client.from('public_project_totals').select('project_id,total_raised');
    final raisedByProject = <String, int>{};
    for (final item in totals as List) {
      raisedByProject[item['project_id'].toString()] = (item['total_raised'] as num?)?.toInt() ?? 0;
    }
    return (rows as List).map((row) {
      final map = Map<String, dynamic>.from(row);
      return CharityProject.fromCloud(map, raised: raisedByProject[map['id'].toString()] ?? 0);
    }).toList();
  }

  /// Inserts a pending demo record only; it never marks a payment as successful.
  Future<void> createDemoDonation({required String projectId, required int amount}) async {
    if (!isConfigured) throw StateError('Bulutli baza sozlanmagan.');
    final user = currentUser;
    if (user == null) throw StateError('Bulutga xayriya qayd etish uchun avval donor hisobiga kiring.');
    await client.from('donations').insert({
      'project_id': projectId,
      'donor_user_id': user.id,
      'amount': amount,
      'currency': 'UZS',
      'payment_provider': 'demo',
      'status': 'pending',
      'is_recurring': false,
    });
  }

  Future<void> submitBeneficiaryRequest({
    required String category,
    required String description,
    int? requestedAmount,
  }) async {
    if (!isConfigured || currentUser == null) {
      throw StateError('Yordam so‘rovi yuborish uchun avval donor hisobiga kiring.');
    }
    await client.from('beneficiary_requests').insert({
      'applicant_user_id': currentUser!.id,
      'category': category,
      'description': description.trim(),
      'requested_amount': requestedAmount,
      'status': 'submitted',
    });
  }

  Future<List<Map<String, dynamic>>> myDonations() async {
    if (!isConfigured || currentUser == null) return [];
    final rows = await client.from('donations')
        .select('id,amount,currency,status,created_at,project_id,payment_provider')
        .eq('donor_user_id', currentUser!.id)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows);
  }
}
