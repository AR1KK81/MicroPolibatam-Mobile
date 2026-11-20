import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

class SuperAdminUsersScreen extends StatefulWidget {
  final PmbDataStore store;

  const SuperAdminUsersScreen({super.key, required this.store});

  @override
  State<SuperAdminUsersScreen> createState() => _SuperAdminUsersScreenState();
}

class _SuperAdminUsersScreenState extends State<SuperAdminUsersScreen> {
  String _roleFilter = 'all'; // 'all', 'maba', 'keuangan', 'admin', 'super_admin'
  String _search = '';

  void _confirmDeleteUser(UserAccount target) {
    // Bottom-Sheet Confirmation Modal: "Hapus akun ini?" (Image 8 Frame 6)
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: const Color(0xFFFFE4E6), borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.delete_outline, color: Color(0xFFE11D48)),
            ),
            const SizedBox(height: 14),
            const Text('Hapus akun ini?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(
              'Akun ${target.name} (${target.email}) akan dihapus permanen dan tidak bisa dipulihkan. Riwayat pembayaran tetap tersimpan di audit log.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.store.deleteUserAccount(target.userId);
                      Navigator.pop(ctx);
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white),
                    child: const Text('Ya, Hapus'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openEditUserForm({UserAccount? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final emailCtrl = TextEditingController(text: existing?.email ?? '');
    final nimCtrl = TextEditingController(text: existing?.nimNip ?? '');
    final passCtrl = TextEditingController();
    String role = existing?.role ?? 'admin';
    bool isVerified = existing?.isVerified ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      existing == null ? 'Tambah User' : 'Edit User',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nama Lengkap')),
                const SizedBox(height: 10),
                TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
                const SizedBox(height: 10),
                TextField(controller: nimCtrl, decoration: const InputDecoration(labelText: 'NIM / NIP')),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: role,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: const [
                    DropdownMenuItem(value: 'maba', child: Text('Maba')),
                    DropdownMenuItem(value: 'admin', child: Text('Admin Akademik')),
                    DropdownMenuItem(value: 'keuangan', child: Text('Keuangan')),
                    DropdownMenuItem(value: 'super_admin', child: Text('Super Admin')),
                  ],
                  onChanged: (v) => setModalState(() => role = v ?? 'maba'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: existing == null ? 'Kata Sandi' : 'Reset Kata Sandi Baru (Opsional)',
                  ),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  title: const Text('Akun aktif', style: TextStyle(fontWeight: FontWeight.w700)),
                  value: isVerified,
                  onChanged: (v) => setModalState(() => isVerified = v),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.store.saveUserAccount(
                            userId: existing?.userId,
                            name: nameCtrl.text,
                            email: emailCtrl.text,
                            nimNip: nimCtrl.text,
                            role: role,
                            isVerified: isVerified,
                            newPassword: passCtrl.text,
                          );
                          Navigator.pop(ctx);
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0052CC), foregroundColor: Colors.white),
                        child: const Text('✓ Simpan'),
                      ),
                    ),
                    if (existing != null && existing.userId != widget.store.currentUser?.userId) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _confirmDeleteUser(existing);
                          },
                          style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFDC2626)),
                          child: const Text('🗑️ Hapus User'),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allUsers = widget.store.users;
    final filtered = allUsers.where((u) {
      if (_roleFilter != 'all' && u.role != _roleFilter) return false;
      if (_search.isEmpty) return true;
      final q = _search.toLowerCase();
      return u.name.toLowerCase().contains(q) || u.email.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header (Image 8 Frame 4)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFDCE9FF), borderRadius: BorderRadius.circular(99)),
                        child: const Text('🛡️ MANAJEMEN USER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
                      ),
                      const SizedBox(height: 6),
                      const Text('Pengguna', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                      Text('${allUsers.length} akun terdaftar', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                  IconButton(
                    onPressed: () => _openEditUserForm(),
                    icon: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.add)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: (v) => setState(() => _search = v),
                decoration: InputDecoration(
                  hintText: 'Cari nama, email, atau NIM...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildRolePill('all', 'Semua (${allUsers.length})'),
                    const SizedBox(width: 8),
                    _buildRolePill('maba', 'Maba (${allUsers.where((u) => u.role == "maba").length})'),
                    const SizedBox(width: 8),
                    _buildRolePill('keuangan', 'Keuangan (${allUsers.where((u) => u.role == "keuangan").length})'),
                    const SizedBox(width: 8),
                    _buildRolePill('admin', 'Admin (${allUsers.where((u) => u.role == "admin").length})'),
                    const SizedBox(width: 8),
                    _buildRolePill('super_admin', 'Super Admin (${allUsers.where((u) => u.role == "super_admin").length})'),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              ...filtered.map(
                (u) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFE8F0FE),
                        child: Text(u.initials, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(u.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                            Text(u.email, style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(6)),
                                  child: Text(u.roleLabel, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF6D28D9))),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: u.isVerified ? const Color(0xFFD1FAE5) : const Color(0xFFFFDAD6),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    u.isVerified ? 'Aktif' : 'Nonaktif',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: u.isVerified ? const Color(0xFF059669) : const Color(0xFF93000A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _openEditUserForm(existing: u),
                        icon: const Icon(Icons.edit_outlined, size: 19),
                      ),
                      if (u.userId != widget.store.currentUser?.userId)
                        IconButton(
                          onPressed: () => _confirmDeleteUser(u),
                          icon: const Icon(Icons.delete_outline, size: 19, color: Color(0xFFDC2626)),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRolePill(String key, String label) {
    final active = _roleFilter == key;
    return ChoiceChip(
      selected: active,
      selectedColor: const Color(0xFF0052CC),
      label: Text(label, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: active ? Colors.white : const Color(0xFF475569))),
      onSelected: (_) => setState(() => _roleFilter = key),
    );
  }
}
