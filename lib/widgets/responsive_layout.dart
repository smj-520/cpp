import 'package:flutter/material.dart';

/// Horizontal padding from viewport width (phone / tablet / desktop).
double responsivePagePaddingX(double width) {
  if (width >= 1200) return 48;
  if (width >= 900) return 40;
  if (width >= 600) return 28;
  if (width >= 400) return 14;
  return 10;
}

/// Max width for auth-style forms so lines don’t stretch too wide on web/tablet.
double responsiveFormMaxWidth(double width) {
  if (width >= 1200) return 680;
  if (width >= 900) return 620;
  if (width >= 600) return 580;
  return 560;
}

/// Scrollable column that vertically centers content when shorter than the viewport.
class ResponsiveScrollableCenter extends StatelessWidget {
  const ResponsiveScrollableCenter({
    super.key,
    required this.child,
    this.physics,
  });

  final Widget child;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final padX = responsivePagePaddingX(w);
        final maxForm = responsiveFormMaxWidth(w).clamp(280.0, w - padX * 2);

        final minScrollH = h.isFinite && h > 0
            ? h.clamp(200.0, double.infinity)
            : 400.0;

        return SingleChildScrollView(
          physics: physics ?? const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: padX, vertical: 12),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minScrollH),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxForm),
                  child: child,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
