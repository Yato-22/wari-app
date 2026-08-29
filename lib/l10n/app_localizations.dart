import 'package:flutter/material.dart';

class AppLocalizations {
  final String locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    // A simplified provider pattern to avoid heavy boilerplates
    return AppLocalizations('en'); // this will be overridden
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'home': 'Home',
      'map': 'Map',
      'volunteer': 'Volunteer',
      'reports': 'Reports',
      'profile': 'Profile',
      'continue': 'Continue',
      'select_language': 'Select Language',
      'language_desc': 'Choose your preferred language for the pilgrimage journey',
      'search_hint': 'Search facilities, medical, water, camps...',
      'all': 'All',
      'food': 'Food',
      'water': 'Water',
      'medical': 'Medical',
      'toilet': 'Toilet',
      'live_palkhi': 'Live Palkhi',
      'navigate': 'Navigate',
      'report_issue': 'Report Issue',
      'donate': 'Donate',
      'meals_stay_included': 'Meals & Stay Included',
      'view_apply': 'View & Apply',
      'slots_left': 'slots left',
    },
    'mr': {
      'home': 'मुख्यपृष्ठ',
      'map': 'नकाशा',
      'volunteer': 'स्वयंसेवक',
      'reports': 'अहवाल',
      'profile': 'प्रोफाइल',
      'continue': 'पुढे जा',
      'select_language': 'भाषा निवडा',
      'language_desc': 'वारीच्या प्रवासासाठी तुमची पसंतीची भाषा निवडा',
      'search_hint': 'सुविधा, वैद्यकीय, पाणी, शिबिरे शोधा...',
      'all': 'सर्व',
      'food': 'अन्न',
      'water': 'पाणी',
      'medical': 'वैद्यकीय',
      'toilet': 'शौचालय',
      'live_palkhi': 'थेट पालखी',
      'navigate': 'नेव्हिगेट करा',
      'report_issue': 'समस्या नोंदवा',
      'donate': 'देणगी द्या',
      'meals_stay_included': 'भोजन आणि निवास समाविष्ट',
      'view_apply': 'पहा आणि अर्ज करा',
      'slots_left': 'जागा शिल्लक',
    },
    'hi': {
      'home': 'मुख्य पृष्ठ',
      'map': 'नक्शा',
      'volunteer': 'स्वयंसेवक',
      'reports': 'रिपोर्ट',
      'profile': 'प्रोफ़ाइल',
      'continue': 'आगे बढ़ें',
      'select_language': 'भाषा चुनें',
      'language_desc': 'तीर्थयात्रा के लिए अपनी पसंदीदा भाषा चुनें',
      'search_hint': 'सुविधाएं, चिकित्सा, पानी, शिविर खोजें...',
      'all': 'सभी',
      'food': 'भोजन',
      'water': 'पानी',
      'medical': 'चिकित्सा',
      'toilet': 'शौचालय',
      'live_palkhi': 'लाइव पालखी',
      'navigate': 'नेविगेट करें',
      'report_issue': 'समस्या दर्ज करें',
      'donate': 'दान करें',
      'meals_stay_included': 'भोजन और आवास शामिल',
      'view_apply': 'देखें और आवेदन करें',
      'slots_left': 'जगह बची है',
    },
  };

  String translate(String key) {
    return _localizedValues[locale]?[key] ?? _localizedValues['en']?[key] ?? key;
  }
}
