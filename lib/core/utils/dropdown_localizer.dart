import 'package:flutter/widgets.dart';
import '../../l10n/app_localizations.dart';

/// Helper to translate user-facing dropdown options and enum values
/// while keeping underlying API and database values unchanged.
class DropdownLocalizer {
  /// Maps an API/database value to its localized display string.
  /// If no localized display string is found, returns [value] as-is.
  static String getLabel(BuildContext context, String value) {
    if (value.isEmpty) return value;
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return value;

    final trimmed = value.trim();

    // Gender
    switch (trimmed) {
      case 'Male':
        return l10n.optMale;
      case 'Female':
        return l10n.optFemale;
      case 'Other':
        return l10n.optOther;

      // Marital Status
      case 'Never Married':
        return l10n.optNeverMarried;
      case 'Divorced':
        return l10n.optDivorced;
      case 'Widowed':
        return l10n.optWidowed;
      case 'Awaiting Divorce':
        return l10n.optAwaitingDivorce;

      // Diet
      case 'Vegetarian':
        return l10n.optVegetarian;
      case 'Non-Vegetarian':
        return l10n.optNonVegetarian;
      case 'Eggetarian':
        return l10n.optEggetarian;
      case 'Vegan':
        return l10n.optVegan;
      case 'Jain':
        return l10n.optJain;

      // Physical Status
      case 'Normal':
        return l10n.optNormal;
      case 'Physically Challenged':
        return l10n.optPhysicallyChallenged;
      case 'Visually Impaired':
        return l10n.optVisuallyImpaired;
      case 'Hearing Impaired':
        return l10n.optHearingImpaired;

      // Family Type
      case 'Joint':
        return l10n.optJoint;
      case 'Nuclear':
        return l10n.optNuclear;

      // Profile Created For
      case 'Yourself':
        return l10n.optYourself;
      case 'Son':
        return l10n.optSon;
      case 'Daughter':
        return l10n.optDaughter;
      case 'Brother':
        return l10n.optBrother;
      case 'Sister':
        return l10n.optSister;
      case 'Friend':
        return l10n.optFriend;
      case 'Relative':
        return l10n.optRelative;

      // Religion
      case 'Hindu':
        return l10n.optHindu;
      case 'Muslim':
        return l10n.optMuslim;
      case 'Christian':
        return l10n.optChristian;
      case 'Sikh':
        return l10n.optSikh;
      case 'Buddhist':
        return l10n.optBuddhist;
      case 'Parsi':
        return l10n.optParsi;
      case 'Jewish':
        return l10n.optJewish;

      // Caste
      case 'Kunbi':
        return l10n.optKunbi;
      case 'Maratha':
        return l10n.optMaratha;
      case 'Brahmin':
        return l10n.optBrahmin;
      case 'Vaishya':
        return l10n.optVaishya;
      case 'Kshatriya':
        return l10n.optKshatriya;
      case 'Nair':
        return l10n.optNair;
      case 'Ezhava':
        return l10n.optEzhava;
      case 'Lingayat':
        return l10n.optLingayat;
      case 'Rajput':
        return l10n.optRajput;

      // Profession
      case 'Software / IT Professional':
        return l10n.optSoftwareIT;
      case 'Hardware / Networking':
        return l10n.optHardware;
      case 'Government / Civil Services':
        return l10n.optGovt;
      case 'Private Sector':
        return l10n.optPrivate;
      case 'Banking / Finance':
        return l10n.optBanking;
      case 'Doctor / Medical Healthcare':
        return l10n.optDoctor;
      case 'Teacher / Professor':
        return l10n.optTeacher;
      case 'Business / Entrepreneur':
        return l10n.optBusiness;
      case 'Civil / Mechanical Engineer':
        return l10n.optEngineer;
      case 'Lawyer / Legal Professional':
        return l10n.optLawyer;
      case 'Defence / Police':
        return l10n.optDefence;
      case 'Agriculture / Farming':
        return l10n.optAgriculture;
      case 'Self Employed':
        return l10n.optSelfEmployed;
      case 'Not Working':
        return l10n.optNotWorking;

      // Annual Income
      case 'No Income':
        return l10n.optNoIncome;
      case 'Below 2 Lakh':
        return l10n.optBelow2Lakh;
      case '2 - 4 Lakh':
        return l10n.opt2To4Lakh;
      case '4 - 7 Lakh':
        return l10n.opt4To7Lakh;
      case '7 - 10 Lakh':
        return l10n.opt7To10Lakh;
      case '10 - 15 Lakh':
        return l10n.opt10To15Lakh;
      case '15 - 20 Lakh':
        return l10n.opt15To20Lakh;
      case '20 - 30 Lakh':
        return l10n.opt20To30Lakh;
      case '30 - 50 Lakh':
        return l10n.opt30To50Lakh;
      case '50 Lakh - 1 Crore':
        return l10n.opt50LakhTo1Cr;
      case 'Above 1 Crore':
        return l10n.optAbove1Cr;

      // Months
      case 'Jan':
        return l10n.localeName.startsWith('mr') ? 'जाने' : 'Jan';
      case 'Feb':
        return l10n.localeName.startsWith('mr') ? 'फेब्रु' : 'Feb';
      case 'Mar':
        return l10n.localeName.startsWith('mr') ? 'मार्च' : 'Mar';
      case 'Apr':
        return l10n.localeName.startsWith('mr') ? 'एप्रिल' : 'Apr';
      case 'May':
        return l10n.localeName.startsWith('mr') ? 'मे' : 'May';
      case 'Jun':
        return l10n.localeName.startsWith('mr') ? 'जून' : 'Jun';
      case 'Jul':
        return l10n.localeName.startsWith('mr') ? 'जुलै' : 'Jul';
      case 'Aug':
        return l10n.localeName.startsWith('mr') ? 'ऑगस्ट' : 'Aug';
      case 'Sep':
        return l10n.localeName.startsWith('mr') ? 'सप्टें' : 'Sep';
      case 'Oct':
        return l10n.localeName.startsWith('mr') ? 'ऑक्टो' : 'Oct';
      case 'Nov':
        return l10n.localeName.startsWith('mr') ? 'नोव्हें' : 'Nov';
      case 'Dec':
        return l10n.localeName.startsWith('mr') ? 'डिसें' : 'Dec';

      default:
        return value;
    }
  }
}
