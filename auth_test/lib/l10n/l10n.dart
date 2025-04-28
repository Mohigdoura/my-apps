import 'dart:ui';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('fr'),
    const Locale('ar'),
  ];
  static String getLanguage(String code) {
    switch (code) {
      case 'ar':
        return "العربية";
      case 'fr':
        return "Français";
      case 'en':
        return "English";
      default:
        return "Unknown";
    }
  }

  static String getFlag(String code) {
    switch (code) {
      case 'ar':
        return "🇸🇦"; // Arabic with Saudi Arabia flag
      case 'fr':
        return "🇫🇷"; // French with France flag
      case 'en':
        return "🇬🇸"; // English with UK flag (or 🇺🇸 for US)
      default:
        return "Unknown";
    }
  }
}
