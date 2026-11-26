import 'package:flutter/material.dart';
import '../services/cloud_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _createAccount = false;
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _busy = true);
    try {
      if (_createAccount) {
        await CloudService.instance.signUp(_email.text, _password.text);
      } else {
        await CloudService.instance.signIn(_email.text, _password.text);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_createAccount
            ? 'Ro‘yxatdan o‘tish so‘rovi yuborildi. Emailni tekshiring.'
            : 'Tizimga muvaffaqiyatli kirdingiz.')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xatolik: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('AU CHARITY — Hisob')),
    body: ListView(padding: const EdgeInsets.all(22), children: [
      const Icon(Icons.lock_outline, size: 54, color: Color(0xFF145C45)),
      const SizedBox(height: 18),
      Text(_createAccount ? 'Hisob yaratish' : 'Tizimga kirish',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('Bulutli xayriya tarixidan foydalanish uchun hisobingizga kiring.'),
      const SizedBox(height: 24),
      TextField(controller: _email, keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
      const SizedBox(height: 14),
      TextField(controller: _password, obscureText: true,
        decoration: const InputDecoration(labelText: 'Parol (kamida 6 belgi)', border: OutlineInputBorder())),
      const SizedBox(height: 20),
      FilledButton(
        onPressed: _busy ? null : _submit,
        style: FilledButton.styleFrom(backgroundColor: const Color(0xFF145C45), minimumSize: const Size.fromHeight(52)),
        child: _busy ? const CircularProgressIndicator() : Text(_createAccount ? 'Ro‘yxatdan o‘tish' : 'Kirish'),
      ),
      TextButton(
        onPressed: _busy ? null : () => setState(() => _createAccount = !_createAccount),
        child: Text(_createAccount ? 'Hisobingiz bormi? Kirish' : 'Yangi hisob yaratish'),
      ),
    ]),
  );
}
