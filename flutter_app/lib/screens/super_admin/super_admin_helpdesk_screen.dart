import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

class SuperAdminHelpdeskScreen extends StatefulWidget {
  final PmbDataStore store;

  const SuperAdminHelpdeskScreen({super.key, required this.store});

  @override
  State<SuperAdminHelpdeskScreen> createState() => _SuperAdminHelpdeskScreenState();
}

class _SuperAdminHelpdeskScreenState extends State<SuperAdminHelpdeskScreen> {
  String _filter = 'semua'; // 'semua', 'aktif', 'nonaktif'
  String _search = '';

  void _openForm({HelpdeskItem? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '');
    final emailCtrl = TextEditingController(text: existing?.email ?? '');
    final hoursCtrl = TextEditingController(text: existing?.operationalHours ?? 'Sen-Jum, 08.00-16.00 WIB');
    final descCtrl = TextEditingController(text: existing?.description ?? 'Layanan konfirmasi transfer VA dan kendala pendaftaran Maba.');
    String category = existing?.category ?? 'Pembayaran';
    bool isActive = existing?.isActive ?? true;

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
                      existing == null ? 'Tambah Helpdesk' : 'Edit Helpdesk',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nama Layanan')),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  items: ['Pembayaran', 'Akun', 'Berkas'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setModalState(() => category = v ?? 'Pembayaran'),
                ),
                const SizedBox(height: 10),
                TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'No. WhatsApp')),
                const SizedBox(height: 10),
                TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
                const SizedBox(height: 10),
                TextField(controller: hoursCtrl, decoration: const InputDecoration(labelText: 'Jam Layanan')),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: const Text('Status Aktif', style: TextStyle(fontWeight: FontWeight.w700)),
                  value: isActive,
                  onChanged: (v) => setModalState(() => isActive = v),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.store.saveHelpdesk(
                            cpId: existing?.cpId,
                            name: nameCtrl.text,
                            category: category,
                            phone: phoneCtrl.text,
                            email: emailCtrl.text,
                            operationalHours: hoursCtrl.text,
                            description: descCtrl.text,
                            isActive: isActive,
                          );
                          Navigator.pop(ctx);
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0052CC), foregroundColor: Colors.white),
                        child: const Text('✓ Simpan'),
                      ),
                    ),
                    if (existing != null) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            widget.store.deleteHelpdesk(existing.cpId);
                            Navigator.pop(ctx);
                            setState(() {});
                          },
                          style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFDC2626)),
                          child: const Text('🗑️ Hapus Helpdesk'),
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
    final all = widget.store.helpdesks;
    final filtered = all.where((h) {
      if (_filter == 'aktif' && !h.isActive) return false;
      if (_filter == 'nonaktif' && h.isActive) return false;
      if (_search.isEmpty) return true;
      return h.name.toLowerCase().contains(_search.toLowerCase()) || h.phone.contains(_search);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header (Image 7 Frame 2)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Helpdesk', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                      Text('${all.length} layanan terdaftar', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                  IconButton(
                    onPressed: () => _openForm(),
                    icon: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.add)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => _openForm(),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Tambah Helpdesk'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0052CC),
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: (v) => setState(() => _search = v),
                decoration: InputDecoration(
                  hintText: 'Cari judul atau kontak...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildFilterPill('semua', 'Semua (${all.length})'),
                  const SizedBox(width: 8),
                  _buildFilterPill('aktif', 'Aktif (${all.where((h) => h.isActive).length})'),
                  const SizedBox(width: 8),
                  _buildFilterPill('nonaktif', 'Nonaktif (${all.where((h) => !h.isActive).length})'),
                ],
              ),
              const SizedBox(height: 14),
              ...filtered.map(
                (cp) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.headset_mic_outlined, color: Color(0xFF003BA5)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cp.name, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(6)),
                                      child: Text(cp.category, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF0052CC))),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: cp.isActive ? const Color(0xFFD1FAE5) : const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        cp.isActive ? 'Aktif' : 'Nonaktif',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: cp.isActive ? const Color(0xFF059669) : const Color(0xFF64748B),
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
                      Text('WA ${cp.phone} • ${cp.email}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      Text(cp.operationalHours, style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _openForm(existing: cp),
                              icon: const Icon(Icons.edit_outlined, size: 15),
                              label: const Text('Edit'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                widget.store.deleteHelpdesk(cp.cpId);
                                setState(() {});
                              },
                              icon: const Icon(Icons.delete_outline, size: 15, color: Color(0xFFDC2626)),
                              label: const Text('Hapus', style: TextStyle(color: Color(0xFFDC2626))),
                            ),
                          ),
                        ],
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

  Widget _buildFilterPill(String key, String label) {
    final active = _filter == key;
    return ChoiceChip(
      selected: active,
      selectedColor: const Color(0xFF0052CC),
      label: Text(label, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: active ? Colors.white : const Color(0xFF475569))),
      onSelected: (_) => setState(() => _filter = key),
    );
  }
}
