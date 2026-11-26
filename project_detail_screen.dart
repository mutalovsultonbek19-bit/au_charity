import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/charity_project.dart';
import 'donation_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final CharityProject project;
  final String lang;
  const ProjectDetailScreen({super.key, required this.project, required this.lang});

  @override
  Widget build(BuildContext context) {
    final progress = (project.raised / project.goal).clamp(0.0, 1.0);
    return Scaffold(
      appBar: AppBar(title: Text(project.title(lang))),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(colors: [Color(0xFF104B39), Color(0xFF2C8B68)]),
          ),
          child: const Center(child: Icon(Icons.volunteer_activism, color: Color(0xFFE5C77B), size: 64)),
        ),
        const SizedBox(height: 20),
        Text(project.title(lang), style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(project.description(lang), style: const TextStyle(height: 1.5, color: Colors.black54)),
        const SizedBox(height: 22),
        Text('${Strings.t(lang, 'collected')}: ${project.raised} UZS'),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: progress, minHeight: 9, color: const Color(0xFF1D7355)),
        const SizedBox(height: 8),
        Text('${Strings.t(lang, 'goal')}: ${project.goal} UZS'),
        const SizedBox(height: 28),
        FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54), backgroundColor: const Color(0xFF145C45)),
          onPressed: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => DonationScreen(project: project, lang: lang),
          )),
          icon: const Icon(Icons.favorite),
          label: Text(Strings.t(lang, 'donate')),
        ),
      ]),
    );
  }
}
