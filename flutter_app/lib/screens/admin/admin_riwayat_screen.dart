import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import 'admin_validasi_berkas_screen.dart';

/// ============================================================================
/// BAGIAN 2C: RIWAYAT VERIFIKASI BERKAS (USER ADMIN AKADEMIK)
/// Sama persis dengan `resources/views/admin/riwayat.blade.php`
/// ============================================================================
class AdminRiwayatScreen extends StatefulWidget {
  final PmbDataStore store;

  const AdminRiwayatScreen({super.key, required this.store});

  @override
  State<AdminRiwayatScreen> createState() => _AdminRiwayatScreenState();
}

class _AdminRiwayatScreenState extends State<AdminRiwayatScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final allHistory = widget.store.registrations
        .where((r) => r.status != 'menunggu_verifikasi')
        .toList();

    final historyList = allHistory.where((r) {
      if (_search.isEmpty) return true;
      final q = _search.toLowerCase();
      return r.fullName.toLowerCase().contains(q) || r.regCode.toLowerCase().contains(q);
    }).toList();

    return Column(
      children: [
        // Top Header (`PMB MICROCREDENTIAL / Riwayat` + User Circle)
        Container(
          height: 64,
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
                    'Riwayat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF161A30),
                    ),
                  ),
                  Text(
                    'Rekam jejak aktivitas verifikasi berkas Maba',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
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
                // Search Bar
                TextField(
                  onChanged: (v) => setState(() => _search = v),
                  style: const TextStyle(fontSize: 13, color: Color(0xFF161A30)),
                  decoration: InputDecoration(
                    hintText: 'Cari pendaftar atau ID registrasi...',
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

                // Filter Pills (`Semua (N)`, `Hari Ini`)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF003BA5),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Semua (${historyList.length})',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Text(
                        'Hari Ini',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                if (historyList.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFECEEF8)),
                    ),
                    child: const Text(
                      'Belum ada riwayat verifikasi berkas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                  )
                else
                  ...historyList.map((reg) {
                    final track = widget.store.getTrackById(reg.trackId);
                    final isApproved = reg.status == 'selesai_terverifikasi';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isApproved
                              ? const Color(0xFFECEEF8)
                              : const Color(0xFFFECDD3),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: isApproved
                                ? null
                                : const Border(
                                    left: BorderSide(color: Color(0xFFE11D48), width: 4),
                                  ),
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
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: isApproved
                                              ? const Color(0xFFD1FAE5)
                                              : const Color(0xFFFFDAD6),
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          isApproved ? '✓' : '!',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w900,
                                            color: isApproved
                                                ? const Color(0xFF059669)
                                                : const Color(0xFF93000A),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            isApproved ? 'Berkas Disetujui' : 'Catatan Revisi Dikirim',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF161A30),
                                            ),
                                          ),
                                          Text(
                                            '🕒 ${reg.updatedAt}',
                                            style: const TextStyle(
                                              fontSize: 10.5,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isApproved
                                          ? const Color(0xFFD1FAE5)
                                          : const Color(0xFFFFDAD6),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      isApproved ? 'ACC' : 'REVISI',
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w800,
                                        color: isApproved
                                            ? const Color(0xFF065F46)
                                            : const Color(0xFF93000A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F2FF),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          reg.fullName,
                                          style: const TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF161A30),
                                          ),
                                        ),
                                        Text(
                                          reg.regCode,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
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
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (!isApproved && reg.adminVerificationNotes != null)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF5F5),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFFECDD3)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '⚠️ ALASAN PENOLAKAN',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF93000A),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        reg.adminVerificationNotes!,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF7F1D1D),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                const Text(
                                  'Semua berkas persyaratan lolos validasi akademik dan diteruskan ke verifikasi keuangan.',
                                  style: TextStyle(fontSize: 11.5, color: Color(0xFF434655)),
                                ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '🪪 Admin Registrasi',
                                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                  ),
                                  InkWell(
                                    onTap: () {
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
                                    child: const Text(
                                      'Detail ›',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0052CC),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                const SizedBox(height: 6),
                // Export CSV Button (`⬇ Unduh Rekapitulasi Audit (.CSV)`)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Mengunduh rekapitulasi_audit_berkas_pmb.csv (${historyList.length} baris)...',
                          ),
                          backgroundColor: const Color(0xFF003BA5),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF003BA5),
                      side: const BorderSide(color: Color(0xFFBFD4FF)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      '⬇ Unduh Rekapitulasi Audit (.CSV)',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                    ),
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
