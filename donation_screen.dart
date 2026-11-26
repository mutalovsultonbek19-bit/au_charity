import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/charity_project.dart';
import '../state/donation_store.dart';
import '../config.dart';
import '../services/cloud_service.dart';

class DonationScreen extends StatefulWidget {
  final CharityProject project;
  final String lang;
  const DonationScreen({super.key, required this.project, required this.lang});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final _controller = TextEditingController();
  int? _selected;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _donate() async {
    final amount = _selected ?? int.tryParse(_controller.text.replaceAll(' ', ''));
    if (amount == null || amount < 1000) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Summani to‘g‘ri kiriting / Введите сумму / Enter a valid amount')));
      return;
    }
    try {
      if (AppConfig.hasSupabase) {
        await CloudService.instance.createDemoDonation(projectId: widget.project.id, amount: amount);
      } else {
        await DonationStore.instance.addDemoDonation(widget.project.id, amount);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      return;
    }
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.info_outline, color: Colors.orange, size: 42),
        title: const Text('Demo qayd yaratildi'),
        content: Text('${amount.toString()} UZS\n\n${AppConfig.hasSupabase ? 'Bulut bazasiga pending holatida yozildi. Bu haqiqiy to‘lov emas.' : 'Qurilmadagi demo tarixiga saqlandi. Bu haqiqiy to‘lov emas.'}'),
        actions: [TextButton(onPressed: () {
          Navigator.pop(dialogContext);
          Navigator.pop(context);
        }, child: const Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final presets = [10000, 50000, 100000, 500000];
    return Scaffold(
      appBar: AppBar(title: Text(Strings.t(widget.lang, 'donate'))),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color(0xFFFFF3D9), borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            const Icon(Icons.info_outline, color: Color(0xFF946B20)),
            const SizedBox(width: 10),
            Expanded(child: Text('${Strings.t(widget.lang, 'demo')}: ${Strings.t(widget.lang, 'demo_note')}',
              style: const TextStyle(color: Color(0xFF76571E), fontSize: 12))),
          ]),
        ),
        const SizedBox(height: 24),
        Text(Strings.t(widget.lang, 'choose_amount'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 14),
        Wrap(spacing: 8, runSpacing: 8, children: presets.map((v) => ChoiceChip(
          label: Text('${v ~/ 1000} 000'),
          selected: _selected == v,
          onSelected: (_) => setState(() { _selected = v; _controller.clear(); }),
        )).toList()),
        const SizedBox(height: 22),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          onChanged: (_) => setState(() => _selected = null),
          decoration: InputDecoration(
            labelText: Strings.t(widget.lang, 'amount'),
            suffixText: 'UZS',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: _donate,
          style: FilledButton.styleFrom(backgroundColor: const Color(0xFF145C45), minimumSize: const Size.fromHeight(54)),
          child: Text(Strings.t(widget.lang, 'continue')),
        ),
      ]),
    );
  }
}
