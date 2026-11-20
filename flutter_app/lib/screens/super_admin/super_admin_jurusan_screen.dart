import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

class SuperAdminJurusanScreen extends StatefulWidget {
  final PmbDataStore store;

  const SuperAdminJurusanScreen({super.key, required this.store});

  @override
  State<SuperAdminJurusanScreen> createState() => _SuperAdminJurusanScreenState();
}

class _SuperAdminJurusanScreenState extends State<SuperAdminJurusanScreen> {
  String _search = '';

  void _openForm({TrackItem? existing, String? prefillDept}) {
    final deptCtrl = TextEditingController(text: existing?.departmentName ?? prefillDept ?? 'Informatika');
    final prodiCtrl = TextEditingController(text: existing?.studyProgramName ?? '');
    final trackCtrl = TextEditingController(text: existing?.trackName ?? '');
    final quotaCtrl = TextEditingController(text: '${existing?.quota ?? 40}');
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
                      existing == null ? 'Tambah Jurusan / Peminatan' : 'Edit Jurusan',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(controller: deptCtrl, decoration: const InputDecoration(labelText: 'Nama Jurusan')),
                const SizedBox(height: 10),
                TextField(controller: prodiCtrl, decoration: const InputDecoration(labelText: 'Nama Peminatan / Prodi')),
                const SizedBox(height: 10),
                TextField(controller: trackCtrl, decoration: const InputDecoration(labelText: 'Track Microcredential')),
                const SizedBox(height: 10),
                TextField(controller: quotaCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Kuota Mahasiswa')),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: const Text('Jurusan aktif (tampil di pendaftaran)', style: TextStyle(fontWeight: FontWeight.w700)),
                  value: isActive,
                  onChanged: (v) => setModalState(() => isActive = v),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.store.saveTrack(
                            trackId: existing?.trackId,
                            departmentName: deptCtrl.text,
                            studyProgramName: prodiCtrl.text,
                            trackName: trackCtrl.text.isEmpty ? prodiCtrl.text : trackCtrl.text,
                            quota: int.tryParse(quotaCtrl.text) ?? 40,
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
                            widget.store.deleteTrack(existing.trackId);
                            Navigator.pop(ctx);
                            setState(() {});
                          },
                          style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFDC2626)),
                          child: const Text('🗑️ Hapus'),
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
    final allTracks = widget.store.tracks.where((t) {
      if (_search.isEmpty) return true;
      final q = _search.toLowerCase();
      return t.departmentName.toLowerCase().contains(q) || t.studyProgramName.toLowerCase().contains(q);
    }).toList();

    final grouped = <String, List<TrackItem>>{};
    for (final t in allTracks) {
      grouped.putIfAbsent(t.departmentName, () => []).add(t);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header (Image 8 Frame 2)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFDCE9FF), borderRadius: BorderRadius.circular(99)),
                        child: const Text('🎓 AKADEMIK', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
                      ),
                      const SizedBox(height: 6),
                      const Text('Jurusan & Peminatan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                      Text('${grouped.keys.length} jurusan • ${allTracks.length} peminatan', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
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
                label: const Text('Tambah Jurusan'),
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
                  hintText: 'Cari jurusan atau peminatan...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 14),
              ...grouped.entries.map((entry) {
                final deptName = entry.key;
                final deptTracks = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(deptName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(6)),
                            child: const Text('Aktif', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF059669))),
                          ),
                        ],
                      ),
                      Text('Batch 1 2026 • ${deptTracks.length} peminatan', style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                      const SizedBox(height: 12),
                      ...deptTracks.map(
                        (t) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(t.studyProgramName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                                    Text('Kuota ${t.quota} mahasiswa • ${t.trackName}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _openForm(existing: t),
                                icon: const Icon(Icons.edit_outlined, size: 18),
                              ),
                              IconButton(
                                onPressed: () {
                                  widget.store.deleteTrack(t.trackId);
                                  setState(() {});
                                },
                                icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFDC2626)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          onPressed: () => _openForm(prefillDept: deptName),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Tambah Peminatan', style: TextStyle(fontWeight: FontWeight.w800)),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFEBF1FF),
                            foregroundColor: const Color(0xFF0052CC),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
