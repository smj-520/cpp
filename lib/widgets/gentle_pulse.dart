import 'package:flutter/material.dart';

/// Very subtle breathing scale — reads as polish, not distraction.
class GentlePulse extends StatefulWidget {
  const GentlePulse({super.key, required this.child});

  final Widget child;

  @override
  State<GentlePulse> createState() => _GentlePulseState();
}

class _GentlePulseState extends State<GentlePulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ).value;
        final scale = 1 + 0.018 * t;
        return Transform.scale(scale: scale, child: child);
      },
      child: widget.child,
    );
  }
}
