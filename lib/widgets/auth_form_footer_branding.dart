import 'package:flutter/material.dart';

import '../services/app_i18n.dart';

/// Branding block at the **top** of an auth [Form]: logo, then title + subtitle.
class AuthFormFooterBranding extends StatelessWidget {
  const AuthFormFooterBranding({
    super.key,
    required this.title,
    required this.subtitle,
    required this.logoHeight,
  });

  final String title;
  final String subtitle;
  final double logoHeight;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: logoHeight,
          child: ClipRect(
            child: Transform.scale(
              scale: 1.12,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/branding/splash_wallet_hero.png',
                fit: BoxFit.contain,
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
                semanticLabel: AppI18n.t(
                  context,
                  en: 'Hostel Student Wallet logo',
                  ar: 'شعار محفظة الطالب السكنية',
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: w >= 600 ? 20 : 17.5,
            letterSpacing: -0.3,
            color: scheme.onSurface,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 12.5,
            color: scheme.onSurface.withValues(alpha: 0.72),
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
