import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

/// ============================================================================
/// BAGIAN 2B: HALAMAN DETAIL VALIDASI BERKAS MABA (USER ADMIN AKADEMIK)
/// Sama persis dengan `resources/views/admin/verify.blade.php`
/// ============================================================================
class AdminValidasiBerkasScreen extends StatefulWidget {
  final PmbDataStore store;
  final int registrationId;

  const AdminValidasiBerkasScreen({
    super.key,
    required this.store,
    required this.registrationId,
  });

  @override
  State<AdminValidasiBerkasScreen> createState() => _AdminValidasiBerkasScreenState();
}

class _AdminValidasiBerkasScreenState extends State<AdminValidasiBerkasScreen> {
  final Map<int, String> _perDocStatus = {};
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final reg = widget.store.getRegistrationById(widget.registrationId)!;
    final docs = widget.store.getDocumentsForRegistration(widget.registrationId);
    for (final d in docs) {
      _perDocStatus[d.documentId] = d.statusVerifikasi == 'revisi' ? 'revisi' : 'valid';
    }
    _notesController = TextEditingController(
      text: reg.adminVerificationNotes ??
          'Foto KTP buram dan nomor NIK tidak terbaca dengan jelas. Silakan unggah ulang scan KTP asli via portal resmi PMB.',
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submitDecision(bool approveAll) {
    widget.store.verifyRegistrationDocuments(
      registrationId: widget.registrationId,
      approveAll: approveAll,
      perDocStatus: _perDocStatus,
      revisionNotes: _notesController.text.trim(),
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          approveAll
              ? 'Semua berkas pendaftar berhasil di-ACC!'
              : 'Catatan revisi berkas berhasil dikirim ke pendaftar.',
        ),
        backgroundColor: approveAll ? const Color(0xFF059669) : const Color(0xFFBA1A1A),
      ),
    );
  }

  void _previewAttachment(DocumentItem doc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          doc.docTitle,
          style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F2FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFBFD4FF)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.description_outlined, size: 42, color: Color(0xFF0052CC)),
                  const SizedBox(height: 10),
                  Text(
                    doc.fileName,
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    '${doc.fileSize} • Diunggah ${doc.uploadedDate}',
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup Pratinjau'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reg = widget.store.getRegistrationById(widget.registrationId)!;
    final track = widget.store.getTrackById(reg.trackId);
    final docs = widget.store.getDocumentsForRegistration(widget.registrationId);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header (`← Validasi Berkas Maba / Politeknik Negeri Batam` + User Circle)
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
                            'Validasi Berkas Maba',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF161A30),
                            ),
                          ),
                          Text(
                            'Politeknik Negeri Batam',
                            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
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
                    child: const Icon(Icons.person_outline, size: 18, color: Colors.white),
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
                            reg.regCode,
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
                            color: reg.status == 'selesai_terverifikasi'
                                ? const Color(0xFFD1FAE5)
                                : reg.status == 'perlu_revisi'
                                    ? const Color(0xFFFFDAD6)
                                    : const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '• Status: ${reg.status.replaceAll('_', ' ').toUpperCase()}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: reg.status == 'selesai_terverifikasi'
                                  ? const Color(0xFF065F46)
                                  : reg.status == 'perlu_revisi'
                                      ? const Color(0xFF93000A)
                                      : const Color(0xFFB45309),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Applicant Card
                    Container(
                      padding: const EdgeInsets.all(16),
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
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0052CC),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  reg.initials,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reg.fullName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF161A30),
                                    ),
                                  ),
                                  Text(
                                    '🪪 NIK: ${reg.nik}',
                                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F2FF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Jalur: Microcredential Batch 1 2026',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF161A30),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDCE9FF),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: const Text(
                                        'Semester Ganjil',
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF003BA5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Asal Sekolah: ${reg.originSchool} • TTL: ${reg.birthPlace}, ${reg.birthDate}',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Dokumen Persyaratan Heading
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Dokumen Persyaratan',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF161A30),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1EFFF),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${docs.length} Dokumen Wajib',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF003BA5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Periksa keaslian dan kejelasan berkas digital calon mahasiswa',
                      style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 12),

                    // Document List Cards
                    ...docs.map((doc) {
                      final currentChoice = _perDocStatus[doc.documentId] ?? 'valid';
                      final isValidChoice = currentChoice == 'valid';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: !isValidChoice
                                ? const Color(0xFFFECDD3)
                                : const Color(0xFFECEEF8),
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
                                          color: const Color(0xFFFFDAD6),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text('📄', style: TextStyle(fontSize: 16)),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              doc.docTitle,
                                              style: const TextStyle(
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFF161A30),
                                              ),
                                            ),
                                            Text(
                                              '${doc.fileName} • ${doc.fileSize}',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFF64748B),
                                              ),
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
                                    color: isValidChoice
                                        ? const Color(0xFFD1FAE5)
                                        : const Color(0xFFFFDAD6),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    isValidChoice ? '✓ Valid' : '! Perlu Revisi',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: isValidChoice
                                          ? const Color(0xFF065F46)
                                          : const Color(0xFF93000A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Buka Lampiran Bar (`#EBF2FF`)
                            InkWell(
                              onTap: () => _previewAttachment(doc),
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEBF2FF),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '👁️ Buka Lampiran (${doc.fileName})',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF003BA5),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      '↗',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF003BA5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            const Text(
                              'Status Validasi Berkas:',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 6),

                            // 2-Column Custom Toggle Buttons (`✓ Setujui` vs `✕ Minta Revisi`)
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () => setState(() => _perDocStatus[doc.documentId] = 'valid'),
                                    borderRadius: BorderRadius.circular(14),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isValidChoice
                                            ? const Color(0xFFD1FAE5)
                                            : const Color(0xFFF4F2FF),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: isValidChoice
                                              ? const Color(0xFF059669)
                                              : Colors.transparent,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '✓ Setujui',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: isValidChoice
                                              ? const Color(0xFF065F46)
                                              : const Color(0xFF525866),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => setState(() => _perDocStatus[doc.documentId] = 'revisi'),
                                    borderRadius: BorderRadius.circular(14),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: !isValidChoice
                                            ? const Color(0xFFFFDAD6)
                                            : const Color(0xFFF4F2FF),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: !isValidChoice
                                              ? const Color(0xFFBA1A1A)
                                              : Colors.transparent,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '✕ Minta Revisi',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: !isValidChoice
                                              ? const Color(0xFF93000A)
                                              : const Color(0xFF525866),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),

                    // Catatan Revisi untuk Maba Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFECEEF8)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '💬 Catatan Revisi untuk Maba',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF161A30),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Catatan ini akan langsung dikirim ke notifikasi aplikasi & dashboard calon mahasiswa.',
                            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _notesController,
                            maxLines: 3,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(fontSize: 12.5, color: Color(0xFF161A30)),
                            decoration: InputDecoration(
                              hintText: 'Contoh: Foto KTP buram dan nomor NIK tidak terbaca dengan jelas...',
                              filled: true,
                              fillColor: const Color(0xFFF4F2FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Maks. 500 karakter',
                                style: TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
                              ),
                              Text(
                                '${_notesController.text.length} / 500',
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0052CC),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Bar (`🚩 Tolak & Kirim Catatan Revisi` + `ACC & Disetujui Semuanya →`)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFFBF8FF),
                border: Border(top: BorderSide(color: Color(0xFFE6E8F2))),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _submitDecision(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFDAD6),
                        foregroundColor: const Color(0xFF93000A),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        '🚩 Tolak & Kirim Catatan Revisi',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _submitDecision(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0052CC),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        'ACC & Disetujui Semuanya →',
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
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
}
