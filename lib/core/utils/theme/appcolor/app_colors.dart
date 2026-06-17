import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Brand green used for primary buttons, active tabs, selected states,
  // form borders, snackbars, progress indicators, and brand gradients.
  static const Color primary = Color(0xFF006C49);

  // Secondary accent currently kept for app theme compatibility.
  static const Color secondary = Color(0xFF03DAC6);

  // App background used on auth, onboarding, navbar, profile, transaction,
  // splash glass effects, and light gradients.
  static const Color lightBackground = Color(0xFFF8F9FA);

  // Legacy neutral background and grey.shade100 equivalent.
  static const Color background = Color(0xFFF5F5F5);

  // Surfaces used for cards, dialogs, form panels, buttons, icons, and text
  // on dark/brand backgrounds.
  static const Color white = Color(0xFFFFFFFF);

  // Main text and icons used across app bars, forms, cards, onboarding,
  // transaction filters, and fallback icon colors.
  static const Color black = Color(0xFF000000);

  // Strong body text used in forms, profile rows, goals, budgets, and
  // transaction detail labels.
  static const Color bodyText = Color(0xFF191C1D);

  // Section label text used in goal and budget progress details.
  static const Color headingText = Color(0xFF26282B);

  // Dark secondary text used in auth copy, onboarding copy, navbar items,
  // home labels, and budget category titles.
  static const Color darkText = Color(0xFF3C4A42);

  // Muted labels used in profile details and transaction metadata.
  static const Color mutedText = Color(0xFF565E74);

  // Muted text used in goal and budget cards.
  static const Color slateText = Color(0xFF6C7A71);

  // Medium grey labels used in goal and budget forms/progress screens.
  static const Color neutralText = Color(0xFF6B7280);

  // Icon grey used in goal and budget category cards.
  static const Color iconText = Color(0xFF4A5568);

  // Light grey text used in progress metadata and disabled values.
  static const Color disabledText = Color(0xFF9CA3AF);

  // Auth field hints and subtle auth dividers.
  static const Color inputHint = Color(0xFFBBCABF);

  // Onboarding subtitle text.
  static const Color onboardingSubtitle = Color(0xFFA8A8A9);

  // Onboarding decorative icon color.
  static const Color onboardingIcon = Color(0xFFC4C4C4);

  // Splash subtitle and loading helper text.
  static const Color splashSubtitle = Color(0xFFBEC6E0);

  // Primary success/accent green used in auth gradients, card gradients,
  // onboarding glows, income highlights, and budget badges.
  static const Color success = Color(0xFF10B981);

  // Alternative action green used in create budget/goal and success snackbars.
  static const Color actionGreen = Color(0xFF007A4D);

  // Dark green used in the home header gradient.
  static const Color primaryDark = Color(0xFF005236);

  // Bright mint used in splash/home highlights and progress indicators.
  static const Color mintAccent = Color(0xFF6FFBBE);

  // Glow green used around home balance UI and selected navbar icons.
  static const Color glowGreen = Color(0xFF4EDEA3);

  // Card gradient dark stop.
  static const Color cardGradientDark = Color(0xFF2E3132);

  // Splash dark background.
  static const Color splashBackground = Color(0xFF131B2E);

  // Transaction warning/expense red.
  static const Color expense = Color(0xFFEF4444);

  // Material red used for delete, validation, logout, and negative states.
  static const Color red = Color(0xFFF44336);

  // Darker destructive red used in dialogs and progress screens.
  static const Color destructive = Color(0xFFE53935);

  // Auth login error snackbar.
  static const Color errorDark = Color(0xFFB00020);

  // Success/status green from Material colors used in charts and transaction
  // income states.
  static const Color green = Color(0xFF4CAF50);

  // Chart/category colors from Material colors used by the home controller.
  static const Color blue = Color(0xFF2196F3);
  static const Color orange = Color(0xFFFF9800);
  static const Color purple = Color(0xFF9C27B0);
  static const Color teal = Color(0xFF009688);
  static const Color pink = Color(0xFFE91E63);

  // Light green used in the add transaction summary state.
  static const Color lightGreen = Color(0xFFA5D6A7);

  // Premium/profile gold colors.
  static const Color premiumGold = Color(0xFFB08D44);
  static const Color cardGold = Color(0xFFC9960C);
  static const Color cardGoldLight = Color(0xFFFFD97A);

  // Purple account/profile icon colors.
  static const Color purpleAccent = Color(0xFF494BD6);
  static const Color purpleSoft = Color(0xFFDAE2FD);

  // General borders, inactive indicators, card strokes, and dividers.
  static const Color border = Color(0xFFE1E3E4);
  static const Color borderMuted = Color(0xFFE5E7EB);
  static const Color inputFill = Color(0xFFEDEEEF);
  static const Color inputDivider = Color(0xFFE7E8E9);

  // Form and profile icon backgrounds.
  static const Color fieldFill = Color(0xFFF3F4F5);
  static const Color iconBackground = Color(0xFFF5F6F8);

  // Slightly darker page background used on card, goal, and budget screens.
  static const Color pageBackground = Color(0xFFF7F7F7);

  // Signup page background.
  static const Color authBackground = Color(0xFFEAEBEC);

  // First onboarding screen top background.
  static const Color onboardingTopBackground = Color(0xFFF7FAF7);

  // Profile premium card backgrounds.
  static const Color premiumSurface = Color(0xFFFCFAF4);
  static const Color premiumBorder = Color(0xFFEEE4CE);

  // Goal and budget rotating category/icon background colors.
  static const Color iconBgBlue = Color(0xFFEAEEF9);
  static const Color iconBgGreen = Color(0xFFEAF4F0);
  static const Color iconBgOrange = Color(0xFFFFF4E5);
  static const Color iconBgPurple = Color(0xFFF3EAFD);
  static const Color iconBgRed = Color(0xFFFFEAEA);
  static const Color iconBgSky = Color(0xFFE5F6FF);

  // Home and notification soft surfaces.
  static const Color homeExpenseSoft = Color(0xFFFFDAD6);
  static const Color cardNetworkRed = Color(0xCCEB001B);
  static const Color cardNetworkOrange = Color(0xCCF79E1B);

  // Dark mode add-transaction text leftovers used in active/inactive controls.
  static const Color transactionTextSecondary = Color(0xFF8E8EA0);

  // Overlay, shadow, glow, and translucent colors used throughout surfaces,
  // glass bars, auth cards, onboarding effects, and splash overlays.
  static const Color transparent = Color(0x00000000);
  static const Color blackOverlay05 = Color(0x0D000000);
  static const Color blackOverlay08 = Color(0x14000000);
  static const Color blackOverlay10 = Color(0x1A000000);
  static const Color blackOverlay12 = Color(0x1F000000);
  static const Color blackOverlay14 = Color(0x24000000);
  static const Color blackOverlay26 = Color(0x42000000);
  static const Color blackOverlay54 = Color(0x8A000000);
  static const Color blackOverlay87 = Color(0xDD000000);
  static const Color shadowSoft = Color(0x0D0F172A);
  static const Color shadowInk = Color(0x0F172A0D);
  static const Color shadowHome = Color(0x11000000);
  static const Color shadowMedium = Color(0x22000000);
  static const Color mutedShadow = Color(0x0D565E74);
  static const Color primarySoft = Color(0x26006C49);
  static const Color primaryPill = Color(0x1A006C49);
  static const Color primaryGlow = Color(0x33006C49);
  static const Color successSoft = Color(0x1A10B981);
  static const Color successGlow = Color(0x4010B981);
  static const Color glowGreenSoft = Color(0x804EDEA3);
  static const Color glowGreenLight = Color(0x10C7F5DF);
  static const Color lightBackgroundGlass = Color(0xCCF8F9FA);
  static const Color splashGlass = Color(0x1AF8F9FA);
  static const Color whiteSoft = Color(0x33FFFFFF);
  static const Color white54 = Color(0x8AFFFFFF);
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color borderHalf = Color(0x80E1E3E4);
  static const Color inputHintSoft = Color(0x33BBCABF);
  static const Color inputHintMedium = Color(0x4DBBCABF);
  static const Color purpleSoftMedium = Color(0x4DDAE2FD);

  // Grey variants used by empty states, disabled controls, and card helper text.
  static const Color grey = Color(0xFF9E9E9E);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);

  // One-off form divider greys converted from Color.fromARGB values.
  static const Color budgetFormDivider = Color(0xFFC8C7C7);
  static const Color goalFormDivider = Color(0xFFD0CECE);
}
