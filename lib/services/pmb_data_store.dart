import 'package:flutter/foundation.dart';

class UserAccount {
  final int userId;
  String name;
  String email;
  String password;
  String role; // 'maba', 'admin', 'keuangan', 'super_admin'
  bool isVerified;
  String nimNip;

  UserAccount({
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.isVerified = true,
    this.nimNip = '',
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.length >= 2 ? name.substring(0, 2).toUpperCase() : 'US';
  }

  String get roleLabel {
    switch (role) {
      case 'super_admin':
        return 'Super Admin';
      case 'admin':
        return 'Admin';
      case 'keuangan':
        return 'Keuangan';
      default:
        return 'Maba';
    }
  }
}

class TrackItem {
  final int trackId;
  String departmentName;
  String studyProgramName;
  String trackName;
  int quota;
  bool isActive;

  TrackItem({
    required this.trackId,
    required this.departmentName,
    required this.studyProgramName,
    required this.trackName,
    this.quota = 40,
    this.isActive = true,
  });
}

class RekeningItem {
  final int rekeningId;
  String bankName;
  String accountNumber;
  String accountName;
  double nominalBiaya;
  String prefixVa;
  bool isMain;
  bool isActive;

  RekeningItem({
    required this.rekeningId,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    this.nominalBiaya = 200000,
    this.prefixVa = '8008',
    this.isMain = false,
    this.isActive = true,
  });
}

class HelpdeskItem {
  final int cpId;
  String name;
  String category; // 'Pembayaran', 'Akun', 'Berkas'
  String phone;
  String email;
  String operationalHours;
  String description;
  bool isActive;

  HelpdeskItem({
    required this.cpId,
    required this.name,
    required this.category,
    required this.phone,
    required this.email,
    this.operationalHours = 'Sen-Jum, 08.00-16.00 WIB',
    this.description = 'Layanan konfirmasi dan bantuan pendaftaran PMB Microcredential Polibatam.',
    this.isActive = true,
  });
}

class DocumentItem {
  final int documentId;
  final int registrationId;
  String docType; // 'ktp', 'kk', 'ijazah'
  String fileName;
  String fileSize;
  String uploadedDate;
  String statusVerifikasi; // 'menunggu', 'valid', 'revisi'
  String? adminRevisionNotes;

  DocumentItem({
    required this.documentId,
    required this.registrationId,
    required this.docType,
    required this.fileName,
    this.fileSize = '850 KB',
    this.uploadedDate = '19 Feb 2026',
    this.statusVerifikasi = 'menunggu',
    this.adminRevisionNotes,
  });

  String get docTitle {
    switch (docType) {
      case 'ktp':
        return 'Kartu Tanda Penduduk (KTP)';
      case 'kk':
        return 'Kartu Keluarga (KK)';
      case 'ijazah':
      default:
        return 'Ijazah / SKL';
    }
  }
}

class PaymentItem {
  final int paymentId;
  final int registrationId;
  int rekeningId;
  double amount;
  String proofFileName;
  String statusPembayaran; // 'menunggu', 'lunas', 'ditolak'
  String? financeNotes;
  String paymentDate;

  PaymentItem({
    required this.paymentId,
    required this.registrationId,
    required this.rekeningId,
    this.amount = 200000,
    required this.proofFileName,
    this.statusPembayaran = 'menunggu',
    this.financeNotes,
    this.paymentDate = 'Hari ini, 10:30 WIB',
  });
}

class RegistrationItem {
  final int registrationId;
  final int userId;
  int trackId;
  String nik;
  String fullName;
  String birthPlace;
  String birthDate;
  String originSchool;
  String address;
  String status; // 'menunggu_verifikasi', 'perlu_revisi', 'selesai_terverifikasi'
  String? adminVerificationNotes;
  String updatedAt;

  RegistrationItem({
    required this.registrationId,
    required this.userId,
    required this.trackId,
    required this.nik,
    required this.fullName,
    required this.birthPlace,
    required this.birthDate,
    required this.originSchool,
    required this.address,
    this.status = 'menunggu_verifikasi',
    this.adminVerificationNotes,
    this.updatedAt = 'Hari ini, 09:15 WIB',
  });

  String get regCode => 'PMB-MC-26-$registrationId';

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.length >= 2 ? fullName.substring(0, 2).toUpperCase() : 'MB';
  }
}

class AuditLogItem {
  final int auditId;
  final String actor;
  final String action;
  final String object;
  final String result;
  final String timestamp;

  AuditLogItem({
    required this.auditId,
    required this.actor,
    required this.action,
    required this.object,
    required this.result,
    required this.timestamp,
  });
}

class PmbDataStore extends ChangeNotifier {
  static final PmbDataStore instance = PmbDataStore._internal();

  UserAccount? currentUser;

  final List<UserAccount> users = [];
  final List<TrackItem> tracks = [];
  final List<RekeningItem> rekenings = [];
  final List<HelpdeskItem> helpdesks = [];
  final List<RegistrationItem> registrations = [];
  final List<DocumentItem> documents = [];
  final List<PaymentItem> payments = [];
  final List<AuditLogItem> auditLogs = [];

  PmbDataStore._internal() {
    _seedInitialDatabase();
  }

  void _seedInitialDatabase() {
    // 1. Users (Sesuai tabel users di phpMyAdmin micropolibatam)
    users.addAll([
      UserAccount(
        userId: 1,
        name: 'Sandhi Ar (Super Admin)',
        email: 'superadmin.mc@polibatam.ac.id',
        password: 'password123',
        role: 'super_admin',
        isVerified: true,
        nimNip: '199501012022031001',
      ),
      UserAccount(
        userId: 2,
        name: 'Admin Registrasi 01',
        email: 'admin.akademik@polibatam.ac.id',
        password: 'password123',
        role: 'admin',
        isVerified: true,
        nimNip: '199208152024011002',
      ),
      UserAccount(
        userId: 3,
        name: 'Staf Keuangan 01',
        email: 'staf.keuangan@polibatam.ac.id',
        password: 'password123',
        role: 'keuangan',
        isVerified: true,
        nimNip: '199804122020121001',
      ),
      UserAccount(
        userId: 4,
        name: 'Budi Santoso',
        email: 'budi.maba01@gmail.com',
        password: 'password123',
        role: 'maba',
        isVerified: true,
        nimNip: '2026110001',
      ),
      UserAccount(
        userId: 5,
        name: 'Siti Rahma',
        email: 'siti.maba02@gmail.com',
        password: 'password123',
        role: 'maba',
        isVerified: true,
        nimNip: '2026110002',
      ),
      UserAccount(
        userId: 6,
        name: 'Maba Arik Lestari',
        email: 's4ndhiar@gmail.com',
        password: 'password123',
        role: 'maba',
        isVerified: true,
        nimNip: '2026110003',
      ),
    ]);

    // 2. Tracks (Sesuai tabel tracks)
    tracks.addAll([
      TrackItem(
        trackId: 1,
        departmentName: 'Informatika',
        studyProgramName: 'Rekayasa Perangkat Lunak (TRPL)',
        trackName: 'Microcredential Mobile & Web Dev',
        quota: 40,
        isActive: true,
      ),
      TrackItem(
        trackId: 2,
        departmentName: 'Informatika',
        studyProgramName: 'Rekayasa Keamanan Siber (RKS)',
        trackName: 'Microcredential Cyber Security',
        quota: 30,
        isActive: true,
      ),
      TrackItem(
        trackId: 3,
        departmentName: 'Teknik Elektro',
        studyProgramName: 'Teknik Otomasi & IoT',
        trackName: 'Microcredential Industrial IoT',
        quota: 40,
        isActive: true,
      ),
    ]);

    // 3. Rekening (Sesuai tabel rekening)
    rekenings.addAll([
      RekeningItem(
        rekeningId: 1,
        bankName: 'BNI',
        accountNumber: '0238 5419 82',
        accountName: 'Politeknik Negeri Batam',
        nominalBiaya: 200000,
        prefixVa: '8008',
        isMain: true,
        isActive: true,
      ),
      RekeningItem(
        rekeningId: 2,
        bankName: 'BRI',
        accountNumber: '0021 0734 5510',
        accountName: 'Politeknik Negeri Batam',
        nominalBiaya: 200000,
        prefixVa: '8009',
        isMain: false,
        isActive: true,
      ),
      RekeningItem(
        rekeningId: 3,
        bankName: 'Mandiri',
        accountNumber: '1300 0215 6678',
        accountName: 'Politeknik Negeri Batam',
        nominalBiaya: 200000,
        prefixVa: '8010',
        isMain: false,
        isActive: false,
      ),
    ]);

    // 4. Helpdesk (Sesuai tabel contact_persons)
    helpdesks.addAll([
      HelpdeskItem(
        cpId: 1,
        name: 'Bantuan Pembayaran VA',
        category: 'Pembayaran',
        phone: '0812-3456-7890',
        email: 'keu.micro@polibatam.ac.id',
        operationalHours: 'Sen-Jum, 08.00-16.00 WIB',
        isActive: true,
      ),
      HelpdeskItem(
        cpId: 2,
        name: 'Admin Akademik PMB & Login NIM',
        category: 'Akun',
        phone: '0812-7000-1111',
        email: 'adm.micro@polibatam.ac.id',
        operationalHours: 'Setiap hari, 08.00-20.00 WIB',
        isActive: true,
      ),
      HelpdeskItem(
        cpId: 3,
        name: 'Bantuan Upload Dokumen',
        category: 'Berkas',
        phone: '0812-9876-5432',
        email: 'berkas.pmb@polibatam.ac.id',
        operationalHours: 'Sen-Jum, 08.00-16.00 WIB',
        isActive: false,
      ),
    ]);

    // 5. Registrations (Sesuai tabel registrations)
    registrations.addAll([
      RegistrationItem(
        registrationId: 1,
        userId: 4,
        trackId: 1,
        nik: '2171041205060001',
        fullName: 'Budi Santoso',
        birthPlace: 'Batam',
        birthDate: '12/05/2006',
        originSchool: 'SMKN 1 Batam',
        address: 'Batam Centre, Kota Batam',
        status: 'menunggu_verifikasi',
        updatedAt: 'Hari ini, 09:15 WIB',
      ),
      RegistrationItem(
        registrationId: 2,
        userId: 5,
        trackId: 3,
        nik: '2171042208060002',
        fullName: 'Siti Rahma',
        birthPlace: 'Tanjungpinang',
        birthDate: '22/08/2006',
        originSchool: 'SMAN 3 Batam',
        address: 'Batu Aji, Kota Batam',
        status: 'perlu_revisi',
        adminVerificationNotes: 'Foto KTP buram dan nomor NIK tidak terbaca jelas. Silakan unggah ulang scan KTP asli.',
        updatedAt: 'Hari ini, 08:30 WIB',
      ),
      RegistrationItem(
        registrationId: 3,
        userId: 6,
        trackId: 1,
        nik: '2171012345670001',
        fullName: 'Maba Arik',
        birthPlace: 'Batam',
        birthDate: '14/03/2006',
        originSchool: 'SMKN 5 Batam',
        address: 'Bengkong, Kota Batam',
        status: 'selesai_terverifikasi',
        updatedAt: 'Kemarin, 16:20 WIB',
      ),
    ]);

    // 6. Documents (Sesuai tabel documents)
    documents.addAll([
      DocumentItem(
        documentId: 1,
        registrationId: 1,
        docType: 'ktp',
        fileName: 'ktp_budi_maba01.jpg',
        fileSize: '820 KB',
        uploadedDate: '18 Feb 2026',
        statusVerifikasi: 'valid',
      ),
      DocumentItem(
        documentId: 2,
        registrationId: 1,
        docType: 'kk',
        fileName: 'kk_budi_maba01.pdf',
        fileSize: '1.1 MB',
        uploadedDate: '19 Feb 2026',
        statusVerifikasi: 'menunggu',
      ),
      DocumentItem(
        documentId: 3,
        registrationId: 1,
        docType: 'ijazah',
        fileName: 'ijazah_budi_maba01.pdf',
        fileSize: '1.4 MB',
        uploadedDate: '19 Feb 2026',
        statusVerifikasi: 'revisi',
        adminRevisionNotes: 'Foto ijazah sebelumnya terpotong pada nomor seri blanko dan cap legalisir. Mohon unggah dokumen utuh.',
      ),
      DocumentItem(
        documentId: 4,
        registrationId: 2,
        docType: 'ktp',
        fileName: 'ktp_siti_rahma.jpg',
        fileSize: '740 KB',
        uploadedDate: '19 Feb 2026',
        statusVerifikasi: 'revisi',
        adminRevisionNotes: 'Foto KTP buram dan nomor NIK tidak terbaca jelas.',
      ),
      DocumentItem(
        documentId: 5,
        registrationId: 2,
        docType: 'ijazah',
        fileName: 'ijazah_siti_rahma.pdf',
        fileSize: '1.2 MB',
        uploadedDate: '19 Feb 2026',
        statusVerifikasi: 'valid',
      ),
      DocumentItem(
        documentId: 6,
        registrationId: 3,
        docType: 'ktp',
        fileName: 'ktp_scan_arik.jpg',
        fileSize: '850 KB',
        uploadedDate: '20 Feb 2026',
        statusVerifikasi: 'valid',
      ),
      DocumentItem(
        documentId: 7,
        registrationId: 3,
        docType: 'kk',
        fileName: 'kk_legalisir_arik.pdf',
        fileSize: '950 KB',
        uploadedDate: '20 Feb 2026',
        statusVerifikasi: 'valid',
      ),
      DocumentItem(
        documentId: 8,
        registrationId: 3,
        docType: 'ijazah',
        fileName: 'ijazah_legalisir_arik.pdf',
        fileSize: '1.4 MB',
        uploadedDate: '20 Feb 2026',
        statusVerifikasi: 'valid',
      ),
    ]);

    // 7. Payments (Sesuai tabel payments)
    payments.addAll([
      PaymentItem(
        paymentId: 1,
        registrationId: 1,
        rekeningId: 1,
        amount: 200000,
        proofFileName: 'ss_bni_budi_maba01.jpg',
        statusPembayaran: 'menunggu',
        paymentDate: 'Hari ini, 10:30 WIB',
      ),
      PaymentItem(
        paymentId: 2,
        registrationId: 2,
        rekeningId: 1,
        amount: 100000,
        proofFileName: 'struk_transfer_siti.jpg',
        statusPembayaran: 'ditolak',
        financeNotes: 'Nominal transfer kurang Rp 100.000 dari tarif registrasi Rp 200.000.',
        paymentDate: 'Hari ini, 09:15 WIB',
      ),
      PaymentItem(
        paymentId: 3,
        registrationId: 3,
        rekeningId: 1,
        amount: 200000,
        proofFileName: 'Bukti_Bayar_Arik.jpg',
        statusPembayaran: 'lunas',
        paymentDate: '20 Feb 2026, 10:15 WIB',
      ),
    ]);

    // 8. Audit Logs
    auditLogs.addAll([
      AuditLogItem(
        auditId: 1,
        actor: 'superadmin.mc@polibatam.ac.id',
        action: 'SYSTEM_INIT',
        object: 'Portal PMB',
        result: 'Inisialisasi data sistem PMB Microcredential Polibatam',
        timestamp: '08:00 WIB',
      ),
      AuditLogItem(
        auditId: 2,
        actor: 'admin.akademik@polibatam.ac.id',
        action: 'ACC_BERKAS',
        object: 'PMB-MC-26-3 (Maba Arik)',
        result: 'Semua 3 berkas persyaratan lolos validasi akademik',
        timestamp: '10:15 WIB',
      ),
    ]);
  }

  // ================= AUTHENTICATION (1 PINTU SEMUA ROLE) =================
  String? login(String email, String password) {
    final cleanEmail = email.trim().toLowerCase();
    final matched = users.where((u) => u.email.toLowerCase() == cleanEmail).toList();
    if (matched.isEmpty || matched.first.password != password) {
      recordAudit(cleanEmail, 'LOGIN_FAILED', 'Portal Auth', 'Gagal masuk: email atau kata sandi salah');
      return 'Email akun atau kata sandi yang Anda masukkan salah.';
    }
    if (!matched.first.isVerified) {
      return 'Akun Anda saat ini berstatus Nonaktif. Silakan hubungi Helpdesk PMB.';
    }
    currentUser = matched.first;
    recordAudit(currentUser!.email, 'LOGIN', 'Portal Auth', 'Berhasil masuk sebagai ${currentUser!.role}');
    notifyListeners();
    return null;
  }

  void logout() {
    if (currentUser != null) {
      recordAudit(currentUser!.email, 'LOGOUT', 'Portal Auth', 'Keluar dari sesi aplikasi');
    }
    currentUser = null;
    notifyListeners();
  }

  UserAccount registerMaba(String email, String password) {
    final cleanEmail = email.trim().toLowerCase();
    final existing = users.where((u) => u.email.toLowerCase() == cleanEmail).toList();
    if (existing.isNotEmpty) {
      currentUser = existing.first;
      notifyListeners();
      return existing.first;
    }

    final newId = users.isEmpty ? 1 : (users.map((u) => u.userId).reduce((a, b) => a > b ? a : b) + 1);
    final namePrefix = cleanEmail.split('@').first.replaceAll('.', ' ');
    final newUser = UserAccount(
      userId: newId,
      name: 'Maba ${namePrefix[0].toUpperCase()}${namePrefix.substring(1)}',
      email: cleanEmail,
      password: password,
      role: 'maba',
      isVerified: true,
    );
    users.add(newUser);

    final newRegId = registrations.isEmpty ? 1 : (registrations.map((r) => r.registrationId).reduce((a, b) => a > b ? a : b) + 1);
    registrations.add(
      RegistrationItem(
        registrationId: newRegId,
        userId: newUser.userId,
        trackId: tracks.first.trackId,
        nik: '217104120506000$newRegId',
        fullName: newUser.name,
        birthPlace: 'Batam',
        birthDate: '12/05/2006',
        originSchool: 'SMAN 1 Batam',
        address: 'Batam Centre, Kota Batam',
      ),
    );

    currentUser = newUser;
    recordAudit(newUser.email, 'REGISTER_MABA', 'Daftar Akun Maba', 'Verifikasi OTP & pembuatan akun Maba berhasil');
    notifyListeners();
    return newUser;
  }

  bool resetPasswordByEmail(String email, String newPassword) {
    final cleanEmail = email.trim().toLowerCase();
    final matched = users.where((u) => u.email.toLowerCase() == cleanEmail).toList();
    if (matched.isEmpty) {
      return false;
    }
    matched.first.password = newPassword;
    recordAudit(cleanEmail, 'RESET_PASSWORD_OTP', 'Pemulihan Sandi', 'Kata sandi berhasil diperbarui via OTP Gmail');
    notifyListeners();
    return true;
  }

  String? changeCurrentUserPassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    if (currentUser == null) return 'Sesi tidak ditemukan.';
    if (currentUser!.password != currentPassword) {
      return 'Kata sandi saat ini tidak sesuai.';
    }
    if (newPassword.length < 8) {
      return 'Kata sandi baru minimal 8 karakter.';
    }
    if (newPassword != confirmPassword) {
      return 'Konfirmasi kata sandi baru tidak cocok.';
    }
    currentUser!.password = newPassword;
    recordAudit(currentUser!.email, 'CHANGE_PASSWORD', 'Profil Akun', 'Berhasil memperbarui kata sandi akun');
    notifyListeners();
    return null;
  }

  // ================= HELPER LOOKUPS =================
  RegistrationItem getOrCreateCurrentMabaRegistration() {
    final user = currentUser!;
    final found = registrations.where((r) => r.userId == user.userId).toList();
    if (found.isNotEmpty) {
      return found.first;
    }
    final newRegId = registrations.isEmpty ? 1 : (registrations.map((r) => r.registrationId).reduce((a, b) => a > b ? a : b) + 1);
    final created = RegistrationItem(
      registrationId: newRegId,
      userId: user.userId,
      trackId: tracks.first.trackId,
      nik: '217104120506000$newRegId',
      fullName: user.name,
      birthPlace: 'Batam',
      birthDate: '12/05/2006',
      originSchool: 'SMKN 1 Batam',
      address: 'Batam Centre, Kota Batam',
    );
    registrations.add(created);
    return created;
  }

  TrackItem? getTrackById(int trackId) {
    final list = tracks.where((t) => t.trackId == trackId).toList();
    return list.isNotEmpty ? list.first : (tracks.isNotEmpty ? tracks.first : null);
  }

  RegistrationItem? getRegistrationById(int regId) {
    final list = registrations.where((r) => r.registrationId == regId).toList();
    return list.isNotEmpty ? list.first : null;
  }

  List<DocumentItem> getDocumentsForRegistration(int regId) {
    return documents.where((d) => d.registrationId == regId).toList();
  }

  PaymentItem? getPaymentForRegistration(int regId) {
    final list = payments.where((p) => p.registrationId == regId).toList();
    return list.isNotEmpty ? list.first : null;
  }

  RekeningItem get mainRekening {
    final mainList = rekenings.where((r) => r.isMain || r.isActive).toList();
    return mainList.isNotEmpty ? mainList.first : rekenings.first;
  }

  // ================= ACTIONS FOR MABA =================
  void saveMabaBiodata({
    required String fullName,
    required String nik,
    required String birthPlace,
    required String birthDate,
    required String originSchool,
    required String address,
    required int trackId,
  }) {
    final reg = getOrCreateCurrentMabaRegistration();
    reg.fullName = fullName;
    reg.nik = nik;
    reg.birthPlace = birthPlace;
    reg.birthDate = birthDate;
    reg.originSchool = originSchool;
    reg.address = address;
    reg.trackId = trackId;
    currentUser?.name = fullName;
    recordAudit(currentUser?.email ?? 'maba', 'SAVE_BIODATA', reg.regCode, 'Menyimpan biodata peserta Maba');
    notifyListeners();
  }

  void uploadMabaDocument(String docType, String fileName) {
    final reg = getOrCreateCurrentMabaRegistration();
    final existing = documents.where((d) => d.registrationId == reg.registrationId && d.docType == docType).toList();
    if (existing.isNotEmpty) {
      existing.first.fileName = fileName;
      existing.first.statusVerifikasi = 'menunggu';
      existing.first.adminRevisionNotes = null;
      existing.first.uploadedDate = 'Baru saja';
    } else {
      final newId = documents.isEmpty ? 1 : (documents.map((d) => d.documentId).reduce((a, b) => a > b ? a : b) + 1);
      documents.add(
        DocumentItem(
          documentId: newId,
          registrationId: reg.registrationId,
          docType: docType,
          fileName: fileName,
          uploadedDate: 'Baru saja',
          statusVerifikasi: 'menunggu',
        ),
      );
    }
    recordAudit(currentUser?.email ?? 'maba', 'UPLOAD_DOKUMEN', '${docType.toUpperCase()} (${reg.regCode})', 'Unggah berkas $fileName');
    notifyListeners();
  }

  void uploadMabaPayment(String fileName) {
    final reg = getOrCreateCurrentMabaRegistration();
    final existing = payments.where((p) => p.registrationId == reg.registrationId).toList();
    if (existing.isNotEmpty) {
      existing.first.proofFileName = fileName;
      existing.first.statusPembayaran = 'menunggu';
      existing.first.financeNotes = null;
      existing.first.paymentDate = 'Baru saja';
    } else {
      final newId = payments.isEmpty ? 1 : (payments.map((p) => p.paymentId).reduce((a, b) => a > b ? a : b) + 1);
      payments.add(
        PaymentItem(
          paymentId: newId,
          registrationId: reg.registrationId,
          rekeningId: mainRekening.rekeningId,
          amount: mainRekening.nominalBiaya,
          proofFileName: fileName,
          statusPembayaran: 'menunggu',
          paymentDate: 'Baru saja',
        ),
      );
    }
    recordAudit(currentUser?.email ?? 'maba', 'UPLOAD_BUKTI_BNI', reg.regCode, 'Unggah struk transfer BNI: $fileName');
    notifyListeners();
  }

  // ================= ACTIONS FOR ADMIN AKADEMIK =================
  void verifyRegistrationDocuments({
    required int registrationId,
    required bool approveAll,
    required Map<int, String> perDocStatus,
    required String revisionNotes,
  }) {
    final reg = getRegistrationById(registrationId);
    if (reg == null) return;

    final regDocs = getDocumentsForRegistration(registrationId);
    if (approveAll) {
      for (final d in regDocs) {
        d.statusVerifikasi = 'valid';
        d.adminRevisionNotes = null;
      }
      reg.status = 'selesai_terverifikasi';
      reg.adminVerificationNotes = revisionNotes.isNotEmpty ? revisionNotes : null;
      reg.updatedAt = 'Baru saja';
      recordAudit(currentUser?.email ?? 'admin', 'ACC_BERKAS', reg.regCode, 'ACC & Disetujui semua berkas ${reg.fullName}');
    } else {
      for (final d in regDocs) {
        final chosen = perDocStatus[d.documentId] ?? 'revisi';
        d.statusVerifikasi = chosen;
        d.adminRevisionNotes = chosen == 'revisi' ? revisionNotes : null;
      }
      reg.status = 'perlu_revisi';
      reg.adminVerificationNotes = revisionNotes;
      reg.updatedAt = 'Baru saja';
      recordAudit(currentUser?.email ?? 'admin', 'REVISI_BERKAS', reg.regCode, 'Kirim catatan revisi: $revisionNotes');
    }
    notifyListeners();
  }

  // ================= ACTIONS FOR STAF KEUANGAN =================
  void verifyPayment({
    required int paymentId,
    required bool isLunas,
    required String financeNotes,
  }) {
    final list = payments.where((p) => p.paymentId == paymentId).toList();
    if (list.isEmpty) return;
    final payment = list.first;
    final reg = getRegistrationById(payment.registrationId);

    if (isLunas) {
      payment.statusPembayaran = 'lunas';
      payment.financeNotes = financeNotes.isNotEmpty ? financeNotes : null;
      recordAudit(currentUser?.email ?? 'keuangan', 'KONFIRMASI_LUNAS', reg?.regCode ?? 'PAY-$paymentId', 'Pembayaran dikonfirmasi LUNAS');
    } else {
      payment.statusPembayaran = 'ditolak';
      payment.financeNotes = financeNotes;
      recordAudit(currentUser?.email ?? 'keuangan', 'TOLAK_PEMBAYARAN', reg?.regCode ?? 'PAY-$paymentId', 'Pembayaran bermasalah: $financeNotes');
    }
    notifyListeners();
  }

  // ================= ACTIONS FOR SUPER ADMIN =================
  void saveHelpdesk({
    int? cpId,
    required String name,
    required String category,
    required String phone,
    required String email,
    required String operationalHours,
    required String description,
    required bool isActive,
  }) {
    if (cpId != null) {
      final item = helpdesks.firstWhere((h) => h.cpId == cpId);
      item.name = name;
      item.category = category;
      item.phone = phone;
      item.email = email;
      item.operationalHours = operationalHours;
      item.description = description;
      item.isActive = isActive;
      recordAudit(currentUser?.email ?? 'super_admin', 'UPDATE_HELPDESK', name, 'Memperbarui kontak helpdesk');
    } else {
      final newId = helpdesks.isEmpty ? 1 : (helpdesks.map((h) => h.cpId).reduce((a, b) => a > b ? a : b) + 1);
      helpdesks.add(
        HelpdeskItem(
          cpId: newId,
          name: name,
          category: category,
          phone: phone,
          email: email,
          operationalHours: operationalHours,
          description: description,
          isActive: isActive,
        ),
      );
      recordAudit(currentUser?.email ?? 'super_admin', 'CREATE_HELPDESK', name, 'Menambah layanan helpdesk baru');
    }
    notifyListeners();
  }

  void deleteHelpdesk(int cpId) {
    helpdesks.removeWhere((h) => h.cpId == cpId);
    notifyListeners();
  }

  void saveRekening({
    int? rekeningId,
    required String bankName,
    required String accountNumber,
    required String accountName,
    required String prefixVa,
    required bool isMain,
  }) {
    if (isMain) {
      for (final r in rekenings) {
        r.isMain = false;
      }
    }
    if (rekeningId != null) {
      final item = rekenings.firstWhere((r) => r.rekeningId == rekeningId);
      item.bankName = bankName;
      item.accountNumber = accountNumber;
      item.accountName = accountName;
      item.prefixVa = prefixVa;
      item.isMain = isMain;
      item.isActive = true;
    } else {
      final newId = rekenings.isEmpty ? 1 : (rekenings.map((r) => r.rekeningId).reduce((a, b) => a > b ? a : b) + 1);
      rekenings.add(
        RekeningItem(
          rekeningId: newId,
          bankName: bankName,
          accountNumber: accountNumber,
          accountName: accountName,
          prefixVa: prefixVa,
          isMain: isMain,
          isActive: true,
        ),
      );
    }
    notifyListeners();
  }

  void deleteRekening(int rekeningId) {
    if (rekenings.length <= 1) return;
    rekenings.removeWhere((r) => r.rekeningId == rekeningId);
    notifyListeners();
  }

  void saveTrack({
    int? trackId,
    required String departmentName,
    required String studyProgramName,
    required String trackName,
    required int quota,
    required bool isActive,
  }) {
    if (trackId != null) {
      final item = tracks.firstWhere((t) => t.trackId == trackId);
      item.departmentName = departmentName;
      item.studyProgramName = studyProgramName;
      item.trackName = trackName;
      item.quota = quota;
      item.isActive = isActive;
    } else {
      final newId = tracks.isEmpty ? 1 : (tracks.map((t) => t.trackId).reduce((a, b) => a > b ? a : b) + 1);
      tracks.add(
        TrackItem(
          trackId: newId,
          departmentName: departmentName,
          studyProgramName: studyProgramName,
          trackName: trackName,
          quota: quota,
          isActive: isActive,
        ),
      );
    }
    notifyListeners();
  }

  void deleteTrack(int trackId) {
    tracks.removeWhere((t) => t.trackId == trackId);
    notifyListeners();
  }

  void saveUserAccount({
    int? userId,
    required String name,
    required String email,
    required String nimNip,
    required String role,
    required bool isVerified,
    String? newPassword,
  }) {
    if (userId != null) {
      final item = users.firstWhere((u) => u.userId == userId);
      item.name = name;
      item.email = email.trim().toLowerCase();
      item.nimNip = nimNip;
      item.role = role;
      item.isVerified = isVerified;
      if (newPassword != null && newPassword.isNotEmpty) {
        item.password = newPassword;
      }
    } else {
      final newId = users.isEmpty ? 1 : (users.map((u) => u.userId).reduce((a, b) => a > b ? a : b) + 1);
      users.add(
        UserAccount(
          userId: newId,
          name: name,
          email: email.trim().toLowerCase(),
          password: (newPassword != null && newPassword.isNotEmpty) ? newPassword : 'password123',
          role: role,
          isVerified: isVerified,
          nimNip: nimNip,
        ),
      );
    }
    notifyListeners();
  }

  void deleteUserAccount(int userId) {
    if (currentUser?.userId == userId) return;
    users.removeWhere((u) => u.userId == userId);
    notifyListeners();
  }

  void recordAudit(String actor, String action, String object, String result) {
    final newId = auditLogs.isEmpty ? 1 : (auditLogs.map((a) => a.auditId).reduce((a, b) => a > b ? a : b) + 1);
    auditLogs.insert(
      0,
      AuditLogItem(
        auditId: newId,
        actor: actor,
        action: action,
        object: object,
        result: result,
        timestamp: 'Baru saja',
      ),
    );
  }
}
