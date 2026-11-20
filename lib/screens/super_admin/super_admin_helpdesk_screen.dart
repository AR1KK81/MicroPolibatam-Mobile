import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import '../../widgets/pmb_widgets.dart';

/// ============================================================================
/// BAGIAN 4B: KELOLA HELPDESK (USER SUPER ADMIN)
/// Sama persis dengan `resources/views/super-admin/helpdesk.blade.php`
/// (Menggunakan halaman form penuh inline, bukan modal bottom sheet)
/// ============================================================================
class SuperAdminHelpdeskScreen extends StatefulWidget {
  final PmbDataStore store;

  const SuperAdminHelpdeskScreen({super.key, required this.store});

  @override
  State<SuperAdminHelpdeskScreen> createState() => _SuperAdminHelpdeskScreenState();
}

class _SuperAdminHelpdeskScreenState extends State<SuperAdminHelpdeskScreen> {
  String _filter = 'semua'; // 'semua', 'aktif', 'nonaktif'
  String _search = '';

  // State untuk halaman form penuh inline (`@if ($showForm)` di `helpdesk.blade.php`)
  bool _showForm = false;
  HelpdeskItem? _editingItem;
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _category = 'Pembayaran';
  String _hours = 'Sen-Jum, 08.00-16.00 WIB';
  bool _isActive = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _openForm({HelpdeskItem? existing}) {
    setState(() {
      _editingItem = existing;
      _nameCtrl.text = existing?.name ?? '';
      _phoneCtrl.text = existing?.phone ?? '';
      _emailCtrl.text = existing?.email ?? '';
      _descCtrl.text = existing?.description ??
          'Layanan konfirmasi transfer VA dan kendala pembayaran registrasi Maba.';
      _category = existing?.category ?? 'Pembayaran';
      _hours = existing?.operationalHours ?? 'Sen-Jum, 08.00-16.00 WIB';
      _isActive = existing?.isActive ?? true;
      _showForm = true;
    });
  }

  void _saveForm() {
    if (_nameCtrl.text.trim().isEmpty) return;
    widget.store.saveHelpdesk(
      cpId: _editingItem?.cpId,
      name: _nameCtrl.text.trim(),
      category: _category,
      phone: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      operationalHours: _hours,
      description: _descCtrl.text.trim(),
      isActive: _isActive,
    );
    setState(() => _showForm = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _editingItem != null
              ? 'Layanan Helpdesk berhasil diperbarui.'
              : 'Layanan Helpdesk baru berhasil ditambahkan.',
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

    final all = widget.store.helpdesks;
    final activeCount = all.where((h) => h.isActive).length;
    final inactiveCount = all.length - activeCount;

    final filtered = all.where((h) {
      if (_filter == 'aktif' && !h.isActive) return false;
      if (_filter == 'nonaktif' && h.isActive) return false;
      if (_search.isNotEmpty) {
        final q = _search.toLowerCase();
        return h.name.toLowerCase().contains(q) ||
            h.phone.toLowerCase().contains(q) ||
            h.email.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Helpdesk',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF161A30),
                    ),
                  ),
                  Text(
                    '${all.length} layanan terdaftar',
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

          // + Tambah Helpdesk Pill Button
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
              '+ Tambah Helpdesk',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 12),

          // Search Input
          TextField(
            onChanged: (v) => setState(() => _search = v),
            style: const TextStyle(fontSize: 13, color: Color(0xFF161A30)),
            decoration: InputDecoration(
              hintText: 'Cari judul atau kontak...',
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

          ...filtered.map((item) {
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
                          Icons.headset_mic_outlined,
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
                              item.name,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF161A30),
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
                                    item.category,
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
                                    color: item.isActive
                                        ? const Color(0xFFD1FAE5)
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.isActive ? 'Aktif' : 'Nonaktif',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: item.isActive
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
                    'WA ${item.phone}',
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                  ),
                  Text(
                    '${item.email} • ${item.operationalHours}',
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _openForm(existing: item),
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
                          onPressed: () => widget.store.deleteHelpdesk(item.cpId),
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

  /// Halaman Form Penuh Inline sesuai `@if ($showForm)` di `resources/views/super-admin/helpdesk.blade.php`
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
                    _editingItem != null ? 'Edit Helpdesk' : 'Tambah Helpdesk',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF161A30),
                    ),
                  ),
                  const Text(
                    'Isi kontak layanan bantuan',
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

          _buildFieldLabel('Nama Layanan'),
          TextField(
            controller: _nameCtrl,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            decoration: _whiteInputDecoration(hint: 'Contoh: Bantuan Pembayaran VA'),
          ),
          const SizedBox(height: 14),

          _buildFieldLabel('Kategori'),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: _whiteInputDecoration(),
            items: ['Pembayaran', 'Akun', 'Berkas']
                .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _category = v);
            },
          ),
          const SizedBox(height: 14),

          _buildFieldLabel('No. WhatsApp'),
          TextField(
            controller: _phoneCtrl,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            decoration: _whiteInputDecoration(hint: '0812-3456-7890', prefixEmoji: '🎧'),
          ),
          const SizedBox(height: 14),

          _buildFieldLabel('Email'),
          TextField(
            controller: _emailCtrl,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            decoration: _whiteInputDecoration(
              hint: 'helpdesk.bayar@polibatam.ac.id',
              prefixEmoji: '✉️',
            ),
          ),
          const SizedBox(height: 14),

          _buildFieldLabel('Jam Layanan'),
          DropdownButtonFormField<String>(
            initialValue: _hours,
            decoration: _whiteInputDecoration(),
            items: [
              'Sen-Jum, 08.00-16.00 WIB',
              'Setiap hari, 08.00-20.00 WIB',
              'Sen-Sab, 08.00-17.00 WIB',
            ]
                .map((h) => DropdownMenuItem(
                      value: h,
                      child: Text(h, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _hours = v);
            },
          ),
          const SizedBox(height: 14),

          _buildFieldLabel('Deskripsi'),
          TextField(
            controller: _descCtrl,
            maxLines: 3,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
            decoration: _whiteInputDecoration(),
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
                  'Status Aktif',
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
                      widget.store.deleteHelpdesk(_editingItem!.cpId);
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
                      '🗑️ Hapus Helpdesk',
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
