import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/pmb_data_store.dart';
import '../../widgets/pmb_widgets.dart';

/// ============================================================================
/// BAGIAN 1B: FORMULIR PENDAFTARAN MABA (3 TAB: 1. BIODATA, 2. DOKUMEN, 3. BAYAR BNI)
/// Sama persis dengan `resources/views/maba/formulir.blade.php`
/// ============================================================================
class MabaFormulirScreen extends StatefulWidget {
  final PmbDataStore store;
  final int initialStep;
  final VoidCallback? onOpenStatusTab;

  const MabaFormulirScreen({
    super.key,
    required this.store,
    this.initialStep = 1,
    this.onOpenStatusTab,
  });

  @override
  State<MabaFormulirScreen> createState() => _MabaFormulirScreenState();
}

class _MabaFormulirScreenState extends State<MabaFormulirScreen> {
  late int _step; // 1 = Biodata, 2 = Dokumen, 3 = Bayar BNI
  late TextEditingController _nameController;
  late TextEditingController _nikController;
  late TextEditingController _birthPlaceController;
  late TextEditingController _birthDateController;
  late TextEditingController _schoolController;
  late TextEditingController _addressController;
  late int _selectedTrackId;
  int _expandedGuideIndex = 0; // 0 = BNI Mobile Banking terbuka secara default

  @override
  void initState() {
    super.initState();
    _step = widget.initialStep;
    final reg = widget.store.getOrCreateCurrentMabaRegistration();
    _nameController = TextEditingController(text: reg.fullName);
    _nikController = TextEditingController(text: reg.nik);
    _birthPlaceController = TextEditingController(text: reg.birthPlace);
    _birthDateController = TextEditingController(text: reg.birthDate);
    _schoolController = TextEditingController(text: reg.originSchool);
    _addressController = TextEditingController(text: reg.address);
    _selectedTrackId = reg.trackId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _birthPlaceController.dispose();
    _birthDateController.dispose();
    _schoolController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveBiodataAndNext() {
    widget.store.saveMabaBiodata(
      fullName: _nameController.text.trim(),
      nik: _nikController.text.trim(),
      birthPlace: _birthPlaceController.text.trim(),
      birthDate: _birthDateController.text.trim(),
      originSchool: _schoolController.text.trim(),
      address: _addressController.text.trim(),
      trackId: _selectedTrackId,
    );
    setState(() => _step = 2);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Biodata berhasil disimpan! Silakan lanjutkan unggah dokumen.'),
        backgroundColor: Color(0xFF059669),
      ),
    );
  }

  void _simulateFileUpload(String docType, String defaultFileName) {
    final controller = TextEditingController(text: defaultFileName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Unggah Berkas ${docType.toUpperCase()}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Format JPG, PNG, atau PDF (Maks. 2 MB):',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF4F2FF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.store.uploadMabaDocument(docType, controller.text.trim());
              Navigator.pop(ctx);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Dokumen ${docType.toUpperCase()} berhasil diunggah!'),
                  backgroundColor: const Color(0xFF059669),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003BA5),
              foregroundColor: Colors.white,
            ),
            child: const Text('Unggah Sekarang'),
          ),
        ],
      ),
    );
  }

  void _simulatePaymentUpload() {
    final reg = widget.store.getOrCreateCurrentMabaRegistration();
    final cleanName = reg.fullName.toLowerCase().replaceAll(' ', '_');
    final controller = TextEditingController(text: 'struk_bni_$cleanName.jpg');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Unggah Bukti Transfer BNI',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Nama File Struk / Resi BNI',
            filled: true,
            fillColor: const Color(0xFFF4F2FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.store.uploadMabaPayment(controller.text.trim());
              Navigator.pop(ctx);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bukti transfer BNI berhasil diunggah dan menunggu validasi Staf Keuangan!'),
                  backgroundColor: Color(0xFF059669),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003BA5),
              foregroundColor: Colors.white,
            ),
            child: const Text('Simpan Bukti Transfer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reg = widget.store.getOrCreateCurrentMabaRegistration();
    final docs = widget.store.getDocumentsForRegistration(reg.registrationId);
    final payment = widget.store.getPaymentForRegistration(reg.registrationId);
    final rek = widget.store.mainRekening;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar (`← PMB POLIBATAM` + `?` + User Avatar)
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
                      const Text(
                        'PMB POLIBATAM',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                          color: Color(0xFF003BA5),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => showPmbHelpdeskModal(context, widget.store),
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
                ],
              ),
            ),

            // 3 Pill Stepper Navigation (`1. Biodata`, `2. Dokumen`, `3. Bayar BNI`)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: Row(
                children: [
                  _buildTabPill(1, '1. Biodata'),
                  const SizedBox(width: 8),
                  _buildTabPill(2, '2. Dokumen'),
                  const SizedBox(width: 8),
                  _buildTabPill(3, '3. Bayar BNI'),
                ],
              ),
            ),

            // Active Tab Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                child: _step == 1
                    ? _buildStep1Biodata()
                    : _step == 2
                        ? _buildStep2Dokumen(reg, docs)
                        : _buildStep3BayarBni(reg, payment, rek),
              ),
            ),

            // Sticky Bottom Action Bar matching `resources/views/maba/formulir.blade.php`
            _buildStickyBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabPill(int tabStep, String label) {
    final isSelected = _step == tabStep;
    final isDone = _step > tabStep;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _step = tabStep),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF003BA5) : const Color(0xFFF3F1FA),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isDone) ...[
                const Icon(Icons.check_circle, size: 13, color: Color(0xFF0052CC)),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : const Color(0xFF525866),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStickyBottomBar() {
    if (_step == 1) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Color(0xFFFBF8FF),
          border: Border(top: BorderSide(color: Color(0xFFE6E8F2))),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveBiodataAndNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003BA5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
            ),
            child: const Text(
              'Simpan Biodata & Lanjut Unggah Dokumen →',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      );
    } else if (_step == 2) {
      return Container(
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
                onPressed: () => setState(() => _step = 3),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003BA5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                child: const Text(
                  'Simpan Dokumen Wajib →',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => setState(() => _step = 1),
              child: const Text(
                'Kembali ke Biodata',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF525866),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Color(0xFFFBF8FF),
          border: Border(top: BorderSide(color: Color(0xFFE6E8F2))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '• Tahap 3 dari 3',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0052CC),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onOpenStatusTab?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003BA5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                child: const Text(
                  'Cek Status Pembayaran →',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => setState(() => _step = 2),
              child: const Text(
                'Kembali ke Dokumen Wajib',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF525866),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  // ==================== TAB 1: BIODATA PESERTA ====================
  Widget _buildStep1Biodata() {
    return Column(
      children: [
        // Card 1: Data Pribadi Peserta
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '🪪 Data Pribadi Peserta',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF161A30),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDAD6),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'WAJIB DIISI',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFBA1A1A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Nama Lengkap Calon Mahasiswa + Sesuai KTP
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nama Lengkap Calon Mahasiswa',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF232738),
                    ),
                  ),
                  Text(
                    'Sesuai KTP',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0052CC),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF161A30),
                ),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline, size: 18, color: Color(0xFF003BA5)),
                  filled: true,
                  fillColor: const Color(0xFFF4F2FF),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'ⓘ Sesuai ejaan nama persis dengan yang tercantum di Ijazah / KTP.',
                style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 14),

              // Nomor Induk Kependudukan (NIK) with `✓ Valid Dukcapil` inside
              const Text(
                'Nomor Induk Kependudukan (NIK)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF232738),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _nikController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: Color(0xFF161A30),
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF4F2FF),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: UnconstrainedBox(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E8FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '✓ Valid Dukcapil',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF003BA5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Tempat Lahir & Tanggal Lahir (2 Kolom)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tempat Lahir',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF232738),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _birthPlaceController,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF161A30),
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.flag_outlined,
                              size: 16,
                              color: Color(0xFF525866),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF4F2FF),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tanggal Lahir',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF232738),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _birthDateController,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF161A30),
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: Color(0xFF525866),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF4F2FF),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Asal Sekolah
              const Text(
                'Asal Sekolah',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF232738),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _schoolController,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF161A30),
                ),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.school_outlined, size: 18, color: Color(0xFF525866)),
                  filled: true,
                  fillColor: const Color(0xFFF4F2FF),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Alamat Lengkap Domisili
              const Text(
                'Alamat Lengkap Domisili',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF232738),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _addressController,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF161A30),
                ),
                decoration: InputDecoration(
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF525866)),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF4F2FF),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Card 2: Track Microcredential
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '🧩 Track Microcredential',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF161A30),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCE9FF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'POLIBATAM 2026',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF003BA5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Jurusan & Program Studi Terapan (D4)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF232738),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: _selectedTrackId,
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF4F2FF),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: widget.store.tracks.map((t) {
                  return DropdownMenuItem<int>(
                    value: t.trackId,
                    child: Text(
                      '${t.departmentName} — ${t.studyProgramName}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF161A30),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedTrackId = val);
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        const Text(
          'Tahap 1 dari 3 Selesai',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  // ==================== TAB 2: UNGGAH 3 DOKUMEN WAJIB ====================
  Widget _buildStep2Dokumen(RegistrationItem reg, List<DocumentItem> docs) {
    final docDefinitions = [
      {
        'type': 'ktp',
        'title': 'Kartu Tanda Penduduk',
        'subtitle': 'Wajib e-KTP Asli Fisik',
        'icon': '🪪',
        'iconBg': const Color(0xFFDCE9FF),
        'defaultFile': 'ktp_${reg.fullName.toLowerCase().replaceAll(' ', '_')}.jpg',
      },
      {
        'type': 'kk',
        'title': 'Kartu Keluarga (KK)',
        'subtitle': 'Lembar Asli / Barcode Resmi',
        'icon': '👨‍👩‍👧',
        'iconBg': const Color(0xFFDCE9FF),
        'defaultFile': 'kk_${reg.fullName.toLowerCase().replaceAll(' ', '_')}.pdf',
      },
      {
        'type': 'ijazah',
        'title': 'Ijazah / SKL',
        'subtitle': 'SMA / SMK Sederajat',
        'icon': '🎓',
        'iconBg': const Color(0xFFFFDAD6),
        'defaultFile': 'ijazah_${reg.fullName.toLowerCase().replaceAll(' ', '_')}.pdf',
      },
    ];

    return Column(
      children: [
        // Info Card (`#F4F2FF`)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F2FF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE4E1F6)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ⓘ', style: TextStyle(fontSize: 15, color: Color(0xFF003BA5))),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Persyaratan Berkas Digital',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF161A30),
                      ),
                    ),
                    SizedBox(height: 3),
                    Text.rich(
                      TextSpan(
                        text: 'Unggah KTP, KK, dan Ijazah / SKL format ',
                        style: TextStyle(fontSize: 11.5, height: 1.4, color: Color(0xFF434655)),
                        children: [
                          TextSpan(
                            text: 'JPG, PNG, atau PDF',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          TextSpan(
                            text:
                                ' (Maksimal 2 MB per berkas). Sistem menjalankan validasi optik & audit registrasi admisi.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        ...docDefinitions.map((def) {
          final type = def['type'] as String;
          final existingList = docs.where((d) => d.docType == type).toList();
          final doc = existingList.isNotEmpty ? existingList.first : null;
          final status = doc?.statusVerifikasi ?? 'belum';

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: status == 'revisi'
                    ? const Color(0xFFFECDD3)
                    : const Color(0xFFECEEF8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Icon + Title/Subtitle + Status Badge
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
                              color: def['iconBg'] as Color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(def['icon'] as String, style: const TextStyle(fontSize: 16)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  def['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF161A30),
                                  ),
                                ),
                                Text(
                                  def['subtitle'] as String,
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
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
                        color: status == 'valid'
                            ? const Color(0xFFE0E8FF)
                            : status == 'revisi'
                                ? const Color(0xFFFFDAD6)
                                : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        status == 'valid'
                            ? '✓ Valid'
                            : status == 'revisi'
                                ? '• Perlu Revisi'
                                : '🕒 Menunggu',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: status == 'valid'
                              ? const Color(0xFF003BA5)
                              : status == 'revisi'
                                  ? const Color(0xFF93000A)
                                  : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // File Item OR Dropzone (Matching `formulir.blade.php`)
                if (doc != null && status != 'revisi')
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F2FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        // DOC Thumbnail Box with colored bottom strip
                        Container(
                          width: 44,
                          height: 44,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Text(
                                'DOC',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF003BA5),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 6,
                                  color: status == 'valid'
                                      ? const Color(0xFF003BA5)
                                      : const Color(0xFF525F75),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc.fileName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF161A30),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${doc.fileSize} • Terunggah ${doc.uploadedDate}',
                                style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () => _simulateFileUpload(type, def['defaultFile'] as String),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFD5DCED)),
                            ),
                            child: const Text(
                              '↻ Ganti',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF003BA5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  InkWell(
                    onTap: () => _simulateFileUpload(type, def['defaultFile'] as String),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F5FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFC7D7FE), width: 1.5),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDCE9FF),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.cloud_upload_outlined,
                              size: 20,
                              color: Color(0xFF003BA5),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ketuk untuk unggah berkas baru',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              decoration: TextDecoration.underline,
                              color: Color(0xFF003BA5),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Format PDF, JPG, atau PNG (Maks. 2 MB)',
                            style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Admin Revision Notes Box (`#FFF5F5`)
                if (doc?.adminRevisionNotes != null) ...[
                  const SizedBox(height: 10),
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
                          '⚠️ Catatan Admin Registrasi:',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF93000A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          doc!.adminRevisionNotes!,
                          style: const TextStyle(
                            fontSize: 11,
                            height: 1.35,
                            color: Color(0xFF7F1D1D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        }),

        const SizedBox(height: 6),
        const Text(
          'Tahap 2 dari 3 Selesai',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  // ==================== TAB 3: PELUNASAN FORMULIR PMB (TRANSFER BNI) ====================
  Widget _buildStep3BayarBni(RegistrationItem reg, PaymentItem? payment, RekeningItem rek) {
    final isLunas = payment?.statusPembayaran == 'lunas';
    final isDitolak = payment?.statusPembayaran == 'ditolak';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step Title Row (`3 Pelunasan Formulir PMB` — `Langkah Terakhir`)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCE9FF),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '3',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF003BA5),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Pelunasan Formulir PMB',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF161A30),
                  ),
                ),
              ],
            ),
            const Text(
              'Langkah Terakhir',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Countdown & Status Card
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Status Pendaftaran',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isLunas
                          ? const Color(0xFFD1FAE5)
                          : isDitolak
                              ? const Color(0xFFFFDAD6)
                              : const Color(0xFFDCE9FF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      isLunas
                          ? '✓ LUNAS TERVERIFIKASI'
                          : isDitolak
                              ? '• DITOLAK / PERLU REVISI'
                              : '• MENUNGGU PEMBAYARAN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: isLunas
                            ? const Color(0xFF065F46)
                            : isDitolak
                                ? const Color(0xFF93000A)
                                : const Color(0xFF003BA5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF2FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Text('⏱️', style: TextStyle(fontSize: 17)),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sisa Waktu Pembayaran',
                            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                          Text(
                            '23 Jam 58 Menit',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF161A30),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Jatuh Tempo',
                        style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                      ),
                      Text(
                        '23:59 WIB',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF161A30),
                        ),
                      ),
                    ],
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
                child: const Text(
                  'ⓘ Lakukan transfer tepat sebelum batas waktu agar akun pendaftaran dan pilihan prodi microcredential Anda divalidasi otomatis.',
                  style: TextStyle(fontSize: 11, height: 1.4, color: Color(0xFF434655)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // BNI Transfer Account Card
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF2FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          rek.bankName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF003BA5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transfer Bank ${rek.bankName}',
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF161A30),
                            ),
                          ),
                          const Text(
                            'Rekening Giro Resmi Polibatam',
                            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCE9FF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'RESMI',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF003BA5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Account Number Box with `📋 Salin` button
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F2FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'NOMOR REKENING BNI',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          rek.accountNumber,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                            color: Color(0xFF161A30),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: rek.accountNumber));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Nomor rekening ${rek.accountNumber} disalin!'),
                            backgroundColor: const Color(0xFF003BA5),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003BA5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text(
                        '📋 Salin',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Nama Penerima', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  Text(
                    rek.accountName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
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
                    'Berita / Keterangan',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  Text(
                    '${reg.fullName} - PMB Micro 2026',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF434655),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: Color(0xFFF0EEF8), height: 1),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Biaya Pendaftaran',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                      Text(
                        'Biaya Admisi & Uji Kompetensi',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF434655),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Rp 200.000',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF003BA5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Rincian Pembayaran Card (`formulir.blade.php` lines 313-330)
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFECEEF8)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🧾 Rincian Pembayaran',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF161A30),
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Biaya Formulir & Seleksi',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  Text(
                    'Rp 200.000',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF161A30),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Biaya Administrasi Bank',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  Text(
                    'Rp 0 (Gratis)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF161A30),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(color: Color(0xFFF0EEF8), height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Tagihan Final',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF161A30),
                    ),
                  ),
                  Text(
                    'Rp 200.000',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF003BA5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Panduan Pembayaran Accordion Card (`formulir.blade.php` lines 333-370)
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFECEEF8)),
          ),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '📖 Panduan Pembayaran',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF161A30),
                    ),
                  ),
                  Text(
                    'Pilih Saluran',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildGuideAccordion(
                index: 0,
                title: '📱 1. BNI Mobile Banking',
                steps: [
                  'Buka aplikasi BNI Mobile Banking dan login dengan user Anda.',
                  'Pilih menu Transfer > pilih opsi Antar Rekening BNI.',
                  'Masukkan nomor rekening BNI Polibatam ${rek.accountNumber} pada tab Input Baru.',
                  'Ketik nominal pas Rp 200.000 dan isi keterangan ${reg.fullName} - PMB Micro 2026 lalu selesaikan transaksi.',
                ],
              ),
              const SizedBox(height: 8),
              _buildGuideAccordion(
                index: 1,
                title: '🏧 2. ATM BNI',
                steps: [
                  'Masukkan kartu ATM BNI dan 6 digit PIN Anda.',
                  'Pilih Menu Lainnya > Transfer > Rekening BNI.',
                  'Masukkan nomor rekening ${rek.accountNumber} (a.n. ${rek.accountName}) dan nominal pas Rp 200.000, lalu tekan Benar.',
                ],
              ),
              const SizedBox(height: 8),
              _buildGuideAccordion(
                index: 2,
                title: '🔄 3. Transfer Antar-Bank / BI-FAST',
                steps: [
                  'Buka mobile banking bank apa saja (BCA, Mandiri, BRI, dll).',
                  'Pilih transfer antarbank, tuju ke Bank BNI (Kode 009).',
                  'Masukkan nomor rekening tujuan ${rek.accountNumber} (a.n. ${rek.accountName}) dengan nominal pas Rp 200.000.',
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Unggah Bukti Transfer Manual Card (`formulir.blade.php` lines 373-424)
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📄 Unggah Bukti Transfer Manual',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF161A30),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Lampirkan foto resi ATM, struk mutasi, atau tangkapan layar (screenshot) m-banking Anda untuk mempercepat validasi staf.',
                          style: TextStyle(fontSize: 11.5, height: 1.4, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCE9FF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Verifikasi Staf',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF003BA5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              if (payment != null) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F2FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'STRUK',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF003BA5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              payment.proofFileName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF161A30),
                              ),
                            ),
                            Text(
                              'Status: ${payment.statusPembayaran.toUpperCase()}',
                              style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (payment?.financeNotes != null) ...[
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
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
                        '⚠️ Catatan Staf Keuangan:',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF93000A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        payment!.financeNotes!,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF7F1D1D)),
                      ),
                    ],
                  ),
                ),
              ],

              InkWell(
                onTap: _simulatePaymentUpload,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F5FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBFD4FF), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFDCE9FF),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.cloud_upload_outlined,
                          size: 20,
                          color: Color(0xFF003BA5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Pilih Foto / Dokumen Resi Transfer',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF003BA5),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Format JPG, PNG, atau PDF (Maksimal 2 MB)',
                        style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFFD5DCED)),
                        ),
                        child: const Text(
                          'Pilih File & Unggah Bukti Transfer',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF003BA5),
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
      ],
    );
  }

  Widget _buildGuideAccordion({
    required int index,
    required String title,
    required List<String> steps,
  }) {
    final isOpen = _expandedGuideIndex == index;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F2FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() {
              _expandedGuideIndex = isOpen ? -1 : index;
            }),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF161A30),
                    ),
                  ),
                  Icon(
                    isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 18,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),
          if (isOpen)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(steps.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${i + 1}. ',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF003BA5),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            steps[i],
                            style: const TextStyle(
                              fontSize: 11.5,
                              height: 1.4,
                              color: Color(0xFF434655),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
