import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

class AdminValidasiBerkasScreen extends StatefulWidget {
  final PmbDataStore store;
  final RegistrationItem registration;

  const AdminValidasiBerkasScreen({
    super.key,
    required this.store,
    required this.registration,
  });

  @override
  State<AdminValidasiBerkasScreen> createState() => _AdminValidasiBerkasScreenState();
}

class _AdminValidasiBerkasScreenState extends State<AdminValidasiBerkasScreen> {
  final Map<int, String> _docStatuses = {};
  late TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    final docs = widget.store.getDocumentsForRegistration(widget.registration.registrationId);
    for (final d in docs) {
      _docStatuses[d.documentId] = d.statusVerifikasi == 'revisi' ? 'revisi' : 'valid';
    }
    _notesCtrl = TextEditingController(
      text: widget.registration.adminVerificationNotes ??
          'Foto KTP buram dan nomor NIK tidak terbaca dengan jelas. Silakan unggah ulang scan KTP asli via portal web resmi PMB.',
    );
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  void _submitVerification(bool approveAll) {
    widget.store.verifyRegistrationDocuments(
      registrationId: widget.registration.registrationId,
      approveAll: approveAll,
      perDocStatus: _docStatuses,
      revisionNotes: _notesCtrl.text.trim(),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          approveAll
              ? 'Seluruh berkas ${widget.registration.fullName} berhasil di-ACC!'
              : 'Catatan revisi untuk ${widget.registration.fullName} berhasil dikirim!',
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final reg = widget.registration;
    final docs = widget.store.getDocumentsForRegistration(reg.registrationId);
    final track = widget.store.getTrackById(reg.trackId);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF8FF),
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Validasi Berkas Maba', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
            Text('Politeknik Negeri Batam', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Candidate Profile Card (Frame 396:16)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: const Color(0xFF0052CC),
                        child: Text(reg.initials, style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(reg.fullName, style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800)),
                            Text('🪪 NIK: ${reg.nik}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: const Color(0xFFF4F2FF), borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Jalur: ${track?.trackName ?? "Microcredential"}', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                        const Text('Semester Ganjil', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dokumen Persyaratan', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800)),
                Text('${docs.length} Dokumen Wajib', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF434655))),
              ],
            ),
            const Text('Periksa keaslian dan kejelasan berkas digital calon mahasiswa', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            const SizedBox(height: 12),

            ...docs.map((doc) {
              final currentChoice = _docStatuses[doc.documentId] ?? 'valid';
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc.docTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                            Text('${doc.fileName} • ${doc.fileSize}', style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: currentChoice == 'valid' ? const Color(0xFFD1FAE5) : const Color(0xFFFFDAD6),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            currentChoice == 'valid' ? '✓ Valid' : '! Perlu Cek',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: currentChoice == 'valid' ? const Color(0xFF059669) : const Color(0xFF93000A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('Status Validasi Berkas:', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => setState(() => _docStatuses[doc.documentId] = 'valid'),
                            icon: const Icon(Icons.check_circle, size: 16),
                            label: const Text('Setujui'),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: currentChoice == 'valid' ? const Color(0xFFD1FAE5) : const Color(0xFFF8FAFC),
                              foregroundColor: currentChoice == 'valid' ? const Color(0xFF065F46) : const Color(0xFF475569),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => setState(() => _docStatuses[doc.documentId] = 'revisi'),
                            icon: const Icon(Icons.cancel_outlined, size: 16),
                            label: const Text('Minta Revisi'),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: currentChoice == 'revisi' ? const Color(0xFFFFDAD6) : const Color(0xFFF8FAFC),
                              foregroundColor: currentChoice == 'revisi' ? const Color(0xFF93000A) : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            // Catatan Revisi untuk Maba
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFED7D7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('📝 Catatan Revisi untuk Maba', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  const Text(
                    'Catatan ini akan langsung dikirim ke notifikasi aplikasi & email calon mahasiswa.',
                    style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _notesCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 2 Action Buttons
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => _submitVerification(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFDAD6),
                  foregroundColor: const Color(0xFF93000A),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                ),
                child: const Text('Tolak & Kirim Catatan Revisi', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => _submitVerification(true),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('ACC & Disetujui Semuanya', style: TextStyle(fontWeight: FontWeight.w800)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0052CC),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
