import 'package:flutter/material.dart';
import '../services/cloud_service.dart';

class BeneficiaryRequestScreen extends StatefulWidget {
  const BeneficiaryRequestScreen({super.key});
  @override
  State<BeneficiaryRequestScreen> createState() => _BeneficiaryRequestScreenState();
}

class _BeneficiaryRequestScreenState extends State<BeneficiaryRequestScreen> {
  final _description = TextEditingController();
  final _amount = TextEditingController();
  String _category = 'education';
  bool _busy = false;

  @override
  void dispose() { _description.dispose(); _amount.dispose(); super.dispose(); }

  Future<void> _submit() async {
    final text = _description.text.trim();
    final amountText = _amount.text.trim();
    final amount = amountText.isEmpty ? null : int.tryParse(amountText.replaceAll(' ', ''));
    if (text.length < 20 || (amountText.isNotEmpty && (amount == null || amount < 1))) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Izoh kamida 20 ta belgidan iborat bo‘lsin va summa to‘g‘ri kiritilsin.')));
      return;
    }
    setState(() => _busy = true);
    try {
      await CloudService.instance.submitBeneficiaryRequest(category: _category, description: text, requestedAmount: amount);
      if (!mounted) return;
      await showDialog<void>(context: context, builder: (ctx) => AlertDialog(
        title: const Text('So‘rov yuborildi'),
        content: const Text('Murojaatingiz AU CHARITY tizimiga qabul qilindi. Holatini administrator ko‘rib chiqadi.'),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
      ));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally { if (mounted) setState(() => _busy = false); }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Yordam so‘rash')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Ijtimoiy yordam uchun murojaat', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('Murojaat faqat mas’ul xodimlar tomonidan ko‘rib chiqiladi. Shaxsiy ma’lumotlaringiz oshkor qilinmaydi.', style: TextStyle(color: Colors.black54)),
      const SizedBox(height: 20),
      DropdownButtonFormField<String>(value: _category, decoration: const InputDecoration(labelText: 'Yordam yo‘nalishi', border: OutlineInputBorder()), items: const [
        DropdownMenuItem(value: 'education', child: Text('Ta’lim xarajatlari')),
        DropdownMenuItem(value: 'medical', child: Text('Davolanish')),
        DropdownMenuItem(value: 'social', child: Text('Ijtimoiy yordam')),
        DropdownMenuItem(value: 'emergency', child: Text('Favqulodda holat')),
        DropdownMenuItem(value: 'other', child: Text('Boshqa')),
      ], onChanged: (v) { if (v != null) setState(() => _category = v); }),
      const SizedBox(height: 14),
      TextField(controller: _description, minLines: 5, maxLines: 8, decoration: const InputDecoration(labelText: 'Vaziyatni batafsil bayon qiling', alignLabelWithHint: true, border: OutlineInputBorder())),
      const SizedBox(height: 14),
      TextField(controller: _amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'So‘ralayotgan summa (ixtiyoriy)', suffixText: 'UZS', border: OutlineInputBorder())),
      const SizedBox(height: 10),
      const Text('Hujjatlarni ilova qilish funksiyasi keyingi bosqichda maxfiy fayl ombori orqali ulanadi. Hozircha maxfiy hujjatlarni ochiq havolalar bilan yubormang.', style: TextStyle(fontSize: 12, color: Colors.black54)),
      const SizedBox(height: 22),
      FilledButton(onPressed: _busy ? null : _submit, style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)), child: _busy ? const CircularProgressIndicator() : const Text('Murojaatni yuborish')),
    ]),
  );
}
