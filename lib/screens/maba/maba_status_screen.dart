import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import 'maba_formulir_screen.dart';

/// ============================================================================
/// BAGIAN 1C: STATUS PENDAFTAR & BERKAS (USER MABA)
/// Sama persis dengan `resources/views/maba/status.blade.php`
/// ============================================================================
class MabaStatusScreen extends StatelessWidget {
  final PmbDataStore store;
  final ValueChanged<int>? onSwitchTab;

  const MabaStatusScreen({
    super.key,
    required this.store,
    this.onSwitchTab,
  });

  void _openFormulir(BuildContext context, {int initialStep = 1}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MabaFormulirScreen(
          store: store,
          initialStep: initialStep,
          onOpenStatusTab: () => onSwitchTab?.call(1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reg = store.getOrCreateCurrentMabaRegistration();
    final docs = store.getDocumentsForRegistration(reg.registrationId);
    final payment = store.getPaymentForRegistration(reg.registrationId);
    final rek = store.mainRekening;
    final revisionCount = docs.where((d) => d.statusVerifikasi == 'revisi').length;

    return Column(
      children: [
        // Top Header (`PMB MICROCREDENTIAL / Status` + `Formulir →` + User Avatar)
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
                    'PMB MICROCREDENTIAL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: Color(0xFF0052CC),
                    ),
                  ),
                  Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF003BA5),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => _openFormulir(context, initialStep: 1),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCE9FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Formulir →',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF003BA5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => onSwitchTab?.call(2),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Color(0xFF003BA5),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.person_outline, size: 18, color: Colors.white),
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
                // Reg Pill + Detail Status & Berkas Heading + Graduation Cap Box
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCE9FF),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '• ${reg.regCode} • ${reg.fullName}',
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF003BA5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Detail Status & Berkas',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF161A30),
                            ),
                          ),
                          const Text(
                            'Rincian verifikasi pendaftaran kamu',
                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF2FF),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.school_outlined, color: Color(0xFF0052CC), size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Alert if any document needs revision
                if (revisionCount > 0)
                  InkWell(
                    onTap: () => _openFormulir(context, initialStep: 2),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5F5),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFFECDD3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFDAD6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Text('🔔', style: TextStyle(fontSize: 16)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$revisionCount Berkas Perlu Tindakan',
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF93000A),
                                  ),
                                ),
                                const Text(
                                  'Segera perbarui untuk melanjutkan seleksi',
                                  style: TextStyle(fontSize: 11, color: Color(0xFF7F1D1D)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFDAD6),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'Revisi →',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF93000A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Section 1: Verifikasi Berkas Akademik
                const Text(
                  '☑️ Verifikasi Berkas Akademik',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF161A30),
                  ),
                ),
                const Text(
                  'Divalidasi oleh Tim Registrasi & Admisi',
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 10),

                ...docs.map((doc) {
                  final isValid = doc.statusVerifikasi == 'valid';
                  final isRevisi = doc.statusVerifikasi == 'revisi';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isRevisi ? const Color(0xFFFECDD3) : const Color(0xFFECEEF8),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: isRevisi
                                          ? const Color(0xFFFFDAD6)
                                          : const Color(0xFFEBF2FF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      doc.docType == 'ktp'
                                          ? '🪪'
                                          : doc.docType == 'kk'
                                              ? '👨‍👩‍👧'
                                              : '📄',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          doc.docTitle,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF161A30),
                                          ),
                                        ),
                                        const Text(
                                          'Diverifikasi Admin Registrasi',
                                          style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                              decoration: BoxDecoration(
                                color: isValid
                                    ? const Color(0xFFDCE9FF)
                                    : isRevisi
                                        ? const Color(0xFFFFDAD6)
                                        : const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                isValid
                                    ? 'DISETUJUI'
                                    : isRevisi
                                        ? 'PERLU REVISI'
                                        : 'MENUNGGU',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: isValid
                                      ? const Color(0xFF003BA5)
                                      : isRevisi
                                          ? const Color(0xFF93000A)
                                          : const Color(0xFFB45309),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F2FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '📎 ${doc.fileName}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF434655),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => _openFormulir(context, initialStep: 2),
                                child: const Text(
                                  'Ubah',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0052CC),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isRevisi && doc.adminRevisionNotes != null) ...[
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF5F5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFFECDD3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '⚠️ Catatan Admin:',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF93000A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  doc.adminRevisionNotes!,
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF7F1D1D)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () => _openFormulir(context, initialStep: 2),
                            child: const Text(
                              '⊗ Unggah ulang diperlukan →',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFBA1A1A),
                              ),
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isValid ? '✓ Lengkap & Valid' : '🕒 Menunggu pemeriksaan admin',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF003BA5),
                                ),
                              ),
                              Text(
                                doc.uploadedDate,
                                style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 10),

                // Section 2: Verifikasi Pembayaran
                const Text(
                  '💳 Verifikasi Pembayaran',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF161A30),
                  ),
                ),
                const Text(
                  'Divalidasi oleh Bagian Keuangan Polibatam',
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFECEEF8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEBF2FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: const Text('🧾', style: TextStyle(fontSize: 16)),
                              ),
                              const SizedBox(width: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bukti Transfer Admisi',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF161A30),
                                    ),
                                  ),
                                  Text(
                                    'Diverifikasi Staf Keuangan',
                                    style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                            decoration: BoxDecoration(
                              color: payment?.statusPembayaran == 'lunas'
                                  ? const Color(0xFFDCE9FF)
                                  : payment?.statusPembayaran == 'ditolak'
                                      ? const Color(0xFFFFDAD6)
                                      : const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              payment?.statusPembayaran == 'lunas'
                                  ? 'DISETUJUI'
                                  : payment?.statusPembayaran == 'ditolak'
                                      ? 'DITOLAK'
                                      : 'MENUNGGU',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: payment?.statusPembayaran == 'lunas'
                                    ? const Color(0xFF003BA5)
                                    : payment?.statusPembayaran == 'ditolak'
                                        ? const Color(0xFF93000A)
                                        : const Color(0xFFB45309),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
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
                                  'Metode Bayar',
                                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                ),
                                Text(
                                  'Transfer Rekening ${rek.bankName}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
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
                                  'No. Rekening Tujuan',
                                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                ),
                                Text(
                                  rek.accountNumber,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
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
                                  'Status Pelunasan',
                                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                ),
                                Text(
                                  payment == null
                                      ? 'Belum Unggah Bukti'
                                      : payment.statusPembayaran == 'lunas'
                                          ? 'Lunas Rp 200.000'
                                          : 'Rp ${payment.amount.toInt()} (${payment.statusPembayaran.toUpperCase()})',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF003BA5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (payment?.financeNotes != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF5F5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFECDD3)),
                          ),
                          child: Text(
                            'Catatan Staf Keuangan: ${payment!.financeNotes!}',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF93000A)),
                          ),
                        ),
                      ],
                    ],
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
