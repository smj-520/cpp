import 'package:flutter/material.dart';

/// Tappable back control used when there is no [AppBar] (login / register).
class RoundedBackButton extends StatelessWidget {
  const RoundedBackButton({super.key, this.onPressed, this.tooltip});

  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip ?? MaterialLocalizations.of(context).backButtonTooltip,
      child: Material(
        color: scheme.surfaceContainerHigh,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.45)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onPressed ?? () => Navigator.maybePop(context),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: scheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
