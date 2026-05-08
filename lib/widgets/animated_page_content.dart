import 'package:flutter/material.dart';

/// Subtle fade + slide-in when a screen appears.
class AnimatedPageContent extends StatefulWidget {
  const AnimatedPageContent({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 440),
  });

  final Widget child;
  final Duration duration;

  @override
  State<AnimatedPageContent> createState() => _AnimatedPageContentState();
}

class _AnimatedPageContentState extends State<AnimatedPageContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward();
  }

  @override
  void dispose() {
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
          begin: const Offset(0, 0.042),
          end: Offset.zero,
        ).animate(curved),
        child: widget.child,
      ),
    );
  }
}
