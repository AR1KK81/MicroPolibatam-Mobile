import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import '../../widgets/pmb_widgets.dart';

/// ============================================================================
/// BAGIAN 4D: KELOLA JURUSAN & PEMINATAN (USER SUPER ADMIN)
/// Sama persis dengan `resources/views/super-admin/jurusan.blade.php`
/// (Menggunakan halaman form penuh inline, bukan modal bottom sheet)
/// ============================================================================
class SuperAdminJurusanScreen extends StatefulWidget {
  final PmbDataStore store;

  const SuperAdminJurusanScreen({super.key, required this.store});

  @override
  State<SuperAdminJurusanScreen> createState() => _SuperAdminJurusanScreenState();
}

class _SuperAdminJurusanScreenState extends State<SuperAdminJurusanScreen> {
  String _filter = 'semua'; // 'semua', 'aktif', 'nonaktif'
  String _search = '';

  // State untuk halaman form penuh inline (`@if ($showForm)` di `jurusan.blade.php`)
  bool _showForm = false;
  TrackItem? _editingItem;
  final _deptCtrl = TextEditingController();
  final _prodiCtrl = TextEditingController();
  final _trackCtrl = TextEditingController();
  final _quotaCtrl = TextEditingController();
  bool _isActive = true;

  @override
  void dispose() {
    _deptCtrl.dispose();
    _prodiCtrl.dispose();
    _trackCtrl.dispose();
    _quotaCtrl.dispose();
    super.dispose();
  }

  void _openForm({TrackItem? existing}) {
    setState(() {
      _editingItem = existing;
      _deptCtrl.text = existing?.departmentName ?? '';
      _prodiCtrl.text = existing?.studyProgramName ?? '';
      _trackCtrl.text = existing?.trackName ?? '';
      _quotaCtrl.text = '${existing?.quota ?? 40}';
      _isActive = existing?.isActive ?? true;
      _showForm = true;
    });
  }

  void _saveForm() {
    if (_deptCtrl.text.trim().isEmpty || _prodiCtrl.text.trim().isEmpty) return;
    widget.store.saveTrack(
      trackId: _editingItem?.trackId,
      departmentName: _deptCtrl.text.trim(),
      studyProgramName: _prodiCtrl.text.trim(),
      trackName: _trackCtrl.text.trim().isEmpty
          ? _prodiCtrl.text.trim()
          : _trackCtrl.text.trim(),
      quota: int.tryParse(_quotaCtrl.text.trim()) ?? 40,
      isActive: _isActive,
    );
    setState(() => _showForm = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _editingItem != null
              ? 'Jurusan & Peminatan berhasil diperbarui.'
              : 'Jurusan & Peminatan baru berhasil ditambahkan.',
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

    final all = widget.store.tracks;
    final deptCount = all.map((t) => t.departmentName).toSet().length;
    final activeCount = all.where((t) => t.isActive).length;
    final inactiveCount = all.length - activeCount;

    final filtered = all.where((t) {
      if (_filter == 'aktif' && !t.isActive) return false;
      if (_filter == 'nonaktif' && t.isActive) return false;
      if (_search.isNotEmpty) {
        final q = _search.toLowerCase();
        return t.departmentName.toLowerCase().contains(q) ||
            t.studyProgramName.toLowerCase().contains(q) ||
            t.trackName.toLowerCase().contains(q);
      }
      return true;
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
                      '🎓 MASTER AKADEMIK',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF003BA5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Jurusan & Peminatan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF161A30),
                    ),
                  ),
                  Text(
                    '$deptCount jurusan • ${all.length} peminatan terdaftar',
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
              '+ Tambah Jurusan',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            onChanged: (v) => setState(() => _search = v),
            style: const TextStyle(fontSize: 13, color: Color(0xFF161A30)),
            decoration: InputDecoration(
              hintText: 'Cari jurusan, kode, peminatan...',
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

          // Filter Tabs (`Semua`, `Aktif`, `Nonaktif`)
          Row(
            children: [
              PmbPillTab(
                label: 'Semua',
                badgeCount: '${all.length}',
                isSelected: _filter == 'semua',
                activeBgColor: const Color(0xFF0052CC),
                onTap: () => setState(() => _filter = 'semua'),
              ),
              const SizedBox(width: 8),
              PmbPillTab(
                label: 'Aktif',
                badgeCount: '$activeCount',
                isSelected: _filter == 'aktif',
                activeBgColor: const Color(0xFF0052CC),
                onTap: () => setState(() => _filter = 'aktif'),
              ),
              const SizedBox(width: 8),
              PmbPillTab(
                label: 'Nonaktif',
                badgeCount: '$inactiveCount',
                isSelected: _filter == 'nonaktif',
                activeBgColor: const Color(0xFF0052CC),
                onTap: () => setState(() => _filter = 'nonaktif'),
              ),
            ],
          ),
          const SizedBox(height: 14),

          ...filtered.map((track) {
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
                        child: const Icon(
                          Icons.account_tree_outlined,
                          color: Color(0xFF003BA5),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              track.departmentName,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF161A30),
                              ),
                            ),
                            Text(
                              track.studyProgramName,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF434655),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F0FE),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'D4 / Track #${track.trackId}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF003BA5),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: track.isActive
                                        ? const Color(0xFFD1FAE5)
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    track.isActive ? 'Aktif' : 'Nonaktif',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: track.isActive
                                          ? const Color(0xFF059669)
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Track: ${track.trackName} • Kuota ${track.quota} kursi',
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _openForm(existing: track),
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
                          onPressed: () => widget.store.deleteTrack(track.trackId),
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

  /// Halaman Form Penuh Inline sesuai `@if ($showForm)` di `resources/views/super-admin/jurusan.blade.php`
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
                    _editingItem != null ? 'Edit Jurusan & Peminatan' : 'Tambah Jurusan',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF161A30),
                    ),
                  ),
                  const Text(
                    'Detail program & kuota pendaftar',
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

          _buildFieldLabel('Nama Jurusan'),
          TextField(
            controller: _deptCtrl,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            decoration: _whiteInputDecoration(hint: 'Contoh: Teknik Informatika'),
          ),
          const SizedBox(height: 14),

          _buildFieldLabel('Program Studi / Peminatan'),
          TextField(
            controller: _prodiCtrl,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            decoration: _whiteInputDecoration(hint: 'Contoh: Rekayasa Perangkat Lunak (TRPL)'),
          ),
          const SizedBox(height: 14),

          _buildFieldLabel('Nama Track Microcredential'),
          TextField(
            controller: _trackCtrl,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            decoration: _whiteInputDecoration(hint: 'Contoh: Fullstack Web & Mobile Dev'),
          ),
          const SizedBox(height: 14),

          _buildFieldLabel('Kuota Pendaftar'),
          TextField(
            controller: _quotaCtrl,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            decoration: _whiteInputDecoration(hint: '60'),
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
                  'Buka Pendaftaran (Aktif)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF161A30),
                  ),
                ),
                Switch(
                  value: _isActive,
                  activeTrackColor: const Color(0xFF0052CC),
                  onChanged: (v) => setState(() => _isActive = v),
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
                      widget.store.deleteTrack(_editingItem!.trackId);
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
                      '🗑️ Hapus',
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

  InputDecoration _whiteInputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
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
