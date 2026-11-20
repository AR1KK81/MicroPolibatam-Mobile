import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import '../../widgets/pmb_widgets.dart';

/// ============================================================================
/// BAGIAN 4E: KELOLA USER & HAK AKSES ROLE (USER SUPER ADMIN)
/// Sama persis dengan `resources/views/super-admin/users.blade.php`
/// (Menggunakan halaman form penuh inline + bottom-sheet konfirmasi `Hapus akun ini?`)
/// ============================================================================
class SuperAdminUsersScreen extends StatefulWidget {
  final PmbDataStore store;

  const SuperAdminUsersScreen({super.key, required this.store});

  @override
  State<SuperAdminUsersScreen> createState() => _SuperAdminUsersScreenState();
}

class _SuperAdminUsersScreenState extends State<SuperAdminUsersScreen> {
  String _roleFilter = 'semua'; // 'semua', 'maba', 'admin', 'keuangan', 'super_admin'
  String _search = '';

  // State untuk halaman form penuh inline (`@if ($showForm)` di `users.blade.php`)
  bool _showForm = false;
  UserAccount? _editingUser;
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _nimNipCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String _role = 'maba';
  bool _isVerified = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _nimNipCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _openForm({UserAccount? existing}) {
    setState(() {
      _editingUser = existing;
      _nameCtrl.text = existing?.name ?? '';
      _emailCtrl.text = existing?.email ?? '';
      _nimNipCtrl.text = existing?.nimNip ?? '';
      _passCtrl.clear();
      _role = existing?.role ?? 'maba';
      _isVerified = existing?.isVerified ?? true;
      _showForm = true;
    });
  }

  void _saveForm() {
    if (_nameCtrl.text.trim().isEmpty || _emailCtrl.text.trim().isEmpty) return;
    widget.store.saveUserAccount(
      userId: _editingUser?.userId,
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      nimNip: _nimNipCtrl.text.trim(),
      role: _role,
      isVerified: _isVerified,
      newPassword: _passCtrl.text.trim(),
    );
    setState(() => _showForm = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _editingUser != null
              ? 'Data akun pengguna berhasil diperbarui.'
              : 'Akun pengguna baru berhasil ditambahkan.',
        ),
        backgroundColor: const Color(0xFF059669),
      ),
    );
  }

  /// Bottom-Sheet Konfirmasi "Hapus akun ini?" persis seperti `users.blade.php` lines 298-334
  void _confirmDeleteUser(UserAccount user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: const BoxConstraints(maxWidth: 430),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const Text(
              'Hapus akun ini?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF161A30),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Akun ${user.name} (${user.email}) akan dihapus permanen dan tidak bisa masuk ke sistem PMB.',
              style: const TextStyle(fontSize: 12, height: 1.4, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF475569),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.store.deleteUserAccount(user.userId);
                      Navigator.pop(ctx);
                      if (_showForm) {
                        setState(() => _showForm = false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      foregroundColor: Colors.white,
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    ),
                    child: const Text(
                      'Ya, Hapus',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, Color> _roleColors(String role) {
    switch (role) {
      case 'super_admin':
        return {'bg': const Color(0xFFEDE9FE), 'text': const Color(0xFF6D28D9)};
      case 'keuangan':
        return {'bg': const Color(0xFFCCFBF1), 'text': const Color(0xFF0F766E)};
      case 'admin':
        return {'bg': const Color(0xFFFEF3C7), 'text': const Color(0xFFB45309)};
      default:
        return {'bg': const Color(0xFFF1F5F9), 'text': const Color(0xFF475569)};
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showForm) {
      return _buildInlineFormView();
    }

    final all = widget.store.users;
    final mabaCount = all.where((u) => u.role == 'maba').length;
    final adminCount = all.where((u) => u.role == 'admin').length;
    final keuCount = all.where((u) => u.role == 'keuangan').length;
    final saCount = all.where((u) => u.role == 'super_admin').length;

    final filtered = all.where((u) {
      if (_roleFilter != 'semua' && u.role != _roleFilter) return false;
      if (_search.isNotEmpty) {
        final q = _search.toLowerCase();
        return u.name.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q) ||
            u.nimNip.toLowerCase().contains(q);
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
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kelola User',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF161A30),
                    ),
                  ),
                  Text(
                    '${all.length} akun terdaftar',
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
              '+ Tambah User',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            onChanged: (v) => setState(() => _search = v),
            style: const TextStyle(fontSize: 13, color: Color(0xFF161A30)),
            decoration: InputDecoration(
              hintText: 'Cari nama, email, NIM/NIP...',
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

          // Custom Role Filter Pills (`Semua`, `Maba`, `Admin`, `Keuangan`, `Super Admin`)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                PmbPillTab(
                  label: 'Semua',
                  badgeCount: '${all.length}',
                  isSelected: _roleFilter == 'semua',
                  activeBgColor: const Color(0xFF0052CC),
                  onTap: () => setState(() => _roleFilter = 'semua'),
                ),
                const SizedBox(width: 6),
                PmbPillTab(
                  label: 'Maba',
                  badgeCount: '$mabaCount',
                  isSelected: _roleFilter == 'maba',
                  activeBgColor: const Color(0xFF0052CC),
                  onTap: () => setState(() => _roleFilter = 'maba'),
                ),
                const SizedBox(width: 6),
                PmbPillTab(
                  label: 'Admin',
                  badgeCount: '$adminCount',
                  isSelected: _roleFilter == 'admin',
                  activeBgColor: const Color(0xFF0052CC),
                  onTap: () => setState(() => _roleFilter = 'admin'),
                ),
                const SizedBox(width: 6),
                PmbPillTab(
                  label: 'Keuangan',
                  badgeCount: '$keuCount',
                  isSelected: _roleFilter == 'keuangan',
                  activeBgColor: const Color(0xFF0052CC),
                  onTap: () => setState(() => _roleFilter = 'keuangan'),
                ),
                const SizedBox(width: 6),
                PmbPillTab(
                  label: 'Super Admin',
                  badgeCount: '$saCount',
                  isSelected: _roleFilter == 'super_admin',
                  activeBgColor: const Color(0xFF0052CC),
                  onTap: () => setState(() => _roleFilter = 'super_admin'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          ...filtered.map((user) {
            final rc = _roleColors(user.role);
            final isSelf = widget.store.currentUser?.userId == user.userId;

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
                        decoration: const BoxDecoration(
                          color: Color(0xFFDCE9FF),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          user.initials,
                          style: const TextStyle(
                            fontSize: 12,
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
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF161A30),
                              ),
                            ),
                            Text(
                              user.email,
                              style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: rc['bg'],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    user.roleLabel,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: rc['text'],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: user.isVerified
                                        ? const Color(0xFFD1FAE5)
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    user.isVerified ? 'Aktif' : 'Nonaktif',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: user.isVerified
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
                    'NIM/NIP: ${user.nimNip.isNotEmpty ? user.nimNip : '20261100${user.userId}'}',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _openForm(existing: user),
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
                          onPressed: isSelf ? null : () => _confirmDeleteUser(user),
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

  /// Halaman Form Penuh Inline sesuai `@if ($showForm)` di `resources/views/super-admin/users.blade.php`
  Widget _buildInlineFormView() {
    final editing = _editingUser;
    final rc = _roleColors(editing?.role ?? _role);

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
                    editing != null ? 'Edit User' : 'Tambah User',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF161A30),
                    ),
                  ),
                  const Text(
                    'Ubah data & hak akses akun',
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

          // Avatar Summary Card when editing (`users.blade.php` lines 29-48)
          if (editing != null) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFECEEF8)),
              ),
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
                      editing.initials,
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
                        Text(
                          editing.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF161A30),
                          ),
                        ),
                        Text(
                          editing.email,
                          style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: rc['bg'],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                editing.roleLabel,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: rc['text'],
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: editing.isVerified
                                    ? const Color(0xFFD1FAE5)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                editing.isVerified ? 'Aktif' : 'Nonaktif',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: editing.isVerified
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
            ),
            const SizedBox(height: 16),
          ],

          _buildFieldLabel('Nama Lengkap'),
          TextField(
            controller: _nameCtrl,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            decoration: _whiteInputDecoration(hint: 'Contoh: Siti Rahmawati'),
          ),
          const SizedBox(height: 14),

          _buildFieldLabel('Email Kampus / Akun'),
          TextField(
            controller: _emailCtrl,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            decoration: _whiteInputDecoration(hint: 'siti.rahma@polibatam.ac.id'),
          ),
          const SizedBox(height: 14),

          _buildFieldLabel('NIM / NIP'),
          TextField(
            controller: _nimNipCtrl,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            decoration: _whiteInputDecoration(hint: '19880312 201903 2 004'),
          ),
          const SizedBox(height: 14),

          _buildFieldLabel('Role'),
          DropdownButtonFormField<String>(
            initialValue: _role,
            decoration: _whiteInputDecoration(),
            items: const [
              DropdownMenuItem(value: 'maba', child: Text('Maba', style: TextStyle(fontSize: 13))),
              DropdownMenuItem(value: 'admin', child: Text('Admin', style: TextStyle(fontSize: 13))),
              DropdownMenuItem(
                value: 'keuangan',
                child: Text('Keuangan', style: TextStyle(fontSize: 13)),
              ),
              DropdownMenuItem(
                value: 'super_admin',
                child: Text('Super Admin', style: TextStyle(fontSize: 13)),
              ),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _role = v);
            },
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
                  'Status Akun Aktif',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF161A30),
                  ),
                ),
                Switch(
                  value: _isVerified,
                  activeTrackColor: const Color(0xFF0052CC),
                  onChanged: (v) => setState(() => _isVerified = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          _buildFieldLabel(editing != null ? 'Reset Password (Opsional)' : 'Password Akun'),
          TextField(
            controller: _passCtrl,
            obscureText: true,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            decoration: _whiteInputDecoration(
              hint: editing != null
                  ? 'Kosongkan bila tidak ingin mengubah password.'
                  : 'Minimal 6 karakter (Default: password123)',
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
              if (editing != null) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _confirmDeleteUser(editing),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFDC2626),
                      side: const BorderSide(color: Color(0xFFFECACA)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    ),
                    child: const Text(
                      '🗑️ Hapus User',
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
