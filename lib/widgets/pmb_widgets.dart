import 'package:flutter/material.dart';
import '../services/pmb_data_store.dart';

/// Custom Vector Logo "MP" dengan 3 garis diagonal biru persis seperti `components/mp-logo.blade.php`
class MpLogoWidget extends StatelessWidget {
  final double width;
  final double height;

  const MpLogoWidget({
    super.key,
    this.width = 44,
    this.height = 24,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _MpLogoPainter(),
    );
  }
}

class _MpLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 68.0;
    final sy = size.height / 36.0;
    canvas.save();
    canvas.scale(sx, sy);

    // 1. Speed stripes on left side of M (#0B5ED7)
    final stripePaint = Paint()
      ..color = const Color(0xFF0B5ED7)
      ..style = PaintingStyle.fill;

    final stripe1 = Path()
      ..moveTo(3, 14.5)
      ..lineTo(9.5, 10.5)
      ..lineTo(9.5, 13.4)
      ..lineTo(3, 17.4)
      ..close();
    canvas.drawPath(stripe1, stripePaint);

    final stripe2 = Path()
      ..moveTo(3, 19.2)
      ..lineTo(9.5, 15.2)
      ..lineTo(9.5, 18.1)
      ..lineTo(3, 22.1)
      ..close();
    canvas.drawPath(stripe2, stripePaint);

    final stripe3 = Path()
      ..moveTo(3, 23.9)
      ..lineTo(9.5, 19.9)
      ..lineTo(9.5, 22.8)
      ..lineTo(3, 26.8)
      ..close();
    canvas.drawPath(stripe3, stripePaint);

    // 2. Bold M (#0A4DA6)
    final mPaint = Paint()
      ..color = const Color(0xFF0A4DA6)
      ..style = PaintingStyle.fill;

    final mPath = Path()
      ..moveTo(11.5, 27)
      ..lineTo(11.5, 9)
      ..lineTo(17.4, 9)
      ..lineTo(23.2, 19.2)
      ..lineTo(29, 9)
      ..lineTo(34.9, 9)
      ..lineTo(34.9, 27)
      ..lineTo(29.6, 27)
      ..lineTo(29.6, 17.1)
      ..lineTo(24.8, 25.3)
      ..lineTo(21.6, 25.3)
      ..lineTo(16.8, 17.1)
      ..lineTo(16.8, 27)
      ..close();
    canvas.drawPath(mPath, mPaint);

    // 3. Bold P (#172554)
    final pPaint = Paint()
      ..color = const Color(0xFF172554)
      ..style = PaintingStyle.fill;

    final pPath = Path()
      ..fillType = PathFillType.evenOdd
      ..moveTo(37.5, 9)
      ..lineTo(49.2, 9)
      ..cubicTo(54.1, 9, 57.3, 11.8, 57.3, 15.9)
      ..cubicTo(57.3, 20, 54.1, 22.8, 49.2, 22.8)
      ..lineTo(43.1, 22.8)
      ..lineTo(43.1, 27)
      ..lineTo(37.5, 27)
      ..close()
      ..moveTo(43.1, 13.4)
      ..lineTo(43.1, 18.4)
      ..lineTo(48.5, 18.4)
      ..cubicTo(50.4, 18.4, 51.6, 17.4, 51.6, 15.9)
      ..cubicTo(51.6, 14.4, 50.4, 13.4, 48.5, 13.4)
      ..close();
    canvas.drawPath(pPath, pPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Kotak Putih Pembungkus Logo MP (60x60 atau 56x56) seperti di `login.blade.php` & `forgot-password.blade.php`
class MpLogoBox extends StatelessWidget {
  final double size;
  final double radius;

  const MpLogoBox({
    super.key,
    this.size = 60,
    this.radius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFE3ECFB)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0052CC).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: MpLogoWidget(
        width: size * 0.78,
        height: size * 0.48,
      ),
    );
  }
}

/// Custom Filter Pill Tab (Menggantikan Material ChoiceChip agar sama persis dengan Blade Views tanpa centang Material)
class PmbPillTab extends StatelessWidget {
  final String label;
  final String? badgeCount;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeBgColor;
  final Color inactiveTextColor;

  const PmbPillTab({
    super.key,
    required this.label,
    this.badgeCount,
    required this.isSelected,
    required this.onTap,
    this.activeBgColor = const Color(0xFF003BA5),
    this.inactiveTextColor = const Color(0xFF475569),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? activeBgColor : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: isSelected ? null : Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeBgColor.withValues(alpha: 0.18),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : inactiveTextColor,
              ),
            ),
            if (badgeCount != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.22)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badgeCount!,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Item untuk Bottom Navigation Bar Custom sesuai `<nav>` di Blade Views
class PmbNavItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;

  const PmbNavItem({
    required this.label,
    required this.icon,
    this.activeIcon,
  });
}

/// Custom Bottom Navigation Bar persis seperti `<nav class="fixed bottom-0 ... bg-white border-t border-[#E6E8F2]">` di `resources/views/`
class PmbBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<PmbNavItem> items;
  final bool showActivePill;

  const PmbBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.showActivePill = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE6E8F2), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = currentIndex == index;
            final color = isSelected ? const Color(0xFF0052CC) : const Color(0xFF64748B);

            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 34,
                        height: 24,
                        decoration: BoxDecoration(
                          color: (showActivePill && isSelected)
                              ? const Color(0xFFE8F0FE)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                          size: 19,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// Modal "Pusat Bantuan & Info" yang sama persis dengan `resources/views/auth/login.blade.php` & `resources/views/maba/beranda.blade.php`
void showPmbHelpdeskModal(BuildContext context, PmbDataStore store) {
  final activeHelpdesks = store.helpdesks.where((h) => h.isActive).toList();
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => Container(
      constraints: const BoxConstraints(maxWidth: 430),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Pusat Bantuan & Info',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF161A30),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Layanan Terpadu',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF047857),
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => Navigator.pop(ctx),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.close, size: 16, color: Color(0xFF475569)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Hubungi kontak resmi Helpdesk PMB Microcredential Polibatam di bawah ini jika mengalami kendala login atau pendaftaran:',
            style: TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.4),
          ),
          const SizedBox(height: 14),
          if (activeHelpdesks.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Text(
                'Kontak Helpdesk PMB: adm.micro@polibatam.ac.id / (0778) 469858',
                style: TextStyle(fontSize: 12.5, color: Color(0xFF475569)),
              ),
            )
          else
            ...activeHelpdesks.map(
              (cp) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cp.name,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF161A30),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'WA: ${cp.phone}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                          ),
                          Text(
                            'Email: ${cp.email}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Membuka WhatsApp Helpdesk ${cp.phone}...'),
                            backgroundColor: const Color(0xFF10B981),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Chat WA',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0052CC),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text(
                'Tutup Pusat Bantuan',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
