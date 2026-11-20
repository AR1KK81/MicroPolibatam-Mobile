import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import 'keuangan_verifikasi_bayar_screen.dart';

/// ============================================================================
/// BAGIAN 3C: RIWAYAT TRANSAKSI & AUDIT KEUANGAN (USER STAF KEUANGAN)
/// Sama persis dengan `resources/views/keuangan/riwayat.blade.php`
/// ============================================================================
class KeuanganRiwayatScreen extends StatefulWidget {
  final PmbDataStore store;

  const KeuanganRiwayatScreen({super.key, required this.store});

  @override
  State<KeuanganRiwayatScreen> createState() => _KeuanganRiwayatScreenState();
}

class _KeuanganRiwayatScreenState extends State<KeuanganRiwayatScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final allPayments = widget.store.payments;
    final totalAmount = allPayments
        .where((p) => p.statusPembayaran == 'lunas')
        .fold<double>(0, (sum, p) => sum + p.amount);
    final lunasCount = allPayments.where((p) => p.statusPembayaran == 'lunas').length;
    final ditolakCount = allPayments.where((p) => p.statusPembayaran == 'ditolak').length;
    final rek = widget.store.mainRekening;

    final filtered = allPayments.where((p) {
      if (_search.isEmpty) return true;
      final reg = widget.store.getRegistrationById(p.registrationId);
      final q = _search.toLowerCase();
      return (reg?.fullName.toLowerCase().contains(q) ?? false) ||
          (reg?.regCode.toLowerCase().contains(q) ?? false);
    }).toList();

    return Column(
      children: [
        // Top Header (`PMB Micro / Keuangan` + `SK`)
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Color(0xFFFBF8FF),
            border: Border(bottom: BorderSide(color: Color(0xFFEAE8F5))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PMB Micro',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: Color(0xFF0052CC),
                    ),
                  ),
                  Text(
                    'Keuangan',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF003BA5),
                    ),
                  ),
                ],
              ),
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Color(0xFF003BA5),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'SK',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE9FF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    '🛡️ Portal Keuangan • Rekonsiliasi & Audit',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF003BA5),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Riwayat Transaksi',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF161A30),
                  ),
                ),
                const Text(
                  'Rekam jejak verifikasi pembayaran Maba Polibatam',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 14),

                // 2 Summary Cards (`TOTAL TRANSAKSI` & `VALIDASI`)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFECEEF8)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TOTAL TRANSAKSI',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${allPayments.length} Transaksi',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF161A30),
                              ),
                            ),
                            Text(
                              'Rp ${totalAmount.toInt()}',
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF003BA5),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '✓ Sinkronisasi Real-time',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFECEEF8)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'VALIDASI',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  '• $lunasCount Lunas',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '• $ditolakCount Isu',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFBA1A1A),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Verifikasi Manual & VA',
                              style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Search Bar
                TextField(
                  onChanged: (v) => setState(() => _search = v),
                  style: const TextStyle(fontSize: 13, color: Color(0xFF161A30)),
                  decoration: InputDecoration(
                    hintText: 'Cari pendaftar, No. VA, atau Ref...',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE8ECF8)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE8ECF8)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                ...filtered.map((pay) {
                  final reg = widget.store.getRegistrationById(pay.registrationId);
                  final track = reg != null ? widget.store.getTrackById(reg.trackId) : null;
                  final isLunas = pay.statusPembayaran == 'lunas';
                  final isDitolak = pay.statusPembayaran == 'ditolak';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDitolak ? const Color(0xFFFECDD3) : const Color(0xFFECEEF8),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: isDitolak
                              ? const Border(
                                  left: BorderSide(color: Color(0xFFE11D48), width: 4),
                                )
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              reg?.fullName ?? 'Pendaftar',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFF161A30),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFDCE9FF),
                                              borderRadius: BorderRadius.circular(999),
                                            ),
                                            child: Text(
                                              track?.departmentName ?? 'Informatika',
                                              style: const TextStyle(
                                                fontSize: 9.5,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFF003BA5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        reg?.regCode ?? 'PMB-MC-26',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                                  decoration: BoxDecoration(
                                    color: isLunas
                                        ? const Color(0xFFD1FAE5)
                                        : isDitolak
                                            ? const Color(0xFFFFDAD6)
                                            : const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    isLunas
                                        ? '• LUNAS'
                                        : isDitolak
                                            ? '• BERMASALAH'
                                            : '• MENUNGGU',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w800,
                                      color: isLunas
                                          ? const Color(0xFF065F46)
                                          : isDitolak
                                              ? const Color(0xFF93000A)
                                              : const Color(0xFFB45309),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Rp ${pay.amount.toInt()}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: isDitolak
                                        ? const Color(0xFFBA1A1A)
                                        : const Color(0xFF161A30),
                                  ),
                                ),
                                Text(
                                  '🕒 ${pay.paymentDate}',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                            if (isDitolak && pay.financeNotes != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF5F5),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFFECDD3)),
                                ),
                                child: Text(
                                  '⚠️ ${pay.financeNotes!}',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF93000A)),
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ref BNI: ${rek.accountNumber}',
                                  style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => KeuanganVerifikasiBayarScreen(
                                          store: widget.store,
                                          paymentId: pay.paymentId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Tinjau Transaksi ›',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0052CC),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 6),
                // Ekspor Log Transaksi (.CSV) Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Mengekspor log_transaksi_keuangan_pmb.csv (${filtered.length} transaksi)...',
                          ),
                          backgroundColor: const Color(0xFF003BA5),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF003BA5),
                      side: const BorderSide(color: Color(0xFFBFD4FF)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      '⬇ Ekspor Log Transaksi (.CSV)',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
