import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Formats stored ISO-8601 UTC strings (e.g. from Realtime Database) for UI.
class AppDateFormat {
  AppDateFormat._();

  /// Short local date + 12h time with AM/PM (locale-aware, e.g. en / ar).
  static String formatIsoUtcForDisplay(BuildContext context, String? isoUtc) {
    if (isoUtc == null || isoUtc.isEmpty) return '';
    final parsed = DateTime.tryParse(isoUtc);
    if (parsed == null) return isoUtc;
    final local = parsed.toLocal();
    final locale = Localizations.localeOf(context).toLanguageTag();
    final datePart = DateFormat.yMMMd(locale).format(local);
    final timePart = DateFormat.jm(locale).format(local);
    return '$datePart · $timePart';
  }
}
