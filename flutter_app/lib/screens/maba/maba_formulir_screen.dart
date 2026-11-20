import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

class MabaFormulirScreen extends StatefulWidget {
  final PmbDataStore store;
  final int initialTab;

  const MabaFormulirScreen({
    super.key,
    required this.store,
    this.initialTab = 0,
  });

  @override
  State<MabaFormulirScreen> createState() => _MabaFormulirScreenState();
}

class _MabaFormulirScreenState extends State<MabaFormulirScreen> {
  late int _activeTab;
  late TextEditingController _nameCtrl;
  late TextEditingController _nikCtrl;
  late TextEditingController _birthPlaceCtrl;
  late TextEditingController _birthDateCtrl;
  late TextEditingController _schoolCtrl;
  late TextEditingController _addressCtrl;
  late int _selectedTrackId;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab;
    final reg = widget.store.getOrCreateCurrentMabaRegistration();
    _nameCtrl = TextEditingController(text: reg.fullName);
    _nikCtrl = TextEditingController(text: reg.nik);
    _birthPlaceCtrl = TextEditingController(text: reg.birthPlace);
    _birthDateCtrl = TextEditingController(text: reg.birthDate);
    _schoolCtrl = TextEditingController(text: reg.originSchool);
    _addressCtrl = TextEditingController(text: reg.address);
    _selectedTrackId = reg.trackId;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nikCtrl.dispose();
    _birthPlaceCtrl.dispose();
    _birthDateCtrl.dispose();
    _schoolCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _saveBiodataAndNext() {
    widget.store.saveMabaBiodata(
      fullName: _nameCtrl.text,
      nik: _nikCtrl.text,
      birthPlace: _birthPlaceCtrl.text,
      birthDate: _birthDateCtrl.text,
      originSchool: _schoolCtrl.text,
      address: _addressCtrl.text,
      trackId: _selectedTrackId,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Biodata berhasil disimpan! Silakan unggah 3 dokumen wajib.')),
    );
    setState(() => _activeTab = 1);
  }

  @override
  Widget build(BuildContext context) {
    final reg = widget.store.getOrCreateCurrentMabaRegistration();
    final docs = widget.store.getDocumentsForRegistration(reg.registrationId);
    final payment = widget.store.getPaymentForRegistration(reg.registrationId);
    final rekening = widget.store.mainRekening;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF8FF),
        elevation: 0,
        title: const Text(
          'PMB POLIBATAM',
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF003BA5), letterSpacing: 0.6),
        ),
      ),
      body: Column(
        children: [
          // Horizontal 3-Tab Segmented Control (Frames 504:2, 504:153, 504:306)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFDBEAFE)),
              ),
              child: Row(
                children: [
                  _buildTabButton(0, '1. Biodata'),
                  _buildTabButton(1, '2. Dokumen'),
                  _buildTabButton(2, '3. Bayar BNI'),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _activeTab == 0
                  ? _buildBiodataTab()
                  : (_activeTab == 1 ? _buildDokumenTab(reg, docs) : _buildBayarBniTab(reg, payment, rekening)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    final isActive = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF003BA5) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              color: isActive ? Colors.white : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }

  // ================= TAB 1: 1. BIODATA (Frame 504:2) =================
  Widget _buildBiodataTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('👤 Data Pribadi Peserta', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFFFDAD6), borderRadius: BorderRadius.circular(99)),
                    child: const Text('WAJIB DIISI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF93000A))),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildInputField('Nama Lengkap Calon Mahasiswa (Sesuai KTP)', _nameCtrl),
              const SizedBox(height: 12),
              _buildInputField('Nomor Induk Kependudukan (NIK - ✓ Valid Dukcapil)', _nikCtrl),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildInputField('Tempat Lahir', _birthPlaceCtrl)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildInputField('Tanggal Lahir', _birthDateCtrl)),
                ],
              ),
              const SizedBox(height: 12),
              _buildInputField('Asal Sekolah', _schoolCtrl),
              const SizedBox(height: 12),
              _buildInputField('Alamat Lengkap Domisili', _addressCtrl, maxLines: 2),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('🎓 Track Microcredential', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFDCE9FF), borderRadius: BorderRadius.circular(99)),
                    child: const Text('POLIBATAM 2026', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _selectedTrackId,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF4F2FF),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                items: widget.store.tracks
                    .map(
                      (t) => DropdownMenuItem<int>(
                        value: t.trackId,
                        child: Text('${t.departmentName} — ${t.studyProgramName}', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedTrackId = v);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _saveBiodataAndNext,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('Simpan Biodata & Lanjut Unggah Dokumen', style: TextStyle(fontWeight: FontWeight.w800)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003BA5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            ),
          ),
        ),
      ],
    );
  }

  // ================= TAB 2: 2. DOKUMEN WAJIB (Frame 504:153) =================
  Widget _buildDokumenTab(RegistrationItem reg, List<DocumentItem> docs) {
    final docTypes = [
      {'type': 'ktp', 'title': 'Kartu Tanda Penduduk', 'sub': 'Wajib e-KTP Asli Fisik'},
      {'type': 'kk', 'title': 'Kartu Keluarga (KK)', 'sub': 'Lembar Asli / Barcode Resmi'},
      {'type': 'ijazah', 'title': 'Ijazah / SKL', 'sub': 'SMA / SMK Sederajat'},
    ];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color(0xFFF4F2FF), borderRadius: BorderRadius.circular(16)),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: Color(0xFFDBE1FF),
                child: Icon(Icons.info_outline, size: 17, color: Color(0xFF003BA5)),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Persyaratan Berkas Digital', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
                    SizedBox(height: 2),
                    Text(
                      'Unggah KTP, KK, dan Ijazah / SKL format JPG, PNG, atau PDF (Maksimal 2 MB per berkas).',
                      style: TextStyle(fontSize: 12, color: Color(0xFF434655)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        ...docTypes.map((meta) {
          final type = meta['type']!;
          final found = docs.where((d) => d.docType == type).toList();
          final doc = found.isNotEmpty ? found.first : null;
          final isRevisi = doc?.statusVerifikasi == 'revisi';
          final isValid = doc?.statusVerifikasi == 'valid';

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
                        Text(meta['title']!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
                        Text(meta['sub']!, style: const TextStyle(fontSize: 11.5, color: Color(0xFF434655))),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isValid
                            ? const Color(0xFFE5E6FF)
                            : (isRevisi ? const Color(0xFFFFDAD6) : const Color(0xFFD6E3FE)),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        isValid ? '✓ Valid' : (isRevisi ? '! Perlu Revisi' : '⏳ Menunggu'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: isValid
                              ? const Color(0xFF003BA5)
                              : (isRevisi ? const Color(0xFF93000A) : const Color(0xFF0E1C2F)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFF4F2FF), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc?.fileName ?? 'Belum ada berkas terunggah',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF161A30)),
                            ),
                            Text(
                              doc != null ? '${doc.fileSize} • Terunggah ${doc.uploadedDate}' : 'Format PDF, JPG, atau PNG (Maks 2 MB)',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF434655)),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          final newName = '${type}_revisi_${DateTime.now().millisecondsSinceEpoch % 1000}.pdf';
                          widget.store.uploadMabaDocument(type, newName);
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Berkas ${meta["title"]} ($newName) berhasil diunggah!')),
                          );
                        },
                        icon: const Icon(Icons.upload_file_rounded, size: 16),
                        label: Text(doc != null ? 'Ganti' : 'Unggah'),
                      ),
                    ],
                  ),
                ),
                if (isRevisi && doc?.adminRevisionNotes != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDAD6).withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '⚠️ Catatan Admin Registrasi:',
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF93000A)),
                        ),
                        const SizedBox(height: 2),
                        Text(doc!.adminRevisionNotes!, style: const TextStyle(fontSize: 11.5, color: Color(0xFF434655))),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        }),

        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () => setState(() => _activeTab = 2),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('Simpan Dokumen Wajib & Lanjut Bayar BNI', style: TextStyle(fontWeight: FontWeight.w800)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003BA5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            ),
          ),
        ),
      ],
    );
  }

  // ================= TAB 3: 3. BAYAR BNI (Frame 504:306) =================
  Widget _buildBayarBniTab(RegistrationItem reg, PaymentItem? payment, RekeningItem rekening) {
    return Column(
      children: [
        // Card Rekening BNI
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Transfer Bank ${rekening.bankName}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFDCE9FF), borderRadius: BorderRadius.circular(99)),
                    child: const Text('RESMI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFF4F2FF), borderRadius: BorderRadius.circular(14)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NOMOR REKENING ${rekening.bankName}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                        const SizedBox(height: 4),
                        Text(rekening.accountNumber, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: Color(0xFF161A30))),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Nomor rekening ${rekening.accountNumber} disalin!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003BA5), foregroundColor: Colors.white),
                      child: const Text('Salin'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Nama Penerima', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  Text(rekening.accountName, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800)),
                ],
              ),
              const Divider(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Biaya Pendaftaran', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                  Text('Rp 200.000', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: Color(0xFF003BA5))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Unggah Bukti Transfer Manual
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Unggah Bukti Transfer Manual', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text(
                'Lampirkan foto resi ATM, struk mutasi, atau screenshot m-banking Anda untuk mempercepat validasi staf.',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 12),
              if (payment != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFEBF3FF), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Struk: ${payment.proofFileName}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF003BA5))),
                      Text(payment.statusPembayaran.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton.icon(
                  onPressed: () {
                    final fileName = 'resi_bni_${DateTime.now().millisecondsSinceEpoch % 1000}.jpg';
                    widget.store.uploadMabaPayment(fileName);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Bukti transfer $fileName berhasil diunggah!')),
                    );
                  },
                  icon: const Icon(Icons.cloud_upload_outlined),
                  label: const Text('Pilih Foto / Dokumen Resi Transfer'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Selesai & Kembali ke Beranda', style: TextStyle(fontWeight: FontWeight.w800)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003BA5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF161A30))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF4F2FF),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
