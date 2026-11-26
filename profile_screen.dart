import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../config.dart';
import '../services/cloud_service.dart';
import 'auth_screen.dart';
import 'beneficiary_request_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String lang;
  final ValueChanged<String> onLocaleChanged;
  const ProfileScreen({super.key, required this.lang, required this.onLocaleChanged});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(18),
    children: [
      const CircleAvatar(radius: 38, backgroundColor: Color(0xFFE6F1EC), child: Icon(Icons.person, size: 42, color: Color(0xFF145C45))),
      const SizedBox(height: 12),
      const Center(child: Text('AU CHARITY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
      const SizedBox(height: 24),
      Text(Strings.t(lang, 'language'), style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Card(child: Column(children: [
        _language(context, 'uz', 'O‘zbekcha'),
        const Divider(height: 1),
        _language(context, 'ru', 'Русский'),
        const Divider(height: 1),
        _language(context, 'en', 'English'),
      ])),
      const SizedBox(height: 12),
      Card(child: ListTile(
        leading: const Icon(Icons.cloud_outlined),
        title: const Text('Bulutli tizim'),
        subtitle: Text(AppConfig.hasSupabase ? 'Supabase sozlangan' : 'Supabase kalitlari kiritilmagan — lokal demo'),
      )),
      Card(child: ListTile(
        leading: const Icon(Icons.account_circle_outlined),
        title: Text(CloudService.instance.isSignedIn
            ? (CloudService.instance.currentUser?.email ?? 'Hisob')
            : 'Donor hisobi'),
        subtitle: Text(CloudService.instance.isSignedIn ? 'Tizimga kirilgan' : 'Bulutli tarix uchun kirish'),
        trailing: TextButton(
          onPressed: () async {
            if (CloudService.instance.isSignedIn) {
              await CloudService.instance.signOut();
              if (context.mounted) (context as Element).markNeedsBuild();
            } else if (AppConfig.hasSupabase) {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
              if (context.mounted) (context as Element).markNeedsBuild();
            }
          },
          child: Text(CloudService.instance.isSignedIn ? 'Chiqish' : 'Kirish'),
        ),
      )),
      Card(child: ListTile(
        leading: const Icon(Icons.volunteer_activism, color: Color(0xFF145C45)),
        title: const Text('Yordam so‘rash'),
        subtitle: const Text('Ijtimoiy yordam uchun murojaat yuborish'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () async {
          if (!AppConfig.hasSupabase) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Murojaat yuborish uchun bulutli tizim sozlangan bo‘lishi kerak.')));
          } else if (!CloudService.instance.isSignedIn) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Avval donor hisobiga kiring.')));
          } else {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => const BeneficiaryRequestScreen()));
          }
        },
      )),
      Card(child: ListTile(leading: const Icon(Icons.info_outline), title: Text(Strings.t(lang, 'about')), subtitle: const Text('Angren University Charity Fund'))),
      Card(child: ListTile(leading: const Icon(Icons.shield_outlined), title: Text(Strings.t(lang, 'transparency')), subtitle: const Text('Demo build 1.1.0'))),
    ],
  );

  Widget _language(BuildContext context, String code, String label) => RadioListTile<String>(
    value: code, groupValue: lang, title: Text(label),
    onChanged: (v) { if (v != null) onLocaleChanged(v); },
  );
}
