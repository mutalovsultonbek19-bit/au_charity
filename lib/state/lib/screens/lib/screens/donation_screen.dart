import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonationRecord {
  final String id;
  final String projectId;
  final int amount;
  final DateTime createdAt;
  final String status;

  const DonationRecord({
    required this.id,
    required this.projectId,
    required this.amount,
    required this.createdAt,
    this.status = 'demo',
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'projectId': projectId, 'amount': amount,
    'createdAt': createdAt.toIso8601String(), 'status': status,
  };

  factory DonationRecord.fromJson(Map<String, dynamic> json) => DonationRecord(
    id: json['id'] as String,
    projectId: json['projectId'] as String,
    amount: json['amount'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
    status: json['status'] as String? ?? 'demo',
  );
}

class DonationStore extends ChangeNotifier {
  DonationStore._();
  static final DonationStore instance = DonationStore._();

  static const _storageKey = 'au_charity_demo_donations_v1';
  final List<DonationRecord> _records = [];
  List<DonationRecord> get records => List.unmodifiable(_records);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      _records
        ..clear()
        ..addAll(decoded.map((e) => DonationRecord.fromJson(
          Map<String, dynamic>.from(e as Map),
        )));
      notifyListeners();
    } catch (_) {
      // A corrupt local cache is ignored; it must not prevent the app from opening.
    }
  }

  Future<void> addDemoDonation(String projectId, int amount) async {
    final record = DonationRecord(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      projectId: projectId,
      amount: amount,
      createdAt: DateTime.now(),
    );
    _records.insert(0, record);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_records.map((r) => r.toJson()).toList()));
    notifyListeners();
  }

  Future<void> clearDemoHistory() async {
    _records.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    notifyListeners();
  }
}
