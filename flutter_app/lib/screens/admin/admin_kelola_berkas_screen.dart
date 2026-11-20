import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import 'admin_validasi_berkas_screen.dart';

class AdminKelolaBerkasScreen extends StatefulWidget {
  final PmbDataStore store;

  const AdminKelolaBerkasScreen({super.key, required this.store});

  @override
  State<AdminKelolaBerkasScreen> createState() => _AdminKelolaBerkasScreenState();
}

class _AdminKelolaBerkasScreenState extends State<AdminKelolaBerkasScreen> {
  String _activeTab = 'menunggu_verifikasi'; // 'menunggu_verifikasi', 'perlu_revisi', 'selesai_terverifikasi'
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final allRegs = widget.store.registrations;
    final perluCekCount = allRegs.where((r) => r.status == 'menunggu_verifikasi').length;
    final perluRevisiCount = allRegs.where((r) => r.status == 'perlu_revisi').length;
    final disetujuiCount = allRegs.where((r) => r.status == 'selesai_terverifikasi').length;

    final filtered = allRegs.where((r) {
      if (r.status != _activeTab) return false;
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return r.fullName.toLowerCase().contains(q) || r.regCode.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF8FF),
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MICRO POLIBATAM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
            Text('Kelola Berkas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting (Frame 396:9)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Halo, Admin Registrasi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
                    const Text('Panel Validasi Dokumen & Berkas Maba', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFDCE9FF), borderRadius: BorderRadius.circular(99)),
                      child: const Text('🛡️ Staf Admisi & Registrasi', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
                    ),
                  ],
                ),
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFF0052CC),
                  child: Text('AR', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 2 Stats Cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Perlu Cek', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        const SizedBox(height: 6),
                        Text('$perluCekCount Berkas', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                        const Text('Menunggu validasi', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFD97706))),
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
                        const Text('Selesai ACC', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        const SizedBox(height: 6),
                        Text('$disetujuiCount Maba', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                        const Text('Telah disetujui', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF059669))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Search Bar
            TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Cari Nama atau No. Registrasi...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),

            // 3 Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('menunggu_verifikasi', 'Perlu Cek', perluCekCount),
                  const SizedBox(width: 8),
                  _buildFilterChip('perlu_revisi', 'Perlu Revisi', perluRevisiCount),
                  const SizedBox(width: 8),
                  _buildFilterChip('selesai_terverifikasi', 'Disetujui', disetujuiCount),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Cards List
            ...filtered.map((reg) {
              final track = widget.store.getTrackById(reg.trackId);
              final docs = widget.store.getDocumentsForRegistration(reg.registrationId);
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
                          child: Text('</> ${track?.departmentName ?? "Informatika"}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: reg.status == 'selesai_terverifikasi'
                                ? const Color(0xFFD1FAE5)
                                : (reg.status == 'perlu_revisi' ? const Color(0xFFFFDAD6) : const Color(0xFFFEF3C7)),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            reg.status == 'selesai_terverifikasi'
                                ? '✓ DISETUJUI'
                                : (reg.status == 'perlu_revisi' ? '! PERLU REVISI' : '• BELUM VERIFIKASI'),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: reg.status == 'selesai_terverifikasi'
                                  ? const Color(0xFF059669)
                                  : (reg.status == 'perlu_revisi' ? const Color(0xFF93000A) : const Color(0xFFB45309)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(reg.fullName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
                    Text('${reg.regCode} • ${reg.originSchool}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF4F2FF), borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('📄 Berkas: ${docs.map((d) => d.docType.toUpperCase()).join(", ")} (${docs.length}/3)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          Text('🕒 Diunggah: ${reg.updatedAt}', style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    if (reg.status == 'perlu_revisi' && reg.adminVerificationNotes != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: const Color(0xFFFFF5F5), borderRadius: BorderRadius.circular(10)),
                        child: Text('⚠️ Catatan Admin: ${reg.adminVerificationNotes}', style: const TextStyle(fontSize: 11.5, color: Color(0xFF93000A))),
                      ),
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
                              builder: (_) => AdminValidasiBerkasScreen(store: widget.store, registration: reg),
                            ),
                          );
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0052CC),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          reg.status == 'perlu_revisi'
                              ? 'Detail & Edit Catatan →'
                              : (reg.status == 'selesai_terverifikasi' ? 'Lihat Berkas Terverifikasi →' : 'Verifikasi Berkas →'),
                          style: const TextStyle(fontWeight: FontWeight.w800),
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
