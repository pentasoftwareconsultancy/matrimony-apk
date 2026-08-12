import 'package:flutter/material.dart';

class PasswordSegmentSwitch extends StatelessWidget {
  final int selectedIndex; // 0: Phone, 1: Email
  final ValueChanged<int> onTabChanged;

  const PasswordSegmentSwitch({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Animated Crimson Pill Background
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: selectedIndex == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.52,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFC2003B),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),

          // Tab Titles
          Row(
            children: [
              // Phone Tab
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTabChanged(0),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: selectedIndex == 0
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: selectedIndex == 0
                            ? Colors.white
                            : const Color(0xFF374151),
                      ),
                      child: const Text('By phone number'),
                    ),
                  ),
                ),
              ),

              // Email Tab
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTabChanged(1),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: selectedIndex == 1
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: selectedIndex == 1
                            ? Colors.white
                            : const Color(0xFF374151),
                      ),
                      child: const Text('By email'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
