import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

/// ============================================================================
/// BAGIAN 4C: KELOLA NOMOR REKENING & VA (USER SUPER ADMIN)
/// Sama persis dengan `resources/views/super-admin/rekening.blade.php`
/// (Menggunakan halaman form penuh inline, bukan modal bottom sheet)
/// ============================================================================
class SuperAdminRekeningScreen extends StatefulWidget {
  final PmbDataStore store;

  const SuperAdminRekeningScreen({super.key, required this.store});

  @override
  State<SuperAdminRekeningScreen> createState() => _SuperAdminRekeningScreenState();
}

class _SuperAdminRekeningScreenState extends State<SuperAdminRekeningScreen> {
  String _search = '';

  // State untuk halaman form penuh inline (`@if ($showForm)` di `rekening.blade.php`)
  bool _showForm = false;
  RekeningItem? _editingItem;
  String _bankName = 'BNI';
  final _numberCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _prefixCtrl = TextEditingController();
  bool _isMain = true;

  @override
  void dispose() {
    _numberCtrl.dispose();
    _nameCtrl.dispose();
    _prefixCtrl.dispose();
    super.dispose();
  }

  void _openForm({RekeningItem? existing}) {
    setState(() {
      _editingItem = existing;
      _bankName = existing?.bankName ?? 'BNI';
      _numberCtrl.text = existing?.accountNumber ?? '';
      _nameCtrl.text = existing?.accountName ?? 'Politeknik Negeri Batam';
      _prefixCtrl.text = existing?.prefixVa ?? '8008';
      _isMain = existing?.isMain ?? true;
      _showForm = true;
    });
  }

  void _saveForm() {
    if (_numberCtrl.text.trim().isEmpty) return;
    widget.store.saveRekening(
      rekeningId: _editingItem?.rekeningId,
      bankName: _bankName,
      accountNumber: _numberCtrl.text.trim(),
      accountName: _nameCtrl.text.trim(),
      prefixVa: _prefixCtrl.text.trim(),
      isMain: _isMain,
    );
    setState(() => _showForm = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _editingItem != null
              ? 'Data rekening pembayaran berhasil diperbarui.'
              : 'Rekening pembayaran baru berhasil ditambahkan.',
        ),
        backgroundColor: const Color(0xFF059669),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showForm) {
      return _buildInlineFormView();
    }

    final all = widget.store.rekenings;
    final filtered = all.where((r) {
      if (_search.isEmpty) return true;
      final q = _search.toLowerCase();
      return r.bankName.toLowerCase().contains(q) ||
          r.accountNumber.toLowerCase().contains(q) ||
          r.accountName.toLowerCase().contains(q);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCE9FF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      '🛡️ MASTER DATA',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF003BA5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Nomor Rekening',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF161A30),
                    ),
                  ),
                  Text(
                    '${all.length} rekening terdaftar',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _openForm(),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1EFFF),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '+',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF161A30),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () => _openForm(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0052CC),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              elevation: 1,
            ),
            child: const Text(
              '+ Tambah Rekening',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            onChanged: (v) => setState(() => _search = v),
            style: const TextStyle(fontSize: 13, color: Color(0xFF161A30)),
            decoration: InputDecoration(
              hintText: 'Cari bank, nomor, atas nama...',
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
          const SizedBox(height: 14),

          ...filtered.map((rek) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFECEEF8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F0FE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Text('🏦', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rek.bankName,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF161A30),
                              ),
                            ),
                            Text(
                              rek.accountNumber,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF161A30),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: rek.isMain || rek.isActive
                                    ? const Color(0xFFD1FAE5)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                rek.isMain
                                    ? 'Utama'
                                    : rek.isActive
                                        ? 'Aktif'
                                        : 'Nonaktif',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: rek.isMain || rek.isActive
                                      ? const Color(0xFF059669)
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Atas nama: ${rek.accountName}',
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                  ),
                  Text(
                    'Prefix VA: ${rek.prefixVa}',
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _openForm(existing: rek),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF161A30),
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          child: const Text(
                            '✎ Edit',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => widget.store.deleteRekening(rek.rekeningId),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFDC2626),
                            side: const BorderSide(color: Color(0xFFFECACA)),
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          child: const Text(
                            '🗑️ Hapus',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Halaman Form Penuh Inline sesuai `@if ($showForm)` di `resources/views/super-admin/rekening.blade.php`
  Widget _buildInlineFormView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _editingItem != null ? 'Edit Rekening' : 'Tambah Rekening',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF161A30),
                    ),
                  ),
                  const Text(
                    'Rekening penerima pembayaran',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              InkWell(
                onTap: () => setState(() => _showForm = false),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1EFFF),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '✕',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF434655),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildFieldLabel('Nama Bank'),
          DropdownButtonFormField<String>(
            initialValue: _bankName,
            decoration: _whiteInputDecoration(),
            items: ['BNI', 'BRI', 'Mandiri', 'BSI', 'BTN']
                .map((b) => DropdownMenuItem(
                      value: b,
                      child: Text(b, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _bankName = v);
            },
          ),
          const SizedBox(height: 14),

          _buildFieldLabel('Nomor Rekening'),
          TextField(
            controller: _numberCtrl,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            decoration: _whiteInputDecoration(hint: '0238 5419 82', prefixEmoji: '💳'),
          ),
          const SizedBox(height: 14),

          _buildFieldLabel('Atas Nama'),
          TextField(
            controller: _nameCtrl,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            decoration: _whiteInputDecoration(hint: 'Politeknik Negeri Batam'),
          ),
          const SizedBox(height: 14),

          _buildFieldLabel('Prefix Virtual Account'),
          TextField(
            controller: _prefixCtrl,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            decoration: _whiteInputDecoration(hint: '8008', prefixEmoji: '🏦'),
          ),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8ECF8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Jadikan rekening utama',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF161A30),
                  ),
                ),
                Switch(
                  value: _isMain,
                  activeTrackColor: const Color(0xFF0052CC),
                  onChanged: (v) => setState(() => _isMain = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Sinkronisasi VA otomatis Info Card (`rekening.blade.php` lines 102-107)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFECEEF8)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sinkronisasi VA otomatis',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0052CC),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Rekening yang aktif dipakai untuk membuat nomor VA baru Maba. Perubahan prefix hanya berlaku untuk registrasi berikutnya.',
                  style: TextStyle(fontSize: 11.5, height: 1.4, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0052CC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    elevation: 1,
                  ),
                  child: const Text(
                    '✓ Simpan',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              if (_editingItem != null) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      widget.store.deleteRekening(_editingItem!.rekeningId);
                      setState(() => _showForm = false);
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFDC2626),
                      side: const BorderSide(color: Color(0xFFFECACA)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    ),
                    child: const Text(
                      '🗑️ Hapus Rekening',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }

  InputDecoration _whiteInputDecoration({String? hint, String? prefixEmoji}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefixEmoji != null
          ? UnconstrainedBox(
              child: Text(prefixEmoji, style: const TextStyle(fontSize: 14)),
            )
          : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE8ECF8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE8ECF8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF0052CC), width: 1.5),
      ),
    );
  }
}
