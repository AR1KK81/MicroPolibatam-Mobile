import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

class AdminRiwayatScreen extends StatelessWidget {
  final PmbDataStore store;

  const AdminRiwayatScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final regs = store.registrations;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF8FF),
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🎓 PMB MICRO POLIBATAM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
            Text('Riwayat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rekam jejak aktivitas verifikasi berkas Maba', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            const SizedBox(height: 14),
            ...regs.map((reg) {
              final isRevisi = reg.status == 'perlu_revisi';
              final isAcc = reg.status == 'selesai_terverifikasi';
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isAcc ? 'Berkas Disetujui' : (isRevisi ? 'Catatan Revisi Dikirim' : 'Menunggu Verifikasi'),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isRevisi ? const Color(0xFF93000A) : const Color(0xFF161A30),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: isAcc
                                ? const Color(0xFFD1FAE5)
                                : (isRevisi ? const Color(0xFFFFDAD6) : const Color(0xFFFEF3C7)),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            isAcc ? 'ACC' : (isRevisi ? 'REVISI' : 'ANTREAN'),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: isAcc
                                  ? const Color(0xFF059669)
                                  : (isRevisi ? const Color(0xFF93000A) : const Color(0xFFB45309)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF4F2FF), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(reg.fullName, style: const TextStyle(fontWeight: FontWeight.w800)),
                          Text(reg.regCode, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    if (reg.adminVerificationNotes != null) ...[
                      const SizedBox(height: 8),
                      Text('Alasan: ${reg.adminVerificationNotes}', style: const TextStyle(fontSize: 12, color: Color(0xFF93000A))),
                    ],
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
