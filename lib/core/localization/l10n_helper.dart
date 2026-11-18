import 'package:flutter/material.dart';
import 'package:matrimony_app/l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this) ?? lookupAppLocalizations(const Locale('en'));

  bool get isMarathi {
    final loc = Localizations.maybeLocaleOf(this);
    return loc?.languageCode == 'mr';
  }

  /// Translates dynamic database strings, dropdown options, and labels
  /// to Marathi when the app locale is Marathi, keeping backend canonical strings intact.
  String tr(String? value) {
    if (value == null || value.trim().isEmpty) return '';
    if (!isMarathi) return value;
    return L10nHelper.translateToMarathi(value);
  }
}

class L10nHelper {
  /// Comprehensive mapping of canonical English backend options to authentic Marathi Devanagari labels
  static final Map<String, String> _marathiDictionary = {
    // Profile Created For
    'Yourself': 'स्वतःसाठी',
    'Self': 'स्वतःसाठी',
    'Son': 'मुलगा',
    'Daughter': 'मुलगी',
    'Brother': 'भाऊ',
    'Sister': 'बहीण',
    'Friend': 'मित्र',
    'Relative': 'नातेवाईक',

    // Gender
    'Male': 'पुरुष',
    'Female': 'स्त्री',
    'Other': 'इतर',

    // Marital Status
    'Never Married': 'अविवाहित',
    'Divorced': 'घटस्फोटित',
    'Widowed': 'विधुर/विधवा',
    'Awaiting Divorce': 'घटस्फोट प्रतीक्षेत',
    'Separated': 'विभक्त',

    // Diet
    'Vegetarian': 'शाकाहारी',
    'Non-Vegetarian': 'मांसाहारी',
    'Eggetarian': 'अंडाहारी',
    'Vegan': 'व्हेगन',
    'Jain': 'जैन',

    // Physical Status / Special Case
    'Normal': 'सामान्य',
    'Physically Challenged': 'दिव्यांग',
    'Visually Impaired': 'दृष्टिहीन',
    'Hearing Impaired': 'कर्णबधिर',

    // Highest Education
    'Doctorate/PhD': 'डॉक्टरेट / पीएचडी',
    'Masters/Post Graduate': 'मास्टर्स / पदव्युत्तर',
    'Bachelors/Graduate': 'पदवीधर (ग्रॅज्युएट)',
    'Diploma': 'डिप्लोमा',
    'Higher Secondary (12th)': 'उच्च माध्यमिक (१२ वी)',
    'Secondary (10th)': 'माध्यमिक (१० वी)',
    'Below 10th': '१० वी पेक्षा कमी',
    'Others': 'इतर',

    // Profession / Occupation
    'Software / IT': 'सॉफ्टवेअर / आयटी',
    'Banking / Finance': 'बँकिंग / वित्त',
    'Doctor / Medical': 'डॉक्टर / वैद्यकीय',
    'Engineer': 'अभियंता (इंजिनिअर)',
    'Government / Civil Services': 'शासकीय सेवा',
    'Business / Self-Employed': 'व्यवसाय / स्वयंरोजगार',
    'Teaching / Education': 'शिक्षक / शिक्षण',
    'Agriculture': 'शेती / कृषी',
    'Private Sector': 'खाजगी नोकरी',
    'Not Working': 'काम करत नाही',

    // Annual Income
    'No Income': 'उत्पन्न नाही',
    'Under ₹2 Lakhs': '२ लाखांपेक्षा कमी',
    '₹2 - 5 Lakhs': '२ ते ५ लाख',
    '₹5 - 10 Lakhs': '५ ते १० लाख',
    '₹10 - 20 Lakhs': '१० ते २० लाख',
    '₹20 - 35 Lakhs': '२० ते ३५ लाख',
    '₹35 - 50 Lakhs': '३५ ते ५० लाख',
    '₹50 Lakhs - 1 Crore': '५० लाख ते १ कोटी',
    'Above ₹1 Crore': '१ कोटीपेक्षा जास्त',

    // Religion
    'Hindu': 'हिंदू',
    'Muslim': 'मुस्लिम',
    'Christian': 'ख्रिश्चन',
    'Sikh': 'शीख',
    'Buddhist': 'बौद्ध',
    'Parsi': 'पारशी',
    'Jewish': 'ज्यू',

    // Caste
    'Kunbi': 'कुणबी',
    'Kunbi Maratha': 'कुणबी मराठा',
    'Tirale Kunbi': 'तिरळे कुणबी',
    'Dhanoje Kunbi': 'धानोजे कुणबी',
    'Khaire Kunbi': 'खैरे कुणबी',
    'Ghate Kunbi': 'घाटे कुणबी',
    'Maratha': 'मराठा',
    'Brahmin': 'ब्राह्मण',
    'Nair': 'नायर',
    'Ezhava': 'एझावा',
    'Lingayat': 'लिंगायत',

    // Family Type
    'Nuclear': 'विभक्त',
    'Joint': 'संयुक्त',

    // Complexion
    'Fair': 'गोरा',
    'Very Fair': 'अतिशय गोरा',
    'Wheatish': 'गव्हाळ',
    'Dark': 'सावळा',

    // Body Type
    'Slim': 'बारीक',
    'Athletic': 'कसरती / ॲथलेटिक',
    'Average': 'मध्यम',
    'Heavy': 'स्थूल',

    // Habits
    'No': 'नाही',
    'Yes': 'होय',
    'Occasionally': 'कधीतरी',

    // Horoscope
    'Anshik/Partial': 'आंशिक / सौम्य',
    'Don\'t Know': 'माहित नाही',
    'Rakshasa': 'राक्षस',
    'Deva': 'देव',
    'Manushya': 'मनुष्य',
    'Adi': 'आद्य',
    'Madhya': 'मध्य',
    'Antya': 'अंत्य',
    '✨ High': 'उच्च',
    'Medium': 'मध्यम',
    'Low': 'कमी',

    // Values
    'Traditional': 'पारंपरिक',
    'Moderate': 'मध्यममार्गी',
    'Liberal': 'पुरोगामी',

    // Months
    'January': 'जानेवारी',
    'February': 'फेब्रुवारी',
    'March': 'मार्च',
    'April': 'एप्रिल',
    'May': 'मे',
    'June': 'जून',
    'July': 'जुलै',
    'August': 'ऑगस्ट',
    'September': 'सप्टेंबर',
    'October': 'ऑक्टोबर',
    'November': 'नोव्हेंबर',
    'December': 'डिसेंबर',

    // Uncles
    'Maternal Uncle (Mama)': 'मामा (आईचे भाऊ)',
    'Paternal Uncle (Kaka)': 'काका (वडिलांचे भाऊ)',
    'Mama': 'मामा',
    'Kaka': 'काका',

    // Verification
    'Verified': 'सत्यापित',
    'Pending': 'प्रलंबित',
    'Rejected': 'नाकारले',
    'Approved': 'मंजूर',

    // Common Profile Section Headers & Labels
    'Basic Details': 'प्राथमिक माहिती',
    'Personal Details': 'वैयक्तिक माहिती',
    'Education & Career': 'शिक्षण आणि करिअर',
    'Location & Family': 'पत्ता आणि कौटुंबिक माहिती',
    'Document Details': 'कागदपत्रांची माहिती',
    'Partner Preferences': 'अपेक्षित जोडीदार',
    'Family Details': 'कौटुंबिक तपशील',
    'Horoscope Details': 'कुंडली तपशील',
    'Lifestyle': 'जीवनशैली',
    'Physical Appearance': 'शारीरिक माहिती',
    'Contact Information': 'संपर्क माहिती',
    'Photos': 'फोटो',

    // Photo Management
    'Profile Photos Management': 'प्रोफाइल फोटो व्यवस्थापन',
    'Take Photo from Camera': 'कॅमेऱ्यातून फोटो काढा',
    'Upload Photo from Gallery': 'गॅलरीतून फोटो निवडा',
    'Maximum 6 profile photos are allowed.': 'कमाल ६ प्रोफाइल फोटोंना परवानगी आहे.',
    'Could not open the camera. Please try the gallery.': 'कॅमेरा उघडता आला नाही. कृपया गॅलरीचा वापर करा.',
    'Could not select the image. Please try again.': 'फोटो निवडता आला नाही. कृपया पुन्हा प्रयत्न करा.',
    'You have reached the 6-photo limit. Delete a photo to add another.': 'तुम्ही ६ फोटोंची मर्यादा गाठली आहे. दुसरा जोडण्यासाठी एक फोटो हटवा.',
    'Saved Photos (Tap × to delete)': 'जतन केलेले फोटो (हटवण्यासाठी × टॅप करा)',
  };

  /// Translate an English canonical string to Marathi
  static String translateToMarathi(String english) {
    final trimmed = english.trim();
    if (_marathiDictionary.containsKey(trimmed)) {
      return _marathiDictionary[trimmed]!;
    }
    return english;
  }
}
