import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

class KeuanganRiwayatScreen extends StatelessWidget {
  final PmbDataStore store;

  const KeuanganRiwayatScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final payments = store.payments;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF8FF),
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PMB Micro Keuangan', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
            Text('Riwayat Transaksi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rekam jejak verifikasi pembayaran Maba Polibatam', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            const SizedBox(height: 14),
            ...payments.map((p) {
              final reg = store.getRegistrationById(p.registrationId);
              final isLunas = p.statusPembayaran == 'lunas';
              final isDitolak = p.statusPembayaran == 'ditolak';
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
                        Text(reg?.fullName ?? 'Calon Maba', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: isLunas
                                ? const Color(0xFFD1FAE5)
                                : (isDitolak ? const Color(0xFFFFDAD6) : const Color(0xFFFEF3C7)),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            isLunas ? '✓ LUNAS' : (isDitolak ? '! BERMASALAH' : 'MENUNGGU'),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: isLunas
                                  ? const Color(0xFF059669)
                                  : (isDitolak ? const Color(0xFF93000A) : const Color(0xFFB45309)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(reg?.regCode ?? '-', style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rp ${p.amount.toInt()} (BNI VA)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: isDitolak ? const Color(0xFFE11D48) : const Color(0xFF161A30),
                          ),
                        ),
                        Text(p.paymentDate, style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                      ],
                    ),
                    if (p.financeNotes != null) ...[
                      const SizedBox(height: 8),
                      Text('⚠️ ${p.financeNotes}', style: const TextStyle(fontSize: 11.5, color: Color(0xFF93000A))),
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
