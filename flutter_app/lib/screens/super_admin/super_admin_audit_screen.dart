import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

/// ============================================================================
/// BAGIAN 4F: AUDIT LOG KEAMANAN (USER SUPER ADMIN)
/// Sama persis dengan `resources/views/super-admin/audit.blade.php`
/// ============================================================================
class SuperAdminAuditScreen extends StatefulWidget {
  final PmbDataStore store;

  const SuperAdminAuditScreen({super.key, required this.store});

  @override
  State<SuperAdminAuditScreen> createState() => _SuperAdminAuditScreenState();
}

class _SuperAdminAuditScreenState extends State<SuperAdminAuditScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final logs = widget.store.auditLogs.where((log) {
      if (_search.isEmpty) return true;
      final q = _search.toLowerCase();
      return log.actor.toLowerCase().contains(q) ||
          log.action.toLowerCase().contains(q) ||
          log.object.toLowerCase().contains(q) ||
          log.result.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header (`KEAMANAN & JEJAK AUDIT / Audit Logs` + `⬇ CSV`)
            Container(
              height: 62,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFFBF8FF),
                border: Border(bottom: BorderSide(color: Color(0xFFEAE8F5))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(999),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.arrow_back, size: 20, color: Color(0xFF161A30)),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KEAMANAN & JEJAK AUDIT',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              color: Color(0xFF003BA5),
                            ),
                          ),
                          Text(
                            'Audit Logs (audit_logs)',
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF161A30),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Mengunduh audit_logs_polibatam.csv (${logs.length} baris)...'),
                          backgroundColor: const Color(0xFF003BA5),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCE9FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '⬇ CSV',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF003BA5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (v) => setState(() => _search = v),
                      style: const TextStyle(fontSize: 13, color: Color(0xFF161A30)),
                      decoration: InputDecoration(
                        hintText: 'Cari email aktor, aksi (LOGIN, ACC_BERKAS), atau hasil...',
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...logs.map((log) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFECEEF8)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFECECFF),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    log.action,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF003BA5),
                                    ),
                                  ),
                                ),
                                Text(
                                  log.timestamp,
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              log.actor,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF161A30),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text.rich(
                              TextSpan(
                                text: 'Objek: ',
                                style: const TextStyle(fontSize: 11.5, color: Color(0xFF434655)),
                                children: [
                                  TextSpan(
                                    text: log.object,
                                    style: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              log.result,
                              style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
