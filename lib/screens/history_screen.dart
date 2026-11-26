import 'package:flutter/material.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config.dart';
import '../l10n/strings.dart';
import '../services/cloud_service.dart';
import '../state/donation_store.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Map<String, dynamic>>> _cloudHistory;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _cloudHistory = CloudService.instance.myDonations();
    if (AppConfig.hasSupabase) {
      _authSubscription = CloudService.instance.client.auth.onAuthStateChange.listen((_) {
        if (mounted) _reload();
      });
    }
  }

  @override
  void dispose() { _authSubscription?.cancel(); super.dispose(); }
  void _reload() => setState(() => _cloudHistory = CloudService.instance.myDonations());

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    if (AppConfig.hasSupabase) {
      if (!CloudService.instance.isSignedIn) {
        return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('Bulutdagi xayriyalar tarixini ko‘rish uchun Profil bo‘limidan hisobingizga kiring.', textAlign: TextAlign.center)));
      }
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: _cloudHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text('Tarixni yuklashda xatolik: ${snapshot.error}'), TextButton(onPressed: _reload, child: const Text('Qayta yuklash'))]));
          final rows = snapshot.data ?? [];
          if (rows.isEmpty) return Center(child: Text(Strings.t(lang, 'history_empty')));
          return ListView(padding: const EdgeInsets.all(16), children: [
            Row(children: [Expanded(child: Text(Strings.t(lang, 'history'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))), IconButton(onPressed: _reload, icon: const Icon(Icons.refresh))]),
            const SizedBox(height: 12),
            ...rows.map((r) => Card(child: ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xFFE6F1EC), child: Icon(Icons.favorite, color: Color(0xFF145C45))),
              title: Text('${r['amount']} ${r['currency'] ?? 'UZS'}'),
              subtitle: Text('${r['project_id'] ?? 'Umumiy xayriya'} • ${DateTime.parse(r['created_at'].toString()).toLocal()}'),
              trailing: Text((r['status'] ?? 'pending').toString().toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.orange)),
            ))),
          ]);
        },
      );
    }
    return AnimatedBuilder(
      animation: DonationStore.instance,
      builder: (context, _) {
        final records = DonationStore.instance.records;
        if (records.isEmpty) return Center(child: Text(Strings.t(lang, 'history_empty')));
        return ListView(padding: const EdgeInsets.all(16), children: [
          Text(Strings.t(lang, 'history'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...records.map((r) => Card(child: ListTile(
            leading: const CircleAvatar(backgroundColor: Color(0xFFE6F1EC), child: Icon(Icons.favorite, color: Color(0xFF145C45))),
            title: Text('${r.amount} UZS'),
            subtitle: Text('${r.projectId} • ${r.createdAt.toLocal()}'),
            trailing: const Text('DEMO', style: TextStyle(fontSize: 10, color: Colors.orange)),
          ))),
        ]);
      },
    );
  }
}
