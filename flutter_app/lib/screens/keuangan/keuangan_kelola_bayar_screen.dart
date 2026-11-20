import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import 'keuangan_verifikasi_bayar_screen.dart';

class KeuanganKelolaBayarScreen extends StatefulWidget {
  final PmbDataStore store;

  const KeuanganKelolaBayarScreen({super.key, required this.store});

  @override
  State<KeuanganKelolaBayarScreen> createState() => _KeuanganKelolaBayarScreenState();
}

class _KeuanganKelolaBayarScreenState extends State<KeuanganKelolaBayarScreen> {
  String _activeTab = 'menunggu'; // 'menunggu', 'ditolak', 'lunas'

  @override
  Widget build(BuildContext context) {
    final allPayments = widget.store.payments;
    final menungguCount = allPayments.where((p) => p.statusPembayaran == 'menunggu').length;
    final bermasalahCount = allPayments.where((p) => p.statusPembayaran == 'ditolak').length;
    final lunasCount = allPayments.where((p) => p.statusPembayaran == 'lunas').length;

    final filtered = allPayments.where((p) => p.statusPembayaran == _activeTab).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF8FF),
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PMB Micro', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
            Text('Keuangan', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFDCE9FF), borderRadius: BorderRadius.circular(99)),
              child: const Text('🏛️ PORTAL KEUANGAN • POLIBATAM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
            ),
            const SizedBox(height: 8),
            const Text('Halo, Staf Keuangan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
            const Text('Panel Validasi & Rekonsiliasi Admisi PMB', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            const SizedBox(height: 16),

            // 2 Stats Cards (Frame 405:5)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('MENUNGGU CEK', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
                        const SizedBox(height: 6),
                        Text('$menungguCount Maba', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                        const Text('• Perlu Aksi Hari Ini', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFFB45309))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TOTAL LUNAS', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
                        const SizedBox(height: 6),
                        Text('$lunasCount Maba', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                        Text('💵 Rp ${lunasCount * 200}.000', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF059669))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 3 Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('menunggu', 'Perlu Cek', menungguCount),
                  const SizedBox(width: 8),
                  _buildFilterChip('ditolak', '• Bermasalah', bermasalahCount),
                  const SizedBox(width: 8),
                  _buildFilterChip('lunas', '✓ Lunas', lunasCount),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Payment Cards
            ...filtered.map((payment) {
              final reg = widget.store.getRegistrationById(payment.registrationId);
              final track = reg != null ? widget.store.getTrackById(reg.trackId) : null;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFDCE9FF), borderRadius: BorderRadius.circular(99)),
                          child: Text(track?.departmentName ?? 'Informatika', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: payment.statusPembayaran == 'lunas'
                                ? const Color(0xFFD1FAE5)
                                : (payment.statusPembayaran == 'ditolak' ? const Color(0xFFFFDAD6) : const Color(0xFFFEF3C7)),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            payment.statusPembayaran == 'lunas'
                                ? '✓ LUNAS'
                                : (payment.statusPembayaran == 'ditolak' ? '! BERMASALAH' : '• MENUNGGU VALIDASI'),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: payment.statusPembayaran == 'lunas'
                                  ? const Color(0xFF059669)
                                  : (payment.statusPembayaran == 'ditolak' ? const Color(0xFF93000A) : const Color(0xFFB45309)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(reg?.fullName ?? 'Calon Maba', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                    Text(reg?.regCode ?? 'PMB-MC-26-1', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF4F2FF), borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Metode Bayar', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                              Text('Transfer Rekening BNI', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Nominal Registrasi', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                              Text('Rp ${payment.amount.toInt()}', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: Color(0xFF0052CC))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (payment.financeNotes != null) ...[
                      const SizedBox(height: 8),
                      Text('⚠️ ${payment.financeNotes}', style: const TextStyle(fontSize: 11.5, color: Color(0xFF93000A))),
                    ],
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => KeuanganVerifikasiBayarScreen(store: widget.store, payment: payment),
                            ),
                          );
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0052CC),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Verifikasi Pembayaran →', style: TextStyle(fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String statusKey, String label, int count) {
    final isActive = _activeTab == statusKey;
    return ChoiceChip(
      selected: isActive,
      selectedColor: const Color(0xFF0052CC),
      backgroundColor: Colors.white,
      label: Text(
        '$label ($count)',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isActive ? Colors.white : const Color(0xFF475569),
        ),
      ),
      onSelected: (_) => setState(() => _activeTab = statusKey),
    );
  }
}
