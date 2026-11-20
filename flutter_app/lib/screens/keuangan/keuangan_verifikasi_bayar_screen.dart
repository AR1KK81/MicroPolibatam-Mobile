import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

/// ============================================================================
/// BAGIAN 3B: HALAMAN DETAIL VERIFIKASI PEMBAYARAN BNI (USER STAF KEUANGAN)
/// Sama persis dengan `resources/views/keuangan/verify.blade.php`
/// ============================================================================
class KeuanganVerifikasiBayarScreen extends StatefulWidget {
  final PmbDataStore store;
  final int paymentId;

  const KeuanganVerifikasiBayarScreen({
    super.key,
    required this.store,
    required this.paymentId,
  });

  @override
  State<KeuanganVerifikasiBayarScreen> createState() => _KeuanganVerifikasiBayarScreenState();
}

class _KeuanganVerifikasiBayarScreenState extends State<KeuanganVerifikasiBayarScreen> {
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final payment = widget.store.payments.firstWhere((p) => p.paymentId == widget.paymentId);
    _notesController = TextEditingController(
      text: payment.financeNotes ?? '',
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submitVerification(bool isLunas) {
    if (!isLunas && _notesController.text.trim().isEmpty) {
      _notesController.text =
          'Nominal transfer tidak sesuai dengan biaya registrasi Rp 200.000. Silakan unggah bukti transfer yang sesuai.';
    }
    widget.store.verifyPayment(
      paymentId: widget.paymentId,
      isLunas: isLunas,
      financeNotes: _notesController.text.trim(),
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isLunas
              ? 'Pembayaran pendaftar berhasil dikonfirmasi LUNAS!'
              : 'Pembayaran ditolak & catatan keuangan telah dikirim ke pendaftar.',
        ),
        backgroundColor: isLunas ? const Color(0xFF059669) : const Color(0xFFBA1A1A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final payment = widget.store.payments.firstWhere((p) => p.paymentId == widget.paymentId);
    final reg = widget.store.getRegistrationById(payment.registrationId);
    final track = reg != null ? widget.store.getTrackById(reg.trackId) : null;
    final rek = widget.store.mainRekening;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header (`← Verifikasi Pembayaran` + `SK`)
            Container(
              height: 58,
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
                      const Text(
                        'Verifikasi Pembayaran',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF161A30),
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
                    // Meta Pills
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCE9FF),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            track?.departmentName ?? 'Informatika',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF003BA5),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1EFFF),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            reg?.regCode ?? 'PMB-MC-26',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF434655),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: payment.statusPembayaran == 'lunas'
                                ? const Color(0xFFD1FAE5)
                                : payment.statusPembayaran == 'ditolak'
                                    ? const Color(0xFFFFDAD6)
                                    : const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '• ${payment.statusPembayaran.toUpperCase()}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: payment.statusPembayaran == 'lunas'
                                  ? const Color(0xFF065F46)
                                  : payment.statusPembayaran == 'ditolak'
                                      ? const Color(0xFF93000A)
                                      : const Color(0xFFB45309),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Applicant & Nominal Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFECEEF8)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEBF2FF),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.school_outlined, color: Color(0xFF003BA5)),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reg?.fullName ?? 'Pendaftar',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF161A30),
                                    ),
                                  ),
                                  const Text(
                                    'Calon Mahasiswa Baru • Jalur Mandiri 2026',
                                    style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F2FF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'NOMINAL TAGIHAN ADMISI',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.6,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      'Rp ${payment.amount.toInt()}',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF003BA5),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                                      decoration: BoxDecoration(
                                        color: payment.amount >= 200000
                                            ? const Color(0xFFD1FAE5)
                                            : const Color(0xFFFFDAD6),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        payment.amount >= 200000 ? 'Tepat' : 'Kurang Bayar',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: payment.amount >= 200000
                                              ? const Color(0xFF065F46)
                                              : const Color(0xFF93000A),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Biaya Registrasi Jalur Microcredential',
                                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Metode Pembayaran',
                                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                              ),
                              Text(
                                '${rek.bankName} Rekening Giro',
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
                                'No. Rekening',
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
                                'Waktu Transaksi',
                                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                              ),
                              Text(
                                payment.paymentDate,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF434655)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Bukti Transfer / Struk Card
                    Container(
                      padding: const EdgeInsets.all(18),
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
                              const Text(
                                '📷 Bukti Transfer / Struk',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF161A30),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD1FAE5),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  '✓ Format Valid',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF065F46),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F2FF),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFBFD4FF)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCE9FF),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text('🧾', style: TextStyle(fontSize: 22)),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Pratinjau Foto Struk Pembayaran',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF161A30),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  payment.proofFileName,
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Catatan Keuangan Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFECEEF8)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '📝 Catatan Keuangan (Opsional / Wajib saat Tolak)',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF161A30),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Catatan ini akan langsung dikirimkan ke aplikasi calon mahasiswa bila bukti transfer ditolak.',
                            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              _buildQuickChip(
                                '+ Nominal kurang',
                                'Nominal transfer kurang Rp 100.000 dari tarif registrasi Rp 200.000.',
                              ),
                              _buildQuickChip(
                                '+ Struk buram',
                                'Foto struk transfer buram dan nomor referensi mutasi tidak terbaca.',
                              ),
                              _buildQuickChip(
                                '+ Ref tidak cocok',
                                'Nomor referensi rekening tujuan tidak sesuai dengan rekening resmi Polibatam.',
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _notesController,
                            maxLines: 3,
                            style: const TextStyle(fontSize: 12.5, color: Color(0xFF161A30)),
                            decoration: InputDecoration(
                              hintText: 'Contoh: Nominal kurang / Struk tidak terbaca / Nama pengirim berbeda...',
                              filled: true,
                              fillColor: const Color(0xFFF4F2FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Bar (`⊗ Tolak / Revisi` & `✓ Konfirmasi Lunas`)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFFBF8FF),
                border: Border(top: BorderSide(color: Color(0xFFE6E8F2))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _submitVerification(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFDAD6),
                        foregroundColor: const Color(0xFF93000A),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        '⊗ Tolak / Revisi',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _submitVerification(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        '✓ Konfirmasi Lunas',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickChip(String label, String text) {
    return InkWell(
      onTap: () => setState(() => _notesController.text = text),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F2FF),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF434655),
          ),
        ),
      ),
    );
  }
}
