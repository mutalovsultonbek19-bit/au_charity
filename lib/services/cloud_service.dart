
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config.dart';
import '../models/charity_project.dart';

class CloudService {
  CloudService._();

  static final CloudService instance = CloudService._();

  bool get isConfigured => AppConfig.hasSupabase;

  SupabaseClient get client => Supabase.instance.client;

  User? get currentUser =>
      isConfigured ? client.auth.currentUser : null;

  bool get isSignedIn => currentUser != null;

  Future<void> signUp(String email, String password) async {
    if (!isConfigured) {
      throw StateError('Supabase hali sozlanmagan.');
    }

    await client.auth.signUp(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signIn(String email, String password) async {
    if (!isConfigured) {
      throw StateError('Supabase hali sozlanmagan.');
    }

    await client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() async {
    if (!isConfigured) return;
    await client.auth.signOut();
  }

  // Published charity projects
  Future<List<CharityProject>> publishedProjects() async {
    if (!isConfigured) return [];

    final rows = await client
        .from('charity_projects')
        .select('id,title,description,category,goal_amount');

    return (rows as List).map((row) {
      return CharityProject.fromCloud(
        Map<String, dynamic>.from(row),
      );
    }).toList();
  }

  // Demo donation: pending only, not a confirmed payment
  Future<void> createDemoDonation({
    required String projectId,
    required int amount,
  }) async {
    if (!isConfigured) {
      throw StateError('Supabase sozlanmagan.');
    }

    final user = currentUser;

    if (user == null) {
      throw StateError('Avval tizimga kiring.');
    }

    await client.from('donations').insert({
      'project_id': projectId,
      'donor_id': user.id,
      'amount': amount,
      'status': 'pending',
    });
  }

  // Beneficiary request
  Future<void> submitBeneficiaryRequest({
    required String category,
    required String description,
    int? requestedAmount,
  }) async {
    if (!isConfigured || currentUser == null) {
      throw StateError('Avval tizimga kiring.');
    }

    final requestDescription = [
      'Kategoriya: $category',
      'Tavsif: ${description.trim()}',
      if (requestedAmount != null)
        'So‘ralgan summa: $requestedAmount UZS',
    ].join('\n');

    await client.from('beneficiary_requests').insert({
      'user_id': currentUser!.id,
      'description': requestDescription,
      'status': 'pending',
    });
  }

  // Donor donation history
  Future<List<Map<String, dynamic>>> myDonations() async {
    if (!isConfigured || currentUser == null) {
      return [];
    }

    final rows = await client
        .from('donations')
        .select('*')
        .eq('donor_id', currentUser!.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(rows);
  }
}
