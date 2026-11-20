import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

class SuperAdminRekeningScreen extends StatefulWidget {
  final PmbDataStore store;

  const SuperAdminRekeningScreen({super.key, required this.store});

  @override
  State<SuperAdminRekeningScreen> createState() => _SuperAdminRekeningScreenState();
}

class _SuperAdminRekeningScreenState extends State<SuperAdminRekeningScreen> {
  String _search = '';

  void _openForm({RekeningItem? existing}) {
    String bankName = existing?.bankName ?? 'BNI';
    final numberCtrl = TextEditingController(text: existing?.accountNumber ?? '');
    final ownerCtrl = TextEditingController(text: existing?.accountName ?? 'Politeknik Negeri Batam');
    final prefixCtrl = TextEditingController(text: existing?.prefixVa ?? '8008');
    bool isMain = existing?.isMain ?? true;

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
                      existing == null ? 'Tambah Rekening' : 'Edit Rekening',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: ['BNI', 'BRI', 'Mandiri', 'BCA', 'BSI'].contains(bankName) ? bankName : 'BNI',
                  decoration: const InputDecoration(labelText: 'Nama Bank'),
                  items: ['BNI', 'BRI', 'Mandiri', 'BCA', 'BSI'].map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                  onChanged: (v) => setModalState(() => bankName = v ?? 'BNI'),
                ),
                const SizedBox(height: 10),
                TextField(controller: numberCtrl, decoration: const InputDecoration(labelText: 'Nomor Rekening')),
                const SizedBox(height: 10),
                TextField(controller: ownerCtrl, decoration: const InputDecoration(labelText: 'Atas Nama')),
                const SizedBox(height: 10),
                TextField(controller: prefixCtrl, decoration: const InputDecoration(labelText: 'Prefix Virtual Account')),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: const Text('Jadikan rekening utama', style: TextStyle(fontWeight: FontWeight.w700)),
                  value: isMain,
                  onChanged: (v) => setModalState(() => isMain = v),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.store.saveRekening(
                            rekeningId: existing?.rekeningId,
                            bankName: bankName,
                            accountNumber: numberCtrl.text,
                            accountName: ownerCtrl.text,
                            prefixVa: prefixCtrl.text,
                            isMain: isMain,
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
                            widget.store.deleteRekening(existing.rekeningId);
                            Navigator.pop(ctx);
                            setState(() {});
                          },
                          style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFDC2626)),
                          child: const Text('🗑️ Hapus Rekening'),
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
    final list = widget.store.rekenings.where((r) {
      if (_search.isEmpty) return true;
      return r.bankName.toLowerCase().contains(_search.toLowerCase()) || r.accountNumber.contains(_search);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header (Image 7 Frame 4)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFDCE9FF), borderRadius: BorderRadius.circular(99)),
                        child: const Text('🏛️ MASTER DATA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
                      ),
                      const SizedBox(height: 6),
                      const Text('Nomor Rekening', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                      Text('${list.length} rekening terdaftar', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
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
                label: const Text('Tambah Rekening'),
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
                  hintText: 'Cari bank, nomor, atas nama...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 14),
              ...list.map(
                (rek) => Container(
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
                            child: const Icon(Icons.account_balance_outlined, color: Color(0xFF003BA5)),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(rek.bankName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                              Text(rek.accountNumber, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: rek.isMain ? const Color(0xFFD1FAE5) : const Color(0xFFE8F0FE),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  rek.isMain ? 'Utama' : (rek.isActive ? 'Aktif' : 'Nonaktif'),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: rek.isMain ? const Color(0xFF059669) : const Color(0xFF0052CC),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('Atas nama: ${rek.accountName}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      Text('Prefix VA: ${rek.prefixVa}', style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _openForm(existing: rek),
                              icon: const Icon(Icons.edit_outlined, size: 15),
                              label: const Text('Edit'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                widget.store.deleteRekening(rek.rekeningId);
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
}
