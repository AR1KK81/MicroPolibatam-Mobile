import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import '../../widgets/pmb_widgets.dart';
import 'keuangan_verifikasi_bayar_screen.dart';

/// ============================================================================
/// BAGIAN 3A: KELOLA PEMBAYARAN PENDAFTAR (USER STAF KEUANGAN)
/// Sama persis dengan `resources/views/keuangan/dashboard.blade.php`
/// ============================================================================
class KeuanganKelolaBayarScreen extends StatefulWidget {
  final PmbDataStore store;

  const KeuanganKelolaBayarScreen({super.key, required this.store});

  @override
  State<KeuanganKelolaBayarScreen> createState() => _KeuanganKelolaBayarScreenState();
}

class _KeuanganKelolaBayarScreenState extends State<KeuanganKelolaBayarScreen> {
  String _tab = 'perlu_cek'; // 'perlu_cek', 'bermasalah', 'lunas'
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final allPayments = widget.store.payments;
    final perluCekCount = allPayments.where((p) => p.statusPembayaran == 'menunggu').length;
    final bermasalahCount = allPayments.where((p) => p.statusPembayaran == 'ditolak').length;
    final lunasCount = allPayments.where((p) => p.statusPembayaran == 'lunas').length;
    final totalLunasAmount = allPayments
        .where((p) => p.statusPembayaran == 'lunas')
        .fold<double>(0, (sum, p) => sum + p.amount);

    final filtered = allPayments.where((p) {
      if (_tab == 'perlu_cek' && p.statusPembayaran != 'menunggu') return false;
      if (_tab == 'bermasalah' && p.statusPembayaran != 'ditolak') return false;
      if (_tab == 'lunas' && p.statusPembayaran != 'lunas') return false;
      if (_search.isNotEmpty) {
        final reg = widget.store.getRegistrationById(p.registrationId);
        final q = _search.toLowerCase();
        return (reg?.fullName.toLowerCase().contains(q) ?? false) ||
            (reg?.regCode.toLowerCase().contains(q) ?? false) ||
            p.proofFileName.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    final rek = widget.store.mainRekening;

    return Column(
      children: [
        // Top Header (`PMB Micro / Keuangan` + Bell + `SK`)
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
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE1E6F5)),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.notifications_none,
                      size: 18,
                      color: Color(0xFF434655),
                    ),
                  ),
                  const SizedBox(width: 8),
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
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE9FF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    '🛡️ PORTAL KEUANGAN • POLIBATAM',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF003BA5),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Halo, Staf Keuangan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF161A30),
                  ),
                ),
                const Text(
                  'Panel Validasi & Rekonsiliasi Admisi PMB',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 14),

                // 2 Stat Cards (`MENUNGGU CEK` & `TOTAL LUNAS`)
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
                              'MENUNGGU CEK',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$perluCekCount Maba',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF161A30),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                '• Perlu Aksi Hari Ini',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFB45309),
                                ),
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
                              'TOTAL LUNAS',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$lunasCount Maba',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF161A30),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD1FAE5),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '💳 Rp ${totalLunasAmount.toInt()}',
                                style: const TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF065F46),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Sinkronisasi VA Otomatis Aktif Info Banner (`dashboard.blade.php` lines 53-61)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF2FF),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFBFD4FF)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '☑️ Sinkronisasi VA Otomatis Aktif',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF003BA5),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Host-to-Host BNI 24 Jam terhubung ke sistem. Transfer bank manual membutuhkan audit struk visual oleh staf keuangan.',
                        style: TextStyle(fontSize: 11, height: 1.35, color: Color(0xFF43485B)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Search Bar
                TextField(
                  onChanged: (v) => setState(() => _search = v),
                  style: const TextStyle(fontSize: 13, color: Color(0xFF161A30)),
                  decoration: InputDecoration(
                    hintText: 'Cari Nama, No. VA, atau ID PMB...',
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

                // Custom Filter Pill Tabs (`Perlu Cek`, `• Bermasalah`, `✓ Lunas`)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      PmbPillTab(
                        label: 'Perlu Cek',
                        badgeCount: '$perluCekCount',
                        isSelected: _tab == 'perlu_cek',
                        activeBgColor: const Color(0xFF0052CC),
                        onTap: () => setState(() => _tab = 'perlu_cek'),
                      ),
                      const SizedBox(width: 8),
                      PmbPillTab(
                        label: '• Bermasalah',
                        badgeCount: '$bermasalahCount',
                        isSelected: _tab == 'bermasalah',
                        activeBgColor: const Color(0xFFE11D48),
                        inactiveTextColor: const Color(0xFF93000A),
                        onTap: () => setState(() => _tab = 'bermasalah'),
                      ),
                      const SizedBox(width: 8),
                      PmbPillTab(
                        label: '✓ Lunas',
                        badgeCount: '$lunasCount',
                        isSelected: _tab == 'lunas',
                        activeBgColor: const Color(0xFF059669),
                        inactiveTextColor: const Color(0xFF065F46),
                        onTap: () => setState(() => _tab = 'lunas'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Antrean Validasi Header
                Row(
                  children: [
                    const Text(
                      'Antrean Validasi',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF161A30),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1EFFF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Batch 1 2026',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF434655),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (filtered.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFECEEF8)),
                    ),
                    child: const Text(
                      'Tidak ada data pembayaran pada kategori ini.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                  )
                else
                  ...filtered.map((pay) {
                    final reg = widget.store.getRegistrationById(pay.registrationId);
                    final track = reg != null ? widget.store.getTrackById(reg.trackId) : null;
                    final isPending = pay.statusPembayaran == 'menunggu';
                    final isDitolak = pay.statusPembayaran == 'ditolak';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFECEEF8)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCE9FF),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  track?.departmentName ?? 'Informatika',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF003BA5),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isPending
                                      ? const Color(0xFFFEF3C7)
                                      : isDitolak
                                          ? const Color(0xFFFFDAD6)
                                          : const Color(0xFFD1FAE5),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  isPending
                                      ? '• MENUNGGU VALIDASI'
                                      : isDitolak
                                          ? '• BUKTI TIDAK VALID'
                                          : '✓ LUNAS / TERVERIFIKASI',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: isPending
                                        ? const Color(0xFFB45309)
                                        : isDitolak
                                            ? const Color(0xFF93000A)
                                            : const Color(0xFF065F46),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reg?.fullName ?? 'Pendaftar',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF161A30),
                                    ),
                                  ),
                                  Text(
                                    reg?.regCode ?? 'PMB-MC-26',
                                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFDCE9FF),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  reg?.initials ?? 'MB',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF003BA5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // 4-Row Payment Breakdown + White Proof Bar
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F2FF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '🏦 Metode Bayar',
                                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                    ),
                                    Text(
                                      'Transfer Rekening ${rek.bankName}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF161A30),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'No. Rekening BNI',
                                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                    ),
                                    Text(
                                      rek.accountNumber,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF161A30),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Nominal Registrasi',
                                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                    ),
                                    Text(
                                      'Rp ${pay.amount.toInt()}',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w900,
                                        color: pay.amount < 200000
                                            ? const Color(0xFFBA1A1A)
                                            : const Color(0xFF003BA5),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Waktu Transaksi',
                                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                    ),
                                    Text(
                                      pay.paymentDate,
                                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF434655)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '📎 ${pay.proofFileName}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF434655),
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        'Pratinjau 👁️',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF0052CC),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (isDitolak && pay.financeNotes != null) ...[
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF5F5),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFFECDD3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '⚠️ Catatan Keuangan:',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF93000A),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    pay.financeNotes!,
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF7F1D1D)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            child: isPending
                                ? ElevatedButton(
                                    onPressed: () {
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
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0052CC),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 1,
                                    ),
                                    child: const Text(
                                      'Verifikasi Pembayaran →',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                                    ),
                                  )
                                : OutlinedButton(
                                    onPressed: () {
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
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: isDitolak
                                          ? const Color(0xFF93000A)
                                          : const Color(0xFF003BA5),
                                      side: BorderSide(
                                        color: isDitolak
                                            ? const Color(0xFFFECDD3)
                                            : const Color(0xFFCBD5E1),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Text(
                                      isDitolak
                                          ? 'Detail & Edit Catatan →'
                                          : 'Lihat Bukti & Kuitansi →',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
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
    );
  }
}
