import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

class MabaBerandaScreen extends StatelessWidget {
  final PmbDataStore store;
  final void Function(int initialTab) onOpenFormulir;
  final void Function(int navIndex) onSwitchTab;

  const MabaBerandaScreen({
    super.key,
    required this.store,
    required this.onOpenFormulir,
    required this.onSwitchTab,
  });

  @override
  Widget build(BuildContext context) {
    final reg = store.getOrCreateCurrentMabaRegistration();
    final track = store.getTrackById(reg.trackId);
    final payment = store.getPaymentForRegistration(reg.registrationId);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF8FF),
        elevation: 0,
        title: const Text('Beranda', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
        actions: [
          IconButton(
            onPressed: () => onSwitchTab(2),
            icon: const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF003BA5),
              child: Icon(Icons.person_outline, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Row (Frame 282:1243)
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFD6E3FE),
                  child: Text(
                    reg.initials,
                    style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF003BA5)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, ${reg.fullName} 👋',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF161A30)),
                      ),
                      const Text(
                        'Calon Mahasiswa - Jalur Microcredential',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // No. Registrasi & Program Pilihan Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFECEEF8)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('NO. REGISTRASI', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                        const SizedBox(height: 4),
                        Text(reg.regCode, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 32, color: const Color(0xFFE8ECF8)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('PROGRAM PILIHAN', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                        const SizedBox(height: 4),
                        Text(
                          (track?.departmentName ?? 'INFORMATIKA').toUpperCase(),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF003BA5)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Akses Portal Pendaftaran CTA Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF1FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD6E3FE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline_rounded, color: Color(0xFF003BA5)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Akses Portal Pendaftaran',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF161A30)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Pengisian biodata, unggah 3 berkas wajib (KTP, KK, Ijazah), dan bukti pembayaran BNI dapat dilakukan langsung melalui formulir di bawah ini.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF434655), height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => onOpenFormulir(0),
                    icon: const Icon(Icons.edit_document, size: 17),
                    label: const Text('Buka Formulir 3-Tahap (Biodata, Dokumen, Bayar BNI)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003BA5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Status Pendaftaran
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Status Pendaftaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
                TextButton(
                  onPressed: () => onSwitchTab(1),
                  child: const Text('Terkini', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF003BA5))),
                ),
              ],
            ),
            _buildStatusTile(
              icon: Icons.assignment_outlined,
              title: 'Verifikasi Berkas & Ijazah',
              subtitle: 'Divalidasi oleh Admin Registrasi',
              badgeText: reg.status == 'selesai_terverifikasi'
                  ? '✓ VALID'
                  : (reg.status == 'perlu_revisi' ? '! PERLU REVISI' : '• SEDANG DIPROSES'),
              badgeColor: reg.status == 'selesai_terverifikasi'
                  ? const Color(0xFFD1FAE5)
                  : (reg.status == 'perlu_revisi' ? const Color(0xFFFFDAD6) : const Color(0xFFFEF3C7)),
              textColor: reg.status == 'selesai_terverifikasi'
                  ? const Color(0xFF059669)
                  : (reg.status == 'perlu_revisi' ? const Color(0xFF93000A) : const Color(0xFFB45309)),
              onTap: () => onOpenFormulir(1),
            ),
            const SizedBox(height: 10),
            _buildStatusTile(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Verifikasi Pembayaran',
              subtitle: 'Divalidasi oleh Staf Keuangan',
              badgeText: payment?.statusPembayaran == 'lunas'
                  ? '✓ LUNAS / DISETUJUI'
                  : (payment?.statusPembayaran == 'ditolak' ? '! PERLU REVISI' : '• MENUNGGU'),
              badgeColor: payment?.statusPembayaran == 'lunas'
                  ? const Color(0xFFD1FAE5)
                  : (payment?.statusPembayaran == 'ditolak' ? const Color(0xFFFFDAD6) : const Color(0xFFFEF3C7)),
              textColor: payment?.statusPembayaran == 'lunas'
                  ? const Color(0xFF059669)
                  : (payment?.statusPembayaran == 'ditolak' ? const Color(0xFF93000A) : const Color(0xFFB45309)),
              onTap: () => onOpenFormulir(2),
            ),
            const SizedBox(height: 18),

            // Tahapan Pendaftaran Stepper Card
            const Text('Tahapan Pendaftaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFECEEF8)),
              ),
              child: Column(
                children: [
                  _buildStepRow('1', 'Pengisian Data & Berkas', 'Selesai di Portal', 'SELESAI', true),
                  const Divider(height: 22),
                  _buildStepRow('2', 'Verifikasi Berkas', 'Pengecekan Ijazah & KTP oleh Admin', 'DIPROSES', reg.status == 'selesai_terverifikasi'),
                  const Divider(height: 22),
                  _buildStepRow('3', 'Verifikasi Pembayaran', 'Pengecekan bukti transfer oleh Staf Keuangan', (payment?.statusPembayaran ?? 'MENUNGGU').toUpperCase(), payment?.statusPembayaran == 'lunas'),
                  const Divider(height: 22),
                  _buildStepRow('4', 'Status Akhir Pendaftaran', 'Pendaftaran Resmi Terverifikasi', 'MENUNGGU', reg.status == 'selesai_terverifikasi' && payment?.statusPembayaran == 'lunas'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFECEEF8)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: const Color(0xFF003BA5)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
                  Text(subtitle, style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(99)),
              child: Text(badgeText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: textColor)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepRow(String stepNum, String title, String subtitle, String rightStatus, bool isDone) {
    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: isDone ? const Color(0xFF003BA5) : const Color(0xFFF1F5F9),
          child: isDone
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : Text(stepNum, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
              Text(subtitle, style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
            ],
          ),
        ),
        Text(
          rightStatus,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
            color: isDone ? const Color(0xFF003BA5) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}
