import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('mr')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Soyarik'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Find Your Life Partner'**
  String get tagline;

  /// No description provided for @subTagline.
  ///
  /// In en, this message translates to:
  /// **'A beautiful journey begins here...'**
  String get subTagline;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search here...'**
  String get searchHint;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get noInternetConnection;

  /// No description provided for @exitApp.
  ///
  /// In en, this message translates to:
  /// **'Exit Application?'**
  String get exitApp;

  /// No description provided for @exitAppConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to exit the app?'**
  String get exitAppConfirmation;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The app is available in English and Marathi.'**
  String get languageSubtitle;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @marathi.
  ///
  /// In en, this message translates to:
  /// **'Marathi (मराठी)'**
  String get marathi;

  /// No description provided for @languageSaved.
  ///
  /// In en, this message translates to:
  /// **'Language preference updated successfully.'**
  String get languageSaved;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLikes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get navLikes;

  /// No description provided for @navMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get navMessages;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login to Your Account'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number or email to continue'**
  String get loginSubtitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @emailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Email / Mobile Number'**
  String get emailOrPhone;

  /// No description provided for @emailOrPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or mobile'**
  String get emailOrPhoneHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @loginHere.
  ///
  /// In en, this message translates to:
  /// **'Login here'**
  String get loginHere;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @otpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// No description provided for @enterOtpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4-digit code sent to'**
  String get enterOtpSentTo;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @resendOtpIn.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP in'**
  String get resendOtpIn;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get createNewPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully. Please login with your new password.'**
  String get passwordResetSuccess;

  /// No description provided for @stepBasicDetails.
  ///
  /// In en, this message translates to:
  /// **'Basic Details'**
  String get stepBasicDetails;

  /// No description provided for @stepBasicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us a little about yourself'**
  String get stepBasicSubtitle;

  /// No description provided for @stepPersonalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get stepPersonalDetails;

  /// No description provided for @stepPersonalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your lifestyle and physical details'**
  String get stepPersonalSubtitle;

  /// No description provided for @stepEducationCareer.
  ///
  /// In en, this message translates to:
  /// **'Education/Career'**
  String get stepEducationCareer;

  /// No description provided for @stepEducationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your education and the work you do'**
  String get stepEducationSubtitle;

  /// No description provided for @stepLocationFamily.
  ///
  /// In en, this message translates to:
  /// **'Location & Family'**
  String get stepLocationFamily;

  /// No description provided for @stepLocationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Where you live and your family background'**
  String get stepLocationSubtitle;

  /// No description provided for @stepDocumentDetails.
  ///
  /// In en, this message translates to:
  /// **'Document Details'**
  String get stepDocumentDetails;

  /// No description provided for @stepDocumentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your identity to build trust'**
  String get stepDocumentSubtitle;

  /// No description provided for @reviewRegistration.
  ///
  /// In en, this message translates to:
  /// **'Review Registration'**
  String get reviewRegistration;

  /// No description provided for @reviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please review your details before final submission'**
  String get reviewSubtitle;

  /// No description provided for @profileCreatedFor.
  ///
  /// In en, this message translates to:
  /// **'Profile created for'**
  String get profileCreatedFor;

  /// No description provided for @selectProfileCreatedFor.
  ///
  /// In en, this message translates to:
  /// **'Select Profile Created For'**
  String get selectProfileCreatedFor;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter Full Name'**
  String get enterFullName;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile Number'**
  String get enterMobileNumber;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @motherTongue.
  ///
  /// In en, this message translates to:
  /// **'Mother Tongue'**
  String get motherTongue;

  /// No description provided for @selectMotherTongue.
  ///
  /// In en, this message translates to:
  /// **'Select Mother Tongue'**
  String get selectMotherTongue;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter Email Address'**
  String get enterEmailAddress;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create Password'**
  String get createPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordRequirementNote.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters with 1 uppercase letter, 1 lowercase letter & 1 number.'**
  String get passwordRequirementNote;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get selectGender;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get maritalStatus;

  /// No description provided for @selectMaritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Select Marital Status'**
  String get selectMaritalStatus;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @selectHeight.
  ///
  /// In en, this message translates to:
  /// **'Select Height (cm)'**
  String get selectHeight;

  /// No description provided for @diet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get diet;

  /// No description provided for @selectDiet.
  ///
  /// In en, this message translates to:
  /// **'Select Diet'**
  String get selectDiet;

  /// No description provided for @physicalStatus.
  ///
  /// In en, this message translates to:
  /// **'Physical Status / Special Case'**
  String get physicalStatus;

  /// No description provided for @selectPhysicalStatus.
  ///
  /// In en, this message translates to:
  /// **'Select Status'**
  String get selectPhysicalStatus;

  /// No description provided for @highestEducation.
  ///
  /// In en, this message translates to:
  /// **'Highest Education'**
  String get highestEducation;

  /// No description provided for @selectEducation.
  ///
  /// In en, this message translates to:
  /// **'Select Education'**
  String get selectEducation;

  /// No description provided for @professionOccupation.
  ///
  /// In en, this message translates to:
  /// **'Profession / Occupation'**
  String get professionOccupation;

  /// No description provided for @selectProfession.
  ///
  /// In en, this message translates to:
  /// **'Select Profession'**
  String get selectProfession;

  /// No description provided for @annualIncome.
  ///
  /// In en, this message translates to:
  /// **'Annual Income'**
  String get annualIncome;

  /// No description provided for @selectIncome.
  ///
  /// In en, this message translates to:
  /// **'Select Income'**
  String get selectIncome;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @selectState.
  ///
  /// In en, this message translates to:
  /// **'Select State'**
  String get selectState;

  /// No description provided for @cityDistrict.
  ///
  /// In en, this message translates to:
  /// **'City / District'**
  String get cityDistrict;

  /// No description provided for @enterCity.
  ///
  /// In en, this message translates to:
  /// **'Enter City / District'**
  String get enterCity;

  /// No description provided for @religion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get religion;

  /// No description provided for @selectReligion.
  ///
  /// In en, this message translates to:
  /// **'Select Religion'**
  String get selectReligion;

  /// No description provided for @caste.
  ///
  /// In en, this message translates to:
  /// **'Caste'**
  String get caste;

  /// No description provided for @selectCaste.
  ///
  /// In en, this message translates to:
  /// **'Select Caste'**
  String get selectCaste;

  /// No description provided for @subCaste.
  ///
  /// In en, this message translates to:
  /// **'Sub Caste'**
  String get subCaste;

  /// No description provided for @enterSubCaste.
  ///
  /// In en, this message translates to:
  /// **'Enter Sub Caste'**
  String get enterSubCaste;

  /// No description provided for @familyType.
  ///
  /// In en, this message translates to:
  /// **'Family Type'**
  String get familyType;

  /// No description provided for @selectFamilyType.
  ///
  /// In en, this message translates to:
  /// **'Select Family Type'**
  String get selectFamilyType;

  /// No description provided for @fatherName.
  ///
  /// In en, this message translates to:
  /// **'Father\'s Name'**
  String get fatherName;

  /// No description provided for @enterFatherName.
  ///
  /// In en, this message translates to:
  /// **'Enter Father\'s Name'**
  String get enterFatherName;

  /// No description provided for @fatherOccupation.
  ///
  /// In en, this message translates to:
  /// **'Father\'s Occupation'**
  String get fatherOccupation;

  /// No description provided for @enterFatherOccupation.
  ///
  /// In en, this message translates to:
  /// **'Enter Father\'s Occupation'**
  String get enterFatherOccupation;

  /// No description provided for @motherName.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Name'**
  String get motherName;

  /// No description provided for @enterMotherName.
  ///
  /// In en, this message translates to:
  /// **'Enter Mother\'s Name'**
  String get enterMotherName;

  /// No description provided for @motherOccupation.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Occupation'**
  String get motherOccupation;

  /// No description provided for @enterMotherOccupation.
  ///
  /// In en, this message translates to:
  /// **'Enter Mother\'s Occupation'**
  String get enterMotherOccupation;

  /// No description provided for @numberOfBrothers.
  ///
  /// In en, this message translates to:
  /// **'Number of Brothers'**
  String get numberOfBrothers;

  /// No description provided for @numberOfSisters.
  ///
  /// In en, this message translates to:
  /// **'Number of Sisters'**
  String get numberOfSisters;

  /// No description provided for @uncles.
  ///
  /// In en, this message translates to:
  /// **'Uncles (Mama / Kaka)'**
  String get uncles;

  /// No description provided for @addUncle.
  ///
  /// In en, this message translates to:
  /// **'Add Uncle'**
  String get addUncle;

  /// No description provided for @uncleName.
  ///
  /// In en, this message translates to:
  /// **'Uncle Name'**
  String get uncleName;

  /// No description provided for @uncleType.
  ///
  /// In en, this message translates to:
  /// **'Uncle Type'**
  String get uncleType;

  /// No description provided for @uncleCity.
  ///
  /// In en, this message translates to:
  /// **'City / Location'**
  String get uncleCity;

  /// No description provided for @uncleContact.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get uncleContact;

  /// No description provided for @verificationNotice.
  ///
  /// In en, this message translates to:
  /// **'Verification Notice'**
  String get verificationNotice;

  /// No description provided for @verificationNoticeDesc.
  ///
  /// In en, this message translates to:
  /// **'The uploaded documents will be thoroughly verified to ensure authenticity. Please provide genuine Aadhaar and Caste Certificates to avoid account suspension.'**
  String get verificationNoticeDesc;

  /// No description provided for @aadhaarCard.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Card'**
  String get aadhaarCard;

  /// No description provided for @uploadAadhaarCard.
  ///
  /// In en, this message translates to:
  /// **'Upload Aadhaar Card (PDF / JPG / PNG)'**
  String get uploadAadhaarCard;

  /// No description provided for @aadhaarNumber.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Number'**
  String get aadhaarNumber;

  /// No description provided for @enterAadhaarNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter 12-digit Aadhaar Number'**
  String get enterAadhaarNumber;

  /// No description provided for @casteCertificate.
  ///
  /// In en, this message translates to:
  /// **'Caste Certificate'**
  String get casteCertificate;

  /// No description provided for @uploadCasteCertificate.
  ///
  /// In en, this message translates to:
  /// **'Upload Caste Certificate (PDF / JPG / PNG)'**
  String get uploadCasteCertificate;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'(Optional)'**
  String get optional;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'(Required)'**
  String get required;

  /// No description provided for @fileSelected.
  ///
  /// In en, this message translates to:
  /// **'File Selected'**
  String get fileSelected;

  /// No description provided for @tapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to Upload'**
  String get tapToUpload;

  /// No description provided for @changeFile.
  ///
  /// In en, this message translates to:
  /// **'Change File'**
  String get changeFile;

  /// No description provided for @profilePhotos.
  ///
  /// In en, this message translates to:
  /// **'Profile Photos'**
  String get profilePhotos;

  /// No description provided for @addProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addProfilePhoto;

  /// No description provided for @uploadAtLeastOnePhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload at least 1 photo of the candidate'**
  String get uploadAtLeastOnePhoto;

  /// No description provided for @submitRegistration.
  ///
  /// In en, this message translates to:
  /// **'Submit Registration'**
  String get submitRegistration;

  /// No description provided for @submittingRegistration.
  ///
  /// In en, this message translates to:
  /// **'Submitting registration...'**
  String get submittingRegistration;

  /// No description provided for @editSection.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editSection;

  /// No description provided for @registrationSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration Successful!'**
  String get registrationSuccessTitle;

  /// No description provided for @registrationSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Soyarik! Your profile has been created successfully.'**
  String get registrationSuccessMessage;

  /// No description provided for @searchProfiles.
  ///
  /// In en, this message translates to:
  /// **'Search profiles...'**
  String get searchProfiles;

  /// No description provided for @matchesForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended Matches'**
  String get matchesForYou;

  /// No description provided for @newProfiles.
  ///
  /// In en, this message translates to:
  /// **'New Profiles'**
  String get newProfiles;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// No description provided for @sendInterest.
  ///
  /// In en, this message translates to:
  /// **'Send Interest'**
  String get sendInterest;

  /// No description provided for @interestSent.
  ///
  /// In en, this message translates to:
  /// **'Interest Sent'**
  String get interestSent;

  /// No description provided for @shortlist.
  ///
  /// In en, this message translates to:
  /// **'Shortlist'**
  String get shortlist;

  /// No description provided for @shortlisted.
  ///
  /// In en, this message translates to:
  /// **'Shortlisted'**
  String get shortlisted;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @yrs.
  ///
  /// In en, this message translates to:
  /// **'yrs'**
  String get yrs;

  /// No description provided for @cm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get cm;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @profession.
  ///
  /// In en, this message translates to:
  /// **'Profession'**
  String get profession;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @noProfilesFound.
  ///
  /// In en, this message translates to:
  /// **'No profiles found'**
  String get noProfilesFound;

  /// No description provided for @filterProfiles.
  ///
  /// In en, this message translates to:
  /// **'Filter Profiles'**
  String get filterProfiles;

  /// No description provided for @resetFilter.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetFilter;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @profileCompletion.
  ///
  /// In en, this message translates to:
  /// **'Profile Completion'**
  String get profileCompletion;

  /// No description provided for @completeYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile to get 3x more matches'**
  String get completeYourProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @viewFullProfile.
  ///
  /// In en, this message translates to:
  /// **'View Full Profile'**
  String get viewFullProfile;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @educationAndCareer.
  ///
  /// In en, this message translates to:
  /// **'Education & Career'**
  String get educationAndCareer;

  /// No description provided for @horoscopeDetails.
  ///
  /// In en, this message translates to:
  /// **'Horoscope & Astro Details'**
  String get horoscopeDetails;

  /// No description provided for @familyInformation.
  ///
  /// In en, this message translates to:
  /// **'Family Information'**
  String get familyInformation;

  /// No description provided for @partnerPreferences.
  ///
  /// In en, this message translates to:
  /// **'Partner Preferences'**
  String get partnerPreferences;

  /// No description provided for @aboutMe.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get aboutMe;

  /// No description provided for @writeAboutMyself.
  ///
  /// In en, this message translates to:
  /// **'Write something about yourself...'**
  String get writeAboutMyself;

  /// No description provided for @photoGallery.
  ///
  /// In en, this message translates to:
  /// **'Photo Gallery'**
  String get photoGallery;

  /// No description provided for @managePhotos.
  ///
  /// In en, this message translates to:
  /// **'Manage Photos'**
  String get managePhotos;

  /// No description provided for @setAsProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Set as Profile Picture'**
  String get setAsProfilePhoto;

  /// No description provided for @deletePhoto.
  ///
  /// In en, this message translates to:
  /// **'Delete Photo'**
  String get deletePhoto;

  /// No description provided for @deletePhotoConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this photo?'**
  String get deletePhotoConfirm;

  /// No description provided for @rashi.
  ///
  /// In en, this message translates to:
  /// **'Rashi / Zodiac'**
  String get rashi;

  /// No description provided for @nakshatra.
  ///
  /// In en, this message translates to:
  /// **'Nakshatra'**
  String get nakshatra;

  /// No description provided for @manglik.
  ///
  /// In en, this message translates to:
  /// **'Manglik'**
  String get manglik;

  /// No description provided for @nadi.
  ///
  /// In en, this message translates to:
  /// **'Nadi'**
  String get nadi;

  /// No description provided for @gana.
  ///
  /// In en, this message translates to:
  /// **'Gana'**
  String get gana;

  /// No description provided for @charan.
  ///
  /// In en, this message translates to:
  /// **'Charan'**
  String get charan;

  /// No description provided for @gotra.
  ///
  /// In en, this message translates to:
  /// **'Gotra'**
  String get gotra;

  /// No description provided for @birthTime.
  ///
  /// In en, this message translates to:
  /// **'Birth Time'**
  String get birthTime;

  /// No description provided for @birthPlace.
  ///
  /// In en, this message translates to:
  /// **'Birth Place'**
  String get birthPlace;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccess;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notificationPreferences;

  /// No description provided for @changedPassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changedPassword;

  /// No description provided for @partnerPreference.
  ///
  /// In en, this message translates to:
  /// **'Partner Preference'**
  String get partnerPreference;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Wedding Services'**
  String get services;

  /// No description provided for @testimonials.
  ///
  /// In en, this message translates to:
  /// **'Testimonials'**
  String get testimonials;

  /// No description provided for @blockedProfiles.
  ///
  /// In en, this message translates to:
  /// **'Blocked Profiles'**
  String get blockedProfiles;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help and Support'**
  String get helpAndSupport;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout?'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout from Soyarik?'**
  String get logoutConfirmMessage;

  /// No description provided for @stayLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Stay Logged In'**
  String get stayLoggedIn;

  /// No description provided for @upcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get upcomingEvents;

  /// No description provided for @pastEvents.
  ///
  /// In en, this message translates to:
  /// **'Past Events'**
  String get pastEvents;

  /// No description provided for @noEventsFound.
  ///
  /// In en, this message translates to:
  /// **'No events available at the moment'**
  String get noEventsFound;

  /// No description provided for @eventDetails.
  ///
  /// In en, this message translates to:
  /// **'Event Details'**
  String get eventDetails;

  /// No description provided for @registerForEvent.
  ///
  /// In en, this message translates to:
  /// **'Register for Event'**
  String get registerForEvent;

  /// No description provided for @weddingServices.
  ///
  /// In en, this message translates to:
  /// **'Wedding Services'**
  String get weddingServices;

  /// No description provided for @trustedVendors.
  ///
  /// In en, this message translates to:
  /// **'Trusted Wedding Vendors'**
  String get trustedVendors;

  /// No description provided for @viewVendors.
  ///
  /// In en, this message translates to:
  /// **'View Vendors'**
  String get viewVendors;

  /// No description provided for @contactVendor.
  ///
  /// In en, this message translates to:
  /// **'Contact Vendor'**
  String get contactVendor;

  /// No description provided for @callNow.
  ///
  /// In en, this message translates to:
  /// **'Call Now'**
  String get callNow;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @valRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get valRequired;

  /// No description provided for @valNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter full name'**
  String get valNameRequired;

  /// No description provided for @valMobileRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter mobile number'**
  String get valMobileRequired;

  /// No description provided for @valMobileInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit mobile number'**
  String get valMobileInvalid;

  /// No description provided for @valEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter email address'**
  String get valEmailRequired;

  /// No description provided for @valEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get valEmailInvalid;

  /// No description provided for @valPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get valPasswordRequired;

  /// No description provided for @valPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get valPasswordLength;

  /// No description provided for @valPasswordRule.
  ///
  /// In en, this message translates to:
  /// **'Password must contain 1 uppercase letter, 1 lowercase letter, and 1 number'**
  String get valPasswordRule;

  /// No description provided for @valPasswordMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get valPasswordMatch;

  /// No description provided for @valDobRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select valid date of birth'**
  String get valDobRequired;

  /// No description provided for @valAgeRestriction.
  ///
  /// In en, this message translates to:
  /// **'Candidate must be at least 18 years old'**
  String get valAgeRestriction;

  /// No description provided for @valAadhaarRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter 12-digit Aadhaar number'**
  String get valAadhaarRequired;

  /// No description provided for @valAadhaarInvalid.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar number must be exactly 12 digits'**
  String get valAadhaarInvalid;

  /// No description provided for @valPhotoRequired.
  ///
  /// In en, this message translates to:
  /// **'Please upload at least one profile photo'**
  String get valPhotoRequired;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'mr': return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
