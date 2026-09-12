import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ?? AppLocalizations(const Locale('en'));
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'Kisan Sarthi',
      'tagline': '"Har Kisan Ka Smart Saathi"',
      'greeting': 'Namaste',
      'crop_advisory': 'Crop Problem',
      'scan_crop': 'Scan Crop',
      'weather_advisory': 'Weather Advisory',
      'crop_rec': 'Crop Recommendation',
      'expert_support': 'Expert Support',
      'my_requests': 'My Requests',
      'profile': 'Farmer Profile',
    },
    'mr': {
      'app_title': 'किसान सारथी',
      'tagline': '"हर किसान का स्मार्ट साथी"',
      'greeting': 'नमस्कार',
      'crop_advisory': 'पीक समस्या',
      'scan_crop': 'पीक स्कॅन करा',
      'weather_advisory': 'हवामान अंदाज',
      'crop_rec': 'पीक शिफारस',
      'expert_support': 'तज्ज्ञ सल्ला',
      'my_requests': 'माझे अर्ज',
      'profile': 'शेतकरी प्रोफाईल',
    },
    'hi': {
      'app_title': 'किसान सारथी',
      'tagline': '"हर किसान का स्मार्ट साथी"',
      'greeting': 'नमस्ते',
      'crop_advisory': 'फसल समस्या',
      'scan_crop': 'फसल स्कैन करें',
      'weather_advisory': 'मौसम परामर्श',
      'crop_rec': 'फसल सिफारिश',
      'expert_support': 'विशेषज्ञ सलाह',
      'my_requests': 'मेरे अनुरोध',
      'profile': 'किसान प्रोफाइल',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? _localizedValues['en']![key] ?? key;
  }
}
