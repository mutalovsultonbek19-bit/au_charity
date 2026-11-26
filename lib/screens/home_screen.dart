import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../config.dart';
import '../services/cloud_service.dart';
import '../l10n/strings.dart';
import '../models/charity_project.dart';
import 'project_detail_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final Locale locale;
  final ValueChanged<String> onLocaleChanged;
  const HomeScreen({super.key, required this.locale, required this.onLocaleChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  List<CharityProject> _projectItems = demoProjects;
  bool _loadingProjects = false;
  String? _projectError;
  String get lang => widget.locale.languageCode;

  @override
  void initState() { super.initState(); _loadProjects(); }

  Future<void> _loadProjects() async {
    if (!AppConfig.hasSupabase) { setState(() { _projectItems = demoProjects; _projectError = null; }); return; }
    setState(() { _loadingProjects = true; _projectError = null; });
    try {
      final data = await CloudService.instance.publishedProjects();
      if (!mounted) return;
     setState(() => _projectItems = data);
    } catch (e) {
      if (!mounted) return;
      setState(() => _projectError = 'Loyihalarni yuklashda xatolik: $e');
    } finally { if (mounted) setState(() => _loadingProjects = false); }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _home(),
      _projects(),
      const HistoryScreen(),
      ProfileScreen(lang: lang, onLocaleChanged: widget.onLocaleChanged),
    ];
    final labels = ['home', 'projects', 'history', 'profile'];
    final icons = [Icons.home_rounded, Icons.volunteer_activism, Icons.receipt_long, Icons.person];
    return Scaffold(
      appBar: AppBar(
        title: const Text('AU CHARITY', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: const Color(0xFFFFF2D8), borderRadius: BorderRadius.circular(20)),
            child: const Text('DEMO', style: TextStyle(color: Color(0xFF8B641D), fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ],
      ),
      body: IndexedStack(index: _tab, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (v) => setState(() => _tab = v),
        destinations: List.generate(4, (i) => NavigationDestination(
          icon: Icon(icons[i]), label: Strings.t(lang, labels[i]),
        )),
      ),
    );
  }

  Widget _home() => ListView(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
    children: [
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF104B39), Color(0xFF1D7355)]),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.favorite, color: Color(0xFFE5C77B), size: 30),
          const SizedBox(height: 12),
          Text(Strings.t(lang, 'tagline'), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(Strings.t(lang, 'demo_note'), style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ]),
      ),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(child: _stat(Strings.t(lang, 'raised'), _money(_projectItems.fold<int>(0, (sum, p) => sum + p.raised)), Icons.volunteer_activism)),
        const SizedBox(width: 10),
        Expanded(child: _stat(Strings.t(lang, 'projects'), _projectItems.length.toString(), Icons.folder_open)),
      ]),
      const SizedBox(height: 22),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(Strings.t(lang, 'featured'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(onPressed: () => setState(() => _tab = 1), child: Text(Strings.t(lang, 'see_all'))),
      ]),
      _projectList(_projectItems.take(3).toList()),
    ],
  );

  Widget _projects() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Text(Strings.t(lang, 'featured'), style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [IconButton(onPressed: _loadProjects, icon: const Icon(Icons.refresh), tooltip: 'Yangilash')]),
      _projectList(_projectItems),
    ],
  );


  Widget _projectList(List<CharityProject> projects) {
    if (_loadingProjects && projects.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(28), child: CircularProgressIndicator()));
    if (_projectError != null) return Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Text(_projectError!, style: const TextStyle(color: Colors.red)), TextButton(onPressed: _loadProjects, child: const Text('Qayta urinish'))])));
    if (projects.isEmpty) return const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('Hozircha faol xayriya loyihalari mavjud emas.')));
    return Column(children: projects.map(_projectCard).toList());
  }

  String _money(int value) {
    final digits = value.toString();
    final out = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) out.write(' ');
      out.write(digits[i]);
    }
    return '$out UZS';
  }

  Widget _stat(String title, String value, IconData icon) => Card(
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: const Color(0xFF145C45)),
        const SizedBox(height: 12),
        Text(value, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.black54)),
      ]),
    ),
  );

  Widget _projectCard(CharityProject p) {
    final progress = (p.raised / p.goal).clamp(0.0, 1.0);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => ProjectDetailScreen(project: p, lang: lang),
        )),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(backgroundColor: const Color(0xFFE6F1EC), child: Icon(
                p.category == 'education' ? Icons.school : p.category == 'science' ? Icons.science : Icons.favorite,
                color: const Color(0xFF145C45))),
              const SizedBox(width: 12),
              Expanded(child: Text(p.title(lang), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              const Icon(Icons.arrow_forward_ios, size: 15, color: Colors.black38),
            ]),
            const SizedBox(height: 12),
            Text(p.description(lang), maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 14),
            ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(
              value: progress, minHeight: 8, backgroundColor: const Color(0xFFE9EEE9), color: const Color(0xFF1D7355))),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('${Strings.t(lang, 'collected')}: ${p.raised} so‘m', style: const TextStyle(fontSize: 11)),
              Text('${(progress * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF145C45))),
            ]),
          ]),
        ),
      ),
    );
  }
}
