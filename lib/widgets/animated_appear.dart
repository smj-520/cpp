import 'dart:async';

import 'package:flutter/material.dart';

/// One-shot fade + slight slide-up, with optional stagger by [index] (lists / grids).
class AnimatedAppear extends StatefulWidget {
  const AnimatedAppear({
    super.key,
    required this.index,
    required this.child,
    this.delayPerIndex = 42,
    this.duration = const Duration(milliseconds: 400),
    this.slideY = 0.038,
  });

  final int index;
  final Widget child;
  final int delayPerIndex;
  final Duration duration;
  final double slideY;

  @override
  State<AnimatedAppear> createState() => _AnimatedAppearState();
}

class _AnimatedAppearState extends State<AnimatedAppear>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _delay;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    final ms = widget.index * widget.delayPerIndex;
    if (ms <= 0) {
      _controller.forward();
    } else {
      _delay = Timer(Duration(milliseconds: ms), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _delay?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, widget.slideY),
          end: Offset.zero,
        ).animate(curved),
        child: widget.child,
      ),
    );
  }
}
