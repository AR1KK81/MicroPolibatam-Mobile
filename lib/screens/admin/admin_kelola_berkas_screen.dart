import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import '../../widgets/pmb_widgets.dart';
import 'admin_validasi_berkas_screen.dart';

/// ============================================================================
/// BAGIAN 2A: KELOLA BERKAS PENDAFTAR (USER ADMIN AKADEMIK)
/// Sama persis dengan `resources/views/admin/dashboard.blade.php`
/// ============================================================================
class AdminKelolaBerkasScreen extends StatefulWidget {
  final PmbDataStore store;

  const AdminKelolaBerkasScreen({super.key, required this.store});

  @override
  State<AdminKelolaBerkasScreen> createState() => _AdminKelolaBerkasScreenState();
}

class _AdminKelolaBerkasScreenState extends State<AdminKelolaBerkasScreen> {
  String _tab = 'perlu_cek'; // 'perlu_cek', 'perlu_revisi', 'disetujui'
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final allRegs = widget.store.registrations;
    final perluCekCount = allRegs.where((r) => r.status == 'menunggu_verifikasi').length;
    final perluRevisiCount = allRegs.where((r) => r.status == 'perlu_revisi').length;
    final disetujuiCount = allRegs.where((r) => r.status == 'selesai_terverifikasi').length;

    final filtered = allRegs.where((r) {
      if (_tab == 'perlu_cek' && r.status != 'menunggu_verifikasi') return false;
      if (_tab == 'perlu_revisi' && r.status != 'perlu_revisi') return false;
      if (_tab == 'disetujui' && r.status != 'selesai_terverifikasi') return false;
      if (_search.isNotEmpty) {
        final q = _search.toLowerCase();
        return r.fullName.toLowerCase().contains(q) ||
            r.regCode.toLowerCase().contains(q) ||
            r.nik.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return Column(
      children: [
        // Top Header (`MICRO POLIBATAM / Kelola Berkas` + Bell + `AR`)
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
                    'MICRO POLIBATAM',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: Color(0xFF0052CC),
                    ),
                  ),
                  Text(
                    'Kelola Berkas',
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
                      'AR',
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
                // Greeting Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Halo, Admin Registrasi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF161A30),
                          ),
                        ),
                        const Text(
                          'Panel Validasi Dokumen & Berkas Maba',
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCE9FF),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            '🛡️ Staf Admisi & Registrasi',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF003BA5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0052CC),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'AR',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 2 Stat Cards (`Perlu Cek` & `Selesai ACC`)
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Perlu Cek',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text('📋', style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$perluCekCount Berkas',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF161A30),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Menunggu validasi',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFD97706),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Selesai ACC',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD1FAE5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '✓',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF059669),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$disetujuiCount Maba',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF161A30),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Telah disetujui',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Search Bar
                TextField(
                  onChanged: (v) => setState(() => _search = v),
                  style: const TextStyle(fontSize: 13, color: Color(0xFF161A30)),
                  decoration: InputDecoration(
                    hintText: 'Cari Nama atau No. Registrasi...',
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

                // Custom Filter Pill Tabs (`Perlu Cek`, `Perlu Revisi`, `Disetujui`)
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
                        label: 'Perlu Revisi',
                        badgeCount: '$perluRevisiCount',
                        isSelected: _tab == 'perlu_revisi',
                        activeBgColor: const Color(0xFF0052CC),
                        onTap: () => setState(() => _tab = 'perlu_revisi'),
                      ),
                      const SizedBox(width: 8),
                      PmbPillTab(
                        label: 'Disetujui',
                        badgeCount: '$disetujuiCount',
                        isSelected: _tab == 'disetujui',
                        activeBgColor: const Color(0xFF0052CC),
                        onTap: () => setState(() => _tab = 'disetujui'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Daftar Berkas Masuk Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Daftar Berkas Masuk',
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
                            color: const Color(0xFFDCE9FF),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${filtered.length} Antrean',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF003BA5),
                            ),
                          ),
                        ),
                      ],
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
                      'Tidak ada berkas pendaftar pada kategori ini.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                  )
                else
                  ...filtered.map((reg) {
                    final track = widget.store.getTrackById(reg.trackId);
                    final docs = widget.store.getDocumentsForRegistration(reg.registrationId);
                    final isPending = reg.status == 'menunggu_verifikasi';
                    final isRevisi = reg.status == 'perlu_revisi';

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
                                  '<> ${track?.departmentName ?? 'Informatika'}',
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
                                      : isRevisi
                                          ? const Color(0xFFFFDAD6)
                                          : const Color(0xFFD1FAE5),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  isPending
                                      ? '• BELUM VERIFIKASI'
                                      : isRevisi
                                          ? '• PERLU REVISI'
                                          : '✓ DISETUJUI / VALID',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: isPending
                                        ? const Color(0xFFB45309)
                                        : isRevisi
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
                                    reg.fullName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF161A30),
                                    ),
                                  ),
                                  Text(
                                    reg.regCode,
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
                                  reg.initials,
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

                          if (isRevisi && reg.adminVerificationNotes != null)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF5F5),
                                borderRadius: BorderRadius.circular(14),
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
                                    reg.adminVerificationNotes!,
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF7F1D1D)),
                                  ),
                                ],
                              ),
                            )
                          else if (reg.status == 'selesai_terverifikasi')
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFA7F3D0)),
                              ),
                              child: Text(
                                '✓ Verifikasi Berkas Selesai | ${reg.updatedAt}',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF065F46),
                                ),
                              ),
                            )
                          else
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
                                  Text(
                                    '📄 Berkas: Ijazah/SKL, KK & KTP (${docs.length} file)',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF434655),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '🕒 Diunggah: ${reg.updatedAt}',
                                    style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            child: isPending
                                ? ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AdminValidasiBerkasScreen(
                                            store: widget.store,
                                            registrationId: reg.registrationId,
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
                                      'Verifikasi Berkas →',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                                    ),
                                  )
                                : OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AdminValidasiBerkasScreen(
                                            store: widget.store,
                                            registrationId: reg.registrationId,
                                          ),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFF003BA5),
                                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Text(
                                      isRevisi
                                          ? 'Detail & Edit Catatan →'
                                          : 'Lihat Berkas Terverifikasi →',
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
