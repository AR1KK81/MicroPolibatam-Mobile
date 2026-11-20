import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

class MabaStatusScreen extends StatelessWidget {
  final PmbDataStore store;
  final void Function(int initialTab) onOpenFormulir;

  const MabaStatusScreen({
    super.key,
    required this.store,
    required this.onOpenFormulir,
  });

  @override
  Widget build(BuildContext context) {
    final reg = store.getOrCreateCurrentMabaRegistration();
    final docs = store.getDocumentsForRegistration(reg.registrationId);
    final payment = store.getPaymentForRegistration(reg.registrationId);
    final revisionCount = docs.where((d) => d.statusVerifikasi == 'revisi').length;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF8FF),
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PMB MICROCREDENTIAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
            Text('Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(color: const Color(0xFFECECFF), borderRadius: BorderRadius.circular(99)),
              child: Text(
                '• ${reg.regCode} • ${reg.fullName}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF003BA5)),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Detail Status & Berkas', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
            const Text('Rincian verifikasi pendaftaran kamu', style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B))),
            const SizedBox(height: 14),

            if (revisionCount > 0)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFFFFDAD6),
                      foregroundColor: Color(0xFF93000A),
                      child: Icon(Icons.notifications_active_outlined),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$revisionCount Berkas Perlu Tindakan', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                          const Text('Segera perbarui untuk melanjutkan seleksi', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => onOpenFormulir(1),
                      child: const Text('Revisi', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF93000A))),
                    ),
                  ],
                ),
              ),

            const Text('🛡️ Verifikasi Berkas Akademik', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            const Text('Divalidasi oleh Tim Registrasi & Admisi', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
            const SizedBox(height: 10),

            ...docs.map((doc) {
              final isRevisi = doc.statusVerifikasi == 'revisi';
              final isValid = doc.statusVerifikasi == 'valid';
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
                        Text(doc.docTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isValid
                                ? const Color(0xFFDCE9FF)
                                : (isRevisi ? const Color(0xFFFFDAD6) : const Color(0xFFFEF3C7)),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            isValid ? 'DISETUJUI' : (isRevisi ? 'PERLU REVISI' : 'MENUNGGU'),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: isValid
                                  ? const Color(0xFF003BA5)
                                  : (isRevisi ? const Color(0xFF93000A) : const Color(0xFFB45309)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(color: const Color(0xFFF4F2FF), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(doc.fileName, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                          Text(doc.fileSize, style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    if (isRevisi && doc.adminRevisionNotes != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFDAD6).withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '⚠️ Catatan Admin: ${doc.adminRevisionNotes}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF93000A), fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),

            const SizedBox(height: 10),
            const Text('💳 Verifikasi Pembayaran', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            const Text('Divalidasi oleh Bagian Keuangan Polibatam', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bukti Transfer Admisi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: payment?.statusPembayaran == 'lunas' ? const Color(0xFFDCE9FF) : const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          (payment?.statusPembayaran ?? 'BELUM BAYAR').toUpperCase(),
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF003BA5)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Metode Bayar', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      Text('Bank BNI Virtual Account', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Status Pelunasan', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      Text('Rp 200.000', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
