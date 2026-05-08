import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Form wrapped in a clear card with border (auth flows).
class AuthFormFrame extends StatelessWidget {
  const AuthFormFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        color: isDark ? scheme.surfaceContainerHigh : AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? scheme.outline.withValues(alpha: 0.45)
              : const Color(0xFFADDCC0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
