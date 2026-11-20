import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import '../../widgets/pmb_widgets.dart';
import 'maba_formulir_screen.dart';

/// ============================================================================
/// BAGIAN 1A: BERANDA PENDAFTAR (USER MABA)
/// Sama persis dengan `resources/views/maba/beranda.blade.php`
/// ============================================================================
class MabaBerandaScreen extends StatelessWidget {
  final PmbDataStore store;
  final ValueChanged<int>? onSwitchTab;

  const MabaBerandaScreen({
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
    final track = store.getTrackById(reg.trackId);
    final docs = store.getDocumentsForRegistration(reg.registrationId);
    final payment = store.getPaymentForRegistration(reg.registrationId);

    final hasRevision = reg.status == 'perlu_revisi' ||
        docs.any((d) => d.statusVerifikasi == 'revisi');
    final isDocsApproved = reg.status == 'selesai_terverifikasi' ||
        (docs.isNotEmpty && docs.every((d) => d.statusVerifikasi == 'valid'));
    final isPaymentLunas = payment?.statusPembayaran == 'lunas';
    final isPaymentDitolak = payment?.statusPembayaran == 'ditolak';

    return Column(
      children: [
        // Top Header (`Beranda` + `?` button + Profile Circle)
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Color(0xFFFBF8FF),
            border: Border(bottom: BorderSide(color: Color(0xFFEAE8F5))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Beranda',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF003BA5),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => showPmbHelpdeskModal(context, store),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE1E6F5)),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF434655),
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
                // Greeting & Registration Summary Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFECEEF8)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFDCE9FF),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    reg.initials,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF003BA5),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              'Halo, ${reg.fullName}',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 16.5,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFF161A30),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFFEF3C7),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.check,
                                              size: 10,
                                              color: Color(0xFFD97706),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Calon Mahasiswa • Jalur Microcredential',
                                        style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => onSwitchTab?.call(1),
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFE8ECF8)),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.notifications_none,
                                size: 18,
                                color: Color(0xFF434655),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Divider(color: Color(0xFFF0EEF8), height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'NO. REGISTRASI',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                reg.regCode,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF161A30),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'PROGRAM PILIHAN',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                (track?.departmentName ?? 'INFORMATIKA').toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0052CC),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Interactive Portal Pendaftaran Link
                      InkWell(
                        onTap: () => _openFormulir(context, initialStep: 1),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBF2FF),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFBFD4FF)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCE9FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.info_outline,
                                  color: Color(0xFF0052CC),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Akses Portal Pendaftaran',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF003BA5),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Klik untuk mengisi biodata, unggah berkas (KTP, KK, Ijazah), dan bukti transfer BNI.',
                                      style: TextStyle(
                                        fontSize: 11,
                                        height: 1.3,
                                        color: Color(0xFF43485B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0052CC),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Buka →',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Status Pendaftaran Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Status Pendaftaran',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF161A30),
                      ),
                    ),
                    InkWell(
                      onTap: () => onSwitchTab?.call(1),
                      child: const Text(
                        'Lihat Detail →',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0052CC),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Card 1: Verifikasi Berkas & Ijazah
                InkWell(
                  onTap: () => onSwitchTab?.call(1),
                  borderRadius: BorderRadius.circular(16),
                  child: _buildStatusRowCard(
                    icon: Icons.description_outlined,
                    title: 'Verifikasi Berkas & Ijazah',
                    subtitle: 'Divalidasi oleh Admin Registrasi',
                    badgeText: isDocsApproved
                        ? 'DISETUJUI'
                        : hasRevision
                            ? 'PERLU REVISI'
                            : 'SEDANG DIPROSES',
                    badgeBg: isDocsApproved
                        ? const Color(0xFFD1FAE5)
                        : hasRevision
                            ? const Color(0xFFFFDAD6)
                            : const Color(0xFFFEF3C7),
                    badgeTextColor: isDocsApproved
                        ? const Color(0xFF065F46)
                        : hasRevision
                            ? const Color(0xFF93000A)
                            : const Color(0xFFB45309),
                  ),
                ),
                const SizedBox(height: 10),

                // Card 2: Verifikasi Pembayaran
                InkWell(
                  onTap: () => _openFormulir(context, initialStep: 3),
                  borderRadius: BorderRadius.circular(16),
                  child: _buildStatusRowCard(
                    icon: Icons.payments_outlined,
                    title: 'Verifikasi Pembayaran',
                    subtitle: 'Divalidasi oleh Staf Keuangan',
                    badgeText: isPaymentLunas
                        ? 'LUNAS (TERVERIFIKASI)'
                        : isPaymentDitolak
                            ? 'DITOLAK / KURANG'
                            : 'MENUNGGU VALIDASI',
                    badgeBg: isPaymentLunas
                        ? const Color(0xFFD1FAE5)
                        : isPaymentDitolak
                            ? const Color(0xFFFFDAD6)
                            : const Color(0xFFFEF3C7),
                    badgeTextColor: isPaymentLunas
                        ? const Color(0xFF065F46)
                        : isPaymentDitolak
                            ? const Color(0xFF93000A)
                            : const Color(0xFFB45309),
                  ),
                ),
                const SizedBox(height: 20),

                // Tahapan Pendaftaran Timeline Card
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tahapan Pendaftaran',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF161A30),
                            ),
                          ),
                          Text(
                            'Jalur Microcredential 2026',
                            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTimelineItem(
                        isDone: docs.isNotEmpty,
                        isCurrent: docs.isEmpty,
                        title: 'Pengisian Data & Berkas',
                        subtitle: 'Selesai di Portal PMB',
                        badgeText: docs.isNotEmpty ? 'SELESAI' : 'PROSES',
                        showLine: true,
                        lineColored: docs.isNotEmpty,
                      ),
                      _buildTimelineItem(
                        isDone: isDocsApproved,
                        isCurrent: !isDocsApproved,
                        title: 'Verifikasi Berkas',
                        subtitle: 'Pengecekan Ijazah & KTP oleh Admin',
                        badgeText: isDocsApproved
                            ? 'SELESAI'
                            : hasRevision
                                ? 'REVISI'
                                : 'SEDANG DIPROSES',
                        showLine: true,
                        lineColored: isDocsApproved,
                      ),
                      _buildTimelineItem(
                        isDone: isPaymentLunas,
                        isCurrent: false,
                        title: 'Verifikasi Pembayaran',
                        subtitle: 'Pengecekan bukti transfer oleh Staf Keuangan',
                        badgeText: isPaymentLunas ? 'LUNAS' : 'MENUNGGU',
                        showLine: true,
                        lineColored: isPaymentLunas,
                      ),
                      _buildTimelineItem(
                        isDone: isDocsApproved && isPaymentLunas,
                        isCurrent: false,
                        title: 'Status Akhir Pendaftaran',
                        subtitle: 'Pendaftaran Resmi Terverifikasi',
                        badgeText: (isDocsApproved && isPaymentLunas) ? 'TERVERIFIKASI' : 'MENUNGGU',
                        showLine: false,
                        lineColored: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Butuh Bantuan Pendaftaran? Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFECEEF8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Butuh Bantuan Pendaftaran?',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF161A30),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Hubungi Helpdesk PMB Polibatam',
                              style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => showPmbHelpdeskModal(context, store),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCE9FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('🎧 ', style: TextStyle(fontSize: 12)),
                              Text(
                                'Bantuan',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF003BA5),
                                ),
                              ),
                            ],
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
      ],
    );
  }

  Widget _buildStatusRowCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeBg,
    required Color badgeTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECEEF8)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEBF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF0052CC), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF161A30),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                color: badgeTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required bool isDone,
    required bool isCurrent,
    required String title,
    required String subtitle,
    required String badgeText,
    required bool showLine,
    required bool lineColored,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isDone
                      ? const Color(0xFF0052CC)
                      : isCurrent
                          ? const Color(0xFFDCE9FF)
                          : const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  isDone
                      ? Icons.check
                      : isCurrent
                          ? Icons.circle
                          : Icons.hourglass_empty,
                  size: isCurrent ? 10 : 14,
                  color: isDone
                      ? Colors.white
                      : isCurrent
                          ? const Color(0xFF0052CC)
                          : const Color(0xFF94A3B8),
                ),
              ),
              if (showLine)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    color: lineColored ? const Color(0xFF0052CC) : const Color(0xFFE2E8F0),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: showLine ? 16 : 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: (isDone || isCurrent)
                                ? const Color(0xFF161A30)
                                : const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: isDone
                          ? const Color(0xFFE8F0FE)
                          : isCurrent
                              ? const Color(0xFFFEF3C7)
                              : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: isDone
                            ? const Color(0xFF0052CC)
                            : isCurrent
                                ? const Color(0xFFB45309)
                                : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
