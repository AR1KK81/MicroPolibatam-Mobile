import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

class KeuanganVerifikasiBayarScreen extends StatefulWidget {
  final PmbDataStore store;
  final PaymentItem payment;

  const KeuanganVerifikasiBayarScreen({
    super.key,
    required this.store,
    required this.payment,
  });

  @override
  State<KeuanganVerifikasiBayarScreen> createState() => _KeuanganVerifikasiBayarScreenState();
}

class _KeuanganVerifikasiBayarScreenState extends State<KeuanganVerifikasiBayarScreen> {
  late TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    _notesCtrl = TextEditingController(text: widget.payment.financeNotes ?? '');
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  void _processPayment(bool isLunas) {
    if (!isLunas && _notesCtrl.text.trim().isEmpty) {
      _notesCtrl.text = 'Nominal transfer kurang atau struk pembayaran belum sesuai.';
    }
    widget.store.verifyPayment(
      paymentId: widget.payment.paymentId,
      isLunas: isLunas,
      financeNotes: _notesCtrl.text.trim(),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isLunas ? 'Pembayaran berhasil dikonfirmasi LUNAS!' : 'Status pembayaran ditandai Bermasalah / Revisi.'),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final reg = widget.store.getRegistrationById(widget.payment.registrationId);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF8FF),
        elevation: 0,
        title: const Text('Verifikasi Pembayaran', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Billing Summary Card (Frame 405:14)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reg?.fullName ?? 'Calon Mahasiswa', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                  Text('${reg?.regCode ?? "PMB-MC-26-1"} • Jalur Microcredential', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: const Color(0xFFF4F2FF), borderRadius: BorderRadius.circular(14)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('NOMINAL TAGIHAN ADMISI', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF434655))),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Rp ${widget.payment.amount.toInt()}',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF003BA5)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(6)),
                              child: const Text('Tepat', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF059669))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Bukti Transfer Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('🧾 Bukti Transfer / Struk', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(99)),
                        child: const Text('✓ Format Valid', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF059669))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFDCE6F7)),
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: Color(0xFFDCE9FF),
                          child: Icon(Icons.image_outlined, color: Color(0xFF003BA5)),
                        ),
                        const SizedBox(height: 10),
                        const Text('Pratinjau Foto Struk Pembayaran', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                        Text('${widget.payment.proofFileName} • 1080 × 1920 px', style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Catatan Keuangan Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('📝 Catatan Keuangan (Opsional)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ActionChip(
                        label: const Text('+ Nominal Kurang', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                        onPressed: () => setState(() => _notesCtrl.text = 'Nominal transfer kurang dari tarif registrasi Rp 200.000.'),
                      ),
                      ActionChip(
                        label: const Text('+ Struk Buram', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                        onPressed: () => setState(() => _notesCtrl.text = 'Foto struk transfer buram dan nomor referensi tidak terbaca.'),
                      ),
                      ActionChip(
                        label: const Text('+ Ref Tidak Valid', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                        onPressed: () => setState(() => _notesCtrl.text = 'Nomor referensi transfer BNI tidak valid.'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _notesCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Nominal kurang / Struk tidak terbaca...',
                      filled: true,
                      fillColor: const Color(0xFFF4F2FF),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Bottom 2 Action Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => _processPayment(false),
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: const Text('Tolak / Revisi', style: TextStyle(fontWeight: FontWeight.w800)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE4E6),
                        foregroundColor: const Color(0xFFBE123C),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => _processPayment(true),
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('Konfirmasi Lunas', style: TextStyle(fontWeight: FontWeight.w800)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
