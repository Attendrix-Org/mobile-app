import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

class FloatingNavBarItem {
  const FloatingNavBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final HeroIcons icon;
  final HeroIcons selectedIcon;
  final String label;
}

class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final List<FloatingNavBarItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF6F61EF);
    const inactiveColor = Color(0xFF94A3B8);
    const borderColor = Color(0xFFE2E8F0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (index) {
          final isSelected = index == currentIndex;
          final item = items[index];

          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 16.0 : 12.0,
                vertical: isSelected ? 8.0 : 12.0,
              ),
              decoration: isSelected
                  ? BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(24),
                    )
                  : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HeroIcon(
                    isSelected ? item.selectedIcon : item.icon,
                    style: isSelected ? HeroIconStyle.solid : HeroIconStyle.outline,
                    color: isSelected ? Colors.white : inactiveColor,
                    size: 24,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(
                      item.label,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
