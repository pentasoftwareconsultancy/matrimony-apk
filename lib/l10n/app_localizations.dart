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

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likes;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by name, profession, city...'**
  String get searchPlaceholder;

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

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

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

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @exitAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit Application?'**
  String get exitAppTitle;

  /// No description provided for @exitAppConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to exit the app?'**
  String get exitAppConfirm;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

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

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Crafting Beautiful\nBeginnings'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'A thoughtful space designed for intentional connections and shared futures. We move beyond filters to help you find a partner who truly aligns with your life goals.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Two Lives, One Perfect\nAlignment'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Where family, compatibility, and shared dreams gracefully bring two families together, let us help you discover the connection you\'ve been waiting for.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'The Trusted & Secure\nApproach'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Simplifying the search for a life partner with absolute clarity and elegance. Welcome to a sophisticated way of finding your forever.'**
  String get onboardingDesc3;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @enterEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterEmailAddress;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get pleaseEnterEmail;

  /// No description provided for @emailMustContainAt.
  ///
  /// In en, this message translates to:
  /// **'Email must contain @'**
  String get emailMustContainAt;

  /// No description provided for @validEmailEndingCom.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address ending in .com'**
  String get validEmailEndingCom;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordMin8.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get passwordMin8;

  /// No description provided for @passwordUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get passwordUppercase;

  /// No description provided for @passwordLowercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get passwordLowercase;

  /// No description provided for @forgotPasswordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordQuestion;

  /// No description provided for @byContinuingAgree.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our '**
  String get byContinuingAgree;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @andWord.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get andWord;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @forgotYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password'**
  String get forgotYourPassword;

  /// No description provided for @pleaseEnterEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter email or phone number'**
  String get pleaseEnterEmailOrPhone;

  /// No description provided for @byPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'By phone number'**
  String get byPhoneNumber;

  /// No description provided for @byEmail.
  ///
  /// In en, this message translates to:
  /// **'By email'**
  String get byEmail;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// No description provided for @otpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP verification'**
  String get otpVerification;

  /// No description provided for @verificationCodeSentTo.
  ///
  /// In en, this message translates to:
  /// **'A verification code has been sent to '**
  String get verificationCodeSentTo;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get enterCode;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter Otp'**
  String get enterOtp;

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'You can resend the code in '**
  String get resendCodeIn;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? '**
  String get didntReceiveCode;

  /// No description provided for @invalidOtpMessage.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP code. Please enter 1234.'**
  String get invalidOtpMessage;

  /// No description provided for @otpSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'OTP Sent Successfully'**
  String get otpSentSuccessfully;

  /// No description provided for @otpResentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'OTP code has been resent!'**
  String get otpResentSuccessfully;

  /// No description provided for @pleaseEnterAllDigits.
  ///
  /// In en, this message translates to:
  /// **'Please enter all 6 digits'**
  String get pleaseEnterAllDigits;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create new password'**
  String get createNewPassword;

  /// No description provided for @updatePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update password to enhance security'**
  String get updatePasswordSubtitle;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @applyChanges.
  ///
  /// In en, this message translates to:
  /// **'Apply Changes'**
  String get applyChanges;

  /// No description provided for @atLeastOneUppercase.
  ///
  /// In en, this message translates to:
  /// **'At least one uppercase'**
  String get atLeastOneUppercase;

  /// No description provided for @atLeastOneLowercase.
  ///
  /// In en, this message translates to:
  /// **'At least one lowercase'**
  String get atLeastOneLowercase;

  /// No description provided for @atLeast8Characters.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get atLeast8Characters;

  /// No description provided for @atLeastOneNumber.
  ///
  /// In en, this message translates to:
  /// **'At least one number'**
  String get atLeastOneNumber;

  /// No description provided for @atLeastOneSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'At least one special character'**
  String get atLeastOneSpecialChar;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Weak password, must contain'**
  String get weakPassword;

  /// No description provided for @mediumPassword.
  ///
  /// In en, this message translates to:
  /// **'Medium password, must contain'**
  String get mediumPassword;

  /// No description provided for @strongPassword.
  ///
  /// In en, this message translates to:
  /// **'Strong password!'**
  String get strongPassword;

  /// No description provided for @passwordUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password Updated\nSuccessfully'**
  String get passwordUpdatedSuccessfully;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'Basic Details'**
  String get step1Title;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get step2Title;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'Education/Career'**
  String get step3Title;

  /// No description provided for @step4Title.
  ///
  /// In en, this message translates to:
  /// **'Location & Family'**
  String get step4Title;

  /// No description provided for @step5Title.
  ///
  /// In en, this message translates to:
  /// **'Document Details'**
  String get step5Title;

  /// No description provided for @reviewRegistration.
  ///
  /// In en, this message translates to:
  /// **'Review Registration'**
  String get reviewRegistration;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @profileCreatedFor.
  ///
  /// In en, this message translates to:
  /// **'Profile Created For'**
  String get profileCreatedFor;

  /// No description provided for @selectProfileCreatedFor.
  ///
  /// In en, this message translates to:
  /// **'Select who this profile is for'**
  String get selectProfileCreatedFor;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @selectDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Select date of birth'**
  String get selectDateOfBirth;

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

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select gender'**
  String get selectGender;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get maritalStatus;

  /// No description provided for @selectMaritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Select marital status'**
  String get selectMaritalStatus;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @selectHeight.
  ///
  /// In en, this message translates to:
  /// **'Select height'**
  String get selectHeight;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weight;

  /// No description provided for @enterWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter weight'**
  String get enterWeight;

  /// No description provided for @diet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get diet;

  /// No description provided for @selectDiet.
  ///
  /// In en, this message translates to:
  /// **'Select diet'**
  String get selectDiet;

  /// No description provided for @bloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood Group'**
  String get bloodGroup;

  /// No description provided for @selectBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Select blood group'**
  String get selectBloodGroup;

  /// No description provided for @physicalStatus.
  ///
  /// In en, this message translates to:
  /// **'Physical Status'**
  String get physicalStatus;

  /// No description provided for @selectPhysicalStatus.
  ///
  /// In en, this message translates to:
  /// **'Select physical status'**
  String get selectPhysicalStatus;

  /// No description provided for @motherTongue.
  ///
  /// In en, this message translates to:
  /// **'Mother Tongue'**
  String get motherTongue;

  /// No description provided for @selectMotherTongue.
  ///
  /// In en, this message translates to:
  /// **'Select mother tongue'**
  String get selectMotherTongue;

  /// No description provided for @highestEducation.
  ///
  /// In en, this message translates to:
  /// **'Highest Education'**
  String get highestEducation;

  /// No description provided for @selectHighestEducation.
  ///
  /// In en, this message translates to:
  /// **'Select highest education'**
  String get selectHighestEducation;

  /// No description provided for @employedIn.
  ///
  /// In en, this message translates to:
  /// **'Employed In'**
  String get employedIn;

  /// No description provided for @selectEmployedIn.
  ///
  /// In en, this message translates to:
  /// **'Select employment sector'**
  String get selectEmployedIn;

  /// No description provided for @occupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation / Profession'**
  String get occupation;

  /// No description provided for @enterOccupation.
  ///
  /// In en, this message translates to:
  /// **'Enter occupation'**
  String get enterOccupation;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company / Organization'**
  String get companyName;

  /// No description provided for @enterCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Enter company name'**
  String get enterCompanyName;

  /// No description provided for @annualIncome.
  ///
  /// In en, this message translates to:
  /// **'Annual Income'**
  String get annualIncome;

  /// No description provided for @selectAnnualIncome.
  ///
  /// In en, this message translates to:
  /// **'Select annual income'**
  String get selectAnnualIncome;

  /// No description provided for @jobLocation.
  ///
  /// In en, this message translates to:
  /// **'Job Location'**
  String get jobLocation;

  /// No description provided for @enterJobLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter job location'**
  String get enterJobLocation;

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
  /// **'Select state'**
  String get selectState;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @enterCity.
  ///
  /// In en, this message translates to:
  /// **'Enter city'**
  String get enterCity;

  /// No description provided for @religion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get religion;

  /// No description provided for @selectReligion.
  ///
  /// In en, this message translates to:
  /// **'Select religion'**
  String get selectReligion;

  /// No description provided for @caste.
  ///
  /// In en, this message translates to:
  /// **'Caste'**
  String get caste;

  /// No description provided for @selectCaste.
  ///
  /// In en, this message translates to:
  /// **'Select caste'**
  String get selectCaste;

  /// No description provided for @subCaste.
  ///
  /// In en, this message translates to:
  /// **'Sub-Caste'**
  String get subCaste;

  /// No description provided for @enterSubCaste.
  ///
  /// In en, this message translates to:
  /// **'Enter sub-caste'**
  String get enterSubCaste;

  /// No description provided for @gothram.
  ///
  /// In en, this message translates to:
  /// **'Gothram'**
  String get gothram;

  /// No description provided for @enterGothram.
  ///
  /// In en, this message translates to:
  /// **'Enter gothram'**
  String get enterGothram;

  /// No description provided for @fatherStatus.
  ///
  /// In en, this message translates to:
  /// **'Father\'s Status'**
  String get fatherStatus;

  /// No description provided for @enterFatherStatus.
  ///
  /// In en, this message translates to:
  /// **'Enter father\'s occupation or status'**
  String get enterFatherStatus;

  /// No description provided for @motherStatus.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Status'**
  String get motherStatus;

  /// No description provided for @enterMotherStatus.
  ///
  /// In en, this message translates to:
  /// **'Enter mother\'s occupation or status'**
  String get enterMotherStatus;

  /// No description provided for @numberOfBrothers.
  ///
  /// In en, this message translates to:
  /// **'Brothers'**
  String get numberOfBrothers;

  /// No description provided for @numberOfSisters.
  ///
  /// In en, this message translates to:
  /// **'Sisters'**
  String get numberOfSisters;

  /// No description provided for @familyType.
  ///
  /// In en, this message translates to:
  /// **'Family Type'**
  String get familyType;

  /// No description provided for @selectFamilyType.
  ///
  /// In en, this message translates to:
  /// **'Select family type'**
  String get selectFamilyType;

  /// No description provided for @familyValues.
  ///
  /// In en, this message translates to:
  /// **'Family Values'**
  String get familyValues;

  /// No description provided for @familyStatus.
  ///
  /// In en, this message translates to:
  /// **'Family Status'**
  String get familyStatus;

  /// No description provided for @maternalUncles.
  ///
  /// In en, this message translates to:
  /// **'Maternal Uncles (Mama)'**
  String get maternalUncles;

  /// No description provided for @paternalUncles.
  ///
  /// In en, this message translates to:
  /// **'Paternal Uncles (Kaka)'**
  String get paternalUncles;

  /// No description provided for @addUncle.
  ///
  /// In en, this message translates to:
  /// **'Add Uncle'**
  String get addUncle;

  /// No description provided for @uncleName.
  ///
  /// In en, this message translates to:
  /// **'Uncle\'s Name'**
  String get uncleName;

  /// No description provided for @enterUncleName.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get enterUncleName;

  /// No description provided for @uncleOccupation.
  ///
  /// In en, this message translates to:
  /// **'Uncle\'s Occupation'**
  String get uncleOccupation;

  /// No description provided for @enterUncleOccupation.
  ///
  /// In en, this message translates to:
  /// **'Enter occupation'**
  String get enterUncleOccupation;

  /// No description provided for @uncleCity.
  ///
  /// In en, this message translates to:
  /// **'Uncle\'s City'**
  String get uncleCity;

  /// No description provided for @enterUncleCity.
  ///
  /// In en, this message translates to:
  /// **'Enter city'**
  String get enterUncleCity;

  /// No description provided for @idProofType.
  ///
  /// In en, this message translates to:
  /// **'ID Proof Type'**
  String get idProofType;

  /// No description provided for @selectIdProofType.
  ///
  /// In en, this message translates to:
  /// **'Select ID proof type'**
  String get selectIdProofType;

  /// No description provided for @idProofNumber.
  ///
  /// In en, this message translates to:
  /// **'ID Proof / Aadhaar Number'**
  String get idProofNumber;

  /// No description provided for @enterIdProofNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter ID proof number'**
  String get enterIdProofNumber;

  /// No description provided for @uploadPhotos.
  ///
  /// In en, this message translates to:
  /// **'Upload Photos'**
  String get uploadPhotos;

  /// No description provided for @uploadPhotosDesc.
  ///
  /// In en, this message translates to:
  /// **'Add at least 1 clear photo. Maximum 5 photos.'**
  String get uploadPhotosDesc;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @uploadHoroscope.
  ///
  /// In en, this message translates to:
  /// **'Upload Horoscope (Kundali)'**
  String get uploadHoroscope;

  /// No description provided for @aboutMe.
  ///
  /// In en, this message translates to:
  /// **'About Me / Bio'**
  String get aboutMe;

  /// No description provided for @enterAboutMe.
  ///
  /// In en, this message translates to:
  /// **'Write a few words about yourself, interests and partner expectations...'**
  String get enterAboutMe;

  /// No description provided for @pleaseAgreeTerms.
  ///
  /// In en, this message translates to:
  /// **'Please accept terms and conditions to proceed'**
  String get pleaseAgreeTerms;

  /// No description provided for @finalSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Registration'**
  String get finalSubmit;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration Completed Successfully!'**
  String get registrationSuccess;

  /// No description provided for @pleaseFillRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields correctly'**
  String get pleaseFillRequiredFields;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Find Your Perfect Soulmate'**
  String get welcomeBack;

  /// No description provided for @matchmakingEvents.
  ///
  /// In en, this message translates to:
  /// **'Matchmaking Events'**
  String get matchmakingEvents;

  /// No description provided for @viewAllEvents.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAllEvents;

  /// No description provided for @profileViews.
  ///
  /// In en, this message translates to:
  /// **'Profile Views'**
  String get profileViews;

  /// No description provided for @whoViewedYourProfile.
  ///
  /// In en, this message translates to:
  /// **'people viewed your profile recently'**
  String get whoViewedYourProfile;

  /// No description provided for @nearMe.
  ///
  /// In en, this message translates to:
  /// **'Near Me'**
  String get nearMe;

  /// No description provided for @newMatches.
  ///
  /// In en, this message translates to:
  /// **'New Matches'**
  String get newMatches;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @dailyRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Daily Recommendations'**
  String get dailyRecommendations;

  /// No description provided for @noProfilesFound.
  ///
  /// In en, this message translates to:
  /// **'No profiles found'**
  String get noProfilesFound;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search filters.'**
  String get tryAdjustingFilters;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @connectNow.
  ///
  /// In en, this message translates to:
  /// **'Connect Now'**
  String get connectNow;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// No description provided for @compatibility.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get compatibility;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Favorite Profiles'**
  String get favoritesTitle;

  /// No description provided for @searchFavorites.
  ///
  /// In en, this message translates to:
  /// **'Search favorites...'**
  String get searchFavorites;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No favorite profiles yet'**
  String get noFavoritesYet;

  /// No description provided for @noFavoritesDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart icon on any profile to save it here for quick access.'**
  String get noFavoritesDesc;

  /// No description provided for @removeFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeFavorite;

  /// No description provided for @removeFavoriteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this profile from favorites?'**
  String get removeFavoriteConfirm;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get chats;

  /// No description provided for @searchChats.
  ///
  /// In en, this message translates to:
  /// **'Search conversations...'**
  String get searchChats;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessagesYet;

  /// No description provided for @noMessagesDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect with matches and start chatting right here.'**
  String get noMessagesDesc;

  /// No description provided for @typeAMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeAMessage;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @blockUser.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get blockUser;

  /// No description provided for @unblockUser.
  ///
  /// In en, this message translates to:
  /// **'Unblock User'**
  String get unblockUser;

  /// No description provided for @reportUser.
  ///
  /// In en, this message translates to:
  /// **'Report User'**
  String get reportUser;

  /// No description provided for @filterBy.
  ///
  /// In en, this message translates to:
  /// **'Filter Profiles'**
  String get filterBy;

  /// No description provided for @ageRange.
  ///
  /// In en, this message translates to:
  /// **'Age Range'**
  String get ageRange;

  /// No description provided for @heightRange.
  ///
  /// In en, this message translates to:
  /// **'Height Range'**
  String get heightRange;

  /// No description provided for @selectMaritalStatusFilter.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get selectMaritalStatusFilter;

  /// No description provided for @selectReligionFilter.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get selectReligionFilter;

  /// No description provided for @selectCasteFilter.
  ///
  /// In en, this message translates to:
  /// **'Caste'**
  String get selectCasteFilter;

  /// No description provided for @selectMotherTongueFilter.
  ///
  /// In en, this message translates to:
  /// **'Mother Tongue'**
  String get selectMotherTongueFilter;

  /// No description provided for @selectEducationFilter.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get selectEducationFilter;

  /// No description provided for @selectProfessionFilter.
  ///
  /// In en, this message translates to:
  /// **'Profession'**
  String get selectProfessionFilter;

  /// No description provided for @selectIncomeFilter.
  ///
  /// In en, this message translates to:
  /// **'Annual Income'**
  String get selectIncomeFilter;

  /// No description provided for @selectLocationFilter.
  ///
  /// In en, this message translates to:
  /// **'Location (State/City)'**
  String get selectLocationFilter;

  /// No description provided for @selectDietFilter.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get selectDietFilter;

  /// No description provided for @selectFamilyTypeFilter.
  ///
  /// In en, this message translates to:
  /// **'Family Type'**
  String get selectFamilyTypeFilter;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// No description provided for @partnerPreferences.
  ///
  /// In en, this message translates to:
  /// **'Partner Preferences'**
  String get partnerPreferences;

  /// No description provided for @savePreferences.
  ///
  /// In en, this message translates to:
  /// **'Save Preferences'**
  String get savePreferences;

  /// No description provided for @preferencesSaved.
  ///
  /// In en, this message translates to:
  /// **'Preferences saved successfully!'**
  String get preferencesSaved;

  /// No description provided for @preferredAge.
  ///
  /// In en, this message translates to:
  /// **'Preferred Age'**
  String get preferredAge;

  /// No description provided for @preferredHeight.
  ///
  /// In en, this message translates to:
  /// **'Preferred Height'**
  String get preferredHeight;

  /// No description provided for @preferredMaritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Preferred Marital Status'**
  String get preferredMaritalStatus;

  /// No description provided for @preferredReligion.
  ///
  /// In en, this message translates to:
  /// **'Preferred Religion'**
  String get preferredReligion;

  /// No description provided for @preferredCaste.
  ///
  /// In en, this message translates to:
  /// **'Preferred Caste'**
  String get preferredCaste;

  /// No description provided for @preferredMotherTongue.
  ///
  /// In en, this message translates to:
  /// **'Preferred Mother Tongue'**
  String get preferredMotherTongue;

  /// No description provided for @preferredEducation.
  ///
  /// In en, this message translates to:
  /// **'Preferred Education'**
  String get preferredEducation;

  /// No description provided for @preferredProfession.
  ///
  /// In en, this message translates to:
  /// **'Preferred Profession'**
  String get preferredProfession;

  /// No description provided for @preferredIncome.
  ///
  /// In en, this message translates to:
  /// **'Preferred Income'**
  String get preferredIncome;

  /// No description provided for @preferredLocation.
  ///
  /// In en, this message translates to:
  /// **'Preferred Location'**
  String get preferredLocation;

  /// No description provided for @preferredDiet.
  ///
  /// In en, this message translates to:
  /// **'Preferred Diet'**
  String get preferredDiet;

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
  /// **'Complete your profile to get 3x more responses'**
  String get completeYourProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @familyDetails.
  ///
  /// In en, this message translates to:
  /// **'Family Details'**
  String get familyDetails;

  /// No description provided for @educationCareer.
  ///
  /// In en, this message translates to:
  /// **'Education & Career'**
  String get educationCareer;

  /// No description provided for @locationDetails.
  ///
  /// In en, this message translates to:
  /// **'Location Details'**
  String get locationDetails;

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get contactDetails;

  /// No description provided for @photosAndHoroscope.
  ///
  /// In en, this message translates to:
  /// **'Photos & Horoscope'**
  String get photosAndHoroscope;

  /// No description provided for @managePhotos.
  ///
  /// In en, this message translates to:
  /// **'Manage Photos'**
  String get managePhotos;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

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

  /// No description provided for @languageScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language for the app'**
  String get languageScreenSubtitle;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notificationPreferences;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// No description provided for @blockedProfiles.
  ///
  /// In en, this message translates to:
  /// **'Blocked Profiles'**
  String get blockedProfiles;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @testimonials.
  ///
  /// In en, this message translates to:
  /// **'Success Stories'**
  String get testimonials;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirm;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @weddingServices.
  ///
  /// In en, this message translates to:
  /// **'Wedding Services'**
  String get weddingServices;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @upcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Matrimony Events'**
  String get upcomingEvents;

  /// No description provided for @registerForEvent.
  ///
  /// In en, this message translates to:
  /// **'Register for Event'**
  String get registerForEvent;

  /// No description provided for @eventRegistered.
  ///
  /// In en, this message translates to:
  /// **'Successfully registered for event!'**
  String get eventRegistered;

  /// No description provided for @premiumPlans.
  ///
  /// In en, this message translates to:
  /// **'Membership Plans'**
  String get premiumPlans;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremium;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @clearAllNotifications.
  ///
  /// In en, this message translates to:
  /// **'Clear all notifications'**
  String get clearAllNotifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @optMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get optMale;

  /// No description provided for @optFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get optFemale;

  /// No description provided for @optOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get optOther;

  /// No description provided for @optNeverMarried.
  ///
  /// In en, this message translates to:
  /// **'Never Married'**
  String get optNeverMarried;

  /// No description provided for @optDivorced.
  ///
  /// In en, this message translates to:
  /// **'Divorced'**
  String get optDivorced;

  /// No description provided for @optWidowed.
  ///
  /// In en, this message translates to:
  /// **'Widowed'**
  String get optWidowed;

  /// No description provided for @optAwaitingDivorce.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Divorce'**
  String get optAwaitingDivorce;

  /// No description provided for @optVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get optVegetarian;

  /// No description provided for @optNonVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Non-Vegetarian'**
  String get optNonVegetarian;

  /// No description provided for @optEggetarian.
  ///
  /// In en, this message translates to:
  /// **'Eggetarian'**
  String get optEggetarian;

  /// No description provided for @optVegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get optVegan;

  /// No description provided for @optJain.
  ///
  /// In en, this message translates to:
  /// **'Jain'**
  String get optJain;

  /// No description provided for @optNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get optNormal;

  /// No description provided for @optPhysicallyChallenged.
  ///
  /// In en, this message translates to:
  /// **'Physically Challenged'**
  String get optPhysicallyChallenged;

  /// No description provided for @optVisuallyImpaired.
  ///
  /// In en, this message translates to:
  /// **'Visually Impaired'**
  String get optVisuallyImpaired;

  /// No description provided for @optHearingImpaired.
  ///
  /// In en, this message translates to:
  /// **'Hearing Impaired'**
  String get optHearingImpaired;

  /// No description provided for @optJoint.
  ///
  /// In en, this message translates to:
  /// **'Joint'**
  String get optJoint;

  /// No description provided for @optNuclear.
  ///
  /// In en, this message translates to:
  /// **'Nuclear'**
  String get optNuclear;

  /// No description provided for @optYourself.
  ///
  /// In en, this message translates to:
  /// **'Yourself'**
  String get optYourself;

  /// No description provided for @optSon.
  ///
  /// In en, this message translates to:
  /// **'Son'**
  String get optSon;

  /// No description provided for @optDaughter.
  ///
  /// In en, this message translates to:
  /// **'Daughter'**
  String get optDaughter;

  /// No description provided for @optBrother.
  ///
  /// In en, this message translates to:
  /// **'Brother'**
  String get optBrother;

  /// No description provided for @optSister.
  ///
  /// In en, this message translates to:
  /// **'Sister'**
  String get optSister;

  /// No description provided for @optFriend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get optFriend;

  /// No description provided for @optRelative.
  ///
  /// In en, this message translates to:
  /// **'Relative'**
  String get optRelative;

  /// No description provided for @optHindu.
  ///
  /// In en, this message translates to:
  /// **'Hindu'**
  String get optHindu;

  /// No description provided for @optMuslim.
  ///
  /// In en, this message translates to:
  /// **'Muslim'**
  String get optMuslim;

  /// No description provided for @optChristian.
  ///
  /// In en, this message translates to:
  /// **'Christian'**
  String get optChristian;

  /// No description provided for @optSikh.
  ///
  /// In en, this message translates to:
  /// **'Sikh'**
  String get optSikh;

  /// No description provided for @optBuddhist.
  ///
  /// In en, this message translates to:
  /// **'Buddhist'**
  String get optBuddhist;

  /// No description provided for @optParsi.
  ///
  /// In en, this message translates to:
  /// **'Parsi'**
  String get optParsi;

  /// No description provided for @optJewish.
  ///
  /// In en, this message translates to:
  /// **'Jewish'**
  String get optJewish;

  /// No description provided for @optKunbi.
  ///
  /// In en, this message translates to:
  /// **'Kunbi'**
  String get optKunbi;

  /// No description provided for @optMaratha.
  ///
  /// In en, this message translates to:
  /// **'Maratha'**
  String get optMaratha;

  /// No description provided for @optBrahmin.
  ///
  /// In en, this message translates to:
  /// **'Brahmin'**
  String get optBrahmin;

  /// No description provided for @optVaishya.
  ///
  /// In en, this message translates to:
  /// **'Vaishya'**
  String get optVaishya;

  /// No description provided for @optKshatriya.
  ///
  /// In en, this message translates to:
  /// **'Kshatriya'**
  String get optKshatriya;

  /// No description provided for @optNair.
  ///
  /// In en, this message translates to:
  /// **'Nair'**
  String get optNair;

  /// No description provided for @optEzhava.
  ///
  /// In en, this message translates to:
  /// **'Ezhava'**
  String get optEzhava;

  /// No description provided for @optLingayat.
  ///
  /// In en, this message translates to:
  /// **'Lingayat'**
  String get optLingayat;

  /// No description provided for @optRajput.
  ///
  /// In en, this message translates to:
  /// **'Rajput'**
  String get optRajput;

  /// No description provided for @optSoftwareIT.
  ///
  /// In en, this message translates to:
  /// **'Software / IT Professional'**
  String get optSoftwareIT;

  /// No description provided for @optHardware.
  ///
  /// In en, this message translates to:
  /// **'Hardware / Networking'**
  String get optHardware;

  /// No description provided for @optGovt.
  ///
  /// In en, this message translates to:
  /// **'Government / Civil Services'**
  String get optGovt;

  /// No description provided for @optPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private Sector'**
  String get optPrivate;

  /// No description provided for @optBanking.
  ///
  /// In en, this message translates to:
  /// **'Banking / Finance'**
  String get optBanking;

  /// No description provided for @optDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor / Medical Healthcare'**
  String get optDoctor;

  /// No description provided for @optTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher / Professor'**
  String get optTeacher;

  /// No description provided for @optBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business / Entrepreneur'**
  String get optBusiness;

  /// No description provided for @optEngineer.
  ///
  /// In en, this message translates to:
  /// **'Civil / Mechanical Engineer'**
  String get optEngineer;

  /// No description provided for @optLawyer.
  ///
  /// In en, this message translates to:
  /// **'Lawyer / Legal Professional'**
  String get optLawyer;

  /// No description provided for @optDefence.
  ///
  /// In en, this message translates to:
  /// **'Defence / Police'**
  String get optDefence;

  /// No description provided for @optAgriculture.
  ///
  /// In en, this message translates to:
  /// **'Agriculture / Farming'**
  String get optAgriculture;

  /// No description provided for @optSelfEmployed.
  ///
  /// In en, this message translates to:
  /// **'Self Employed'**
  String get optSelfEmployed;

  /// No description provided for @optNotWorking.
  ///
  /// In en, this message translates to:
  /// **'Not Working'**
  String get optNotWorking;

  /// No description provided for @optNoIncome.
  ///
  /// In en, this message translates to:
  /// **'No Income'**
  String get optNoIncome;

  /// No description provided for @optBelow2Lakh.
  ///
  /// In en, this message translates to:
  /// **'Below 2 Lakh'**
  String get optBelow2Lakh;

  /// No description provided for @opt2To4Lakh.
  ///
  /// In en, this message translates to:
  /// **'2 - 4 Lakh'**
  String get opt2To4Lakh;

  /// No description provided for @opt4To7Lakh.
  ///
  /// In en, this message translates to:
  /// **'4 - 7 Lakh'**
  String get opt4To7Lakh;

  /// No description provided for @opt7To10Lakh.
  ///
  /// In en, this message translates to:
  /// **'7 - 10 Lakh'**
  String get opt7To10Lakh;

  /// No description provided for @opt10To15Lakh.
  ///
  /// In en, this message translates to:
  /// **'10 - 15 Lakh'**
  String get opt10To15Lakh;

  /// No description provided for @opt15To20Lakh.
  ///
  /// In en, this message translates to:
  /// **'15 - 20 Lakh'**
  String get opt15To20Lakh;

  /// No description provided for @opt20To30Lakh.
  ///
  /// In en, this message translates to:
  /// **'20 - 30 Lakh'**
  String get opt20To30Lakh;

  /// No description provided for @opt30To50Lakh.
  ///
  /// In en, this message translates to:
  /// **'30 - 50 Lakh'**
  String get opt30To50Lakh;

  /// No description provided for @opt50LakhTo1Cr.
  ///
  /// In en, this message translates to:
  /// **'50 Lakh - 1 Crore'**
  String get opt50LakhTo1Cr;

  /// No description provided for @optAbove1Cr.
  ///
  /// In en, this message translates to:
  /// **'Above 1 Crore'**
  String get optAbove1Cr;

  /// No description provided for @expressInterest.
  ///
  /// In en, this message translates to:
  /// **'Express Interest'**
  String get expressInterest;

  /// No description provided for @interestSent.
  ///
  /// In en, this message translates to:
  /// **'Interest Sent'**
  String get interestSent;

  /// No description provided for @religiousAndHoroscope.
  ///
  /// In en, this message translates to:
  /// **'Religious & Horoscope'**
  String get religiousAndHoroscope;

  /// No description provided for @lifestyleAndHabits.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle & Habits'**
  String get lifestyleAndHabits;

  /// No description provided for @partnerPriority.
  ///
  /// In en, this message translates to:
  /// **'Partner Priority'**
  String get partnerPriority;

  /// No description provided for @expectedMaritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Expected Marital Status'**
  String get expectedMaritalStatus;

  /// No description provided for @workingPartner.
  ///
  /// In en, this message translates to:
  /// **'Working Partner'**
  String get workingPartner;

  /// No description provided for @preferred.
  ///
  /// In en, this message translates to:
  /// **'Preferred'**
  String get preferred;

  /// No description provided for @noPreference.
  ///
  /// In en, this message translates to:
  /// **'No Preference'**
  String get noPreference;

  /// No description provided for @newNotificationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} new'**
  String newNotificationsCount(int count);

  /// No description provided for @profileActivity.
  ///
  /// In en, this message translates to:
  /// **'Profile Activity'**
  String get profileActivity;

  /// No description provided for @matchAlerts.
  ///
  /// In en, this message translates to:
  /// **'Match Alerts'**
  String get matchAlerts;

  /// No description provided for @interestAlerts.
  ///
  /// In en, this message translates to:
  /// **'Interest Alerts'**
  String get interestAlerts;

  /// No description provided for @otherNotifications.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherNotifications;

  /// No description provided for @noNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'When you receive notifications, they will appear here.'**
  String get noNotificationsDesc;

  /// No description provided for @unableToDeleteNotification.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete notification'**
  String get unableToDeleteNotification;

  /// No description provided for @changeNotificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Change notification settings'**
  String get changeNotificationSettings;

  /// No description provided for @pushNotification.
  ///
  /// In en, this message translates to:
  /// **'Push notification'**
  String get pushNotification;

  /// No description provided for @emailNotification.
  ///
  /// In en, this message translates to:
  /// **'Email notification'**
  String get emailNotification;

  /// No description provided for @whatsappNotification.
  ///
  /// In en, this message translates to:
  /// **'Whatsapp notification'**
  String get whatsappNotification;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @preferencesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Preferences Updated'**
  String get preferencesUpdated;

  /// No description provided for @lastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen'**
  String get lastSeen;

  /// No description provided for @whereHeartsMeet.
  ///
  /// In en, this message translates to:
  /// **'Where Hearts Meet Happily!'**
  String get whereHeartsMeet;

  /// No description provided for @noUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events right now'**
  String get noUpcomingEvents;

  /// No description provided for @noUpcomingEventsDesc.
  ///
  /// In en, this message translates to:
  /// **'Please check back soon for upcoming matchmaking events.'**
  String get noUpcomingEventsDesc;

  /// No description provided for @registerForNextEvent.
  ///
  /// In en, this message translates to:
  /// **'Register for next event'**
  String get registerForNextEvent;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @registerInterest.
  ///
  /// In en, this message translates to:
  /// **'REGISTER INTEREST'**
  String get registerInterest;

  /// No description provided for @soon.
  ///
  /// In en, this message translates to:
  /// **'SOON'**
  String get soon;

  /// No description provided for @registerViaWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Register Interest via WhatsApp'**
  String get registerViaWhatsApp;

  /// No description provided for @eventDetailsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Event details not found'**
  String get eventDetailsNotFound;

  /// No description provided for @photography.
  ///
  /// In en, this message translates to:
  /// **'Photography'**
  String get photography;

  /// No description provided for @photographyDesc.
  ///
  /// In en, this message translates to:
  /// **'Photographers, Cinematographers & Pre-wedding studios'**
  String get photographyDesc;

  /// No description provided for @mehendi.
  ///
  /// In en, this message translates to:
  /// **'Mehendi'**
  String get mehendi;

  /// No description provided for @mehendiDesc.
  ///
  /// In en, this message translates to:
  /// **'Bridal Henna, Arabic & Traditional Mehendi Artists'**
  String get mehendiDesc;

  /// No description provided for @decoration.
  ///
  /// In en, this message translates to:
  /// **'Decoration'**
  String get decoration;

  /// No description provided for @decorationDesc.
  ///
  /// In en, this message translates to:
  /// **'Stage Setup, Mandap Decor, Floral & Theme Lighting'**
  String get decorationDesc;

  /// No description provided for @vendors.
  ///
  /// In en, this message translates to:
  /// **'vendors'**
  String get vendors;

  /// No description provided for @vendorDetailsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Vendor details not found'**
  String get vendorDetailsNotFound;

  /// No description provided for @connectWithVendor.
  ///
  /// In en, this message translates to:
  /// **'Connect with {name}'**
  String connectWithVendor(String name);

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @specializations.
  ///
  /// In en, this message translates to:
  /// **'Specializations'**
  String get specializations;

  /// No description provided for @pricingPackages.
  ///
  /// In en, this message translates to:
  /// **'Pricing packages'**
  String get pricingPackages;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @studio.
  ///
  /// In en, this message translates to:
  /// **'Studio'**
  String get studio;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change the password'**
  String get changePasswordSubtitle;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get enterCurrentPassword;

  /// No description provided for @clickHere.
  ///
  /// In en, this message translates to:
  /// **'Click here'**
  String get clickHere;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqs;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @trySearchingAnother.
  ///
  /// In en, this message translates to:
  /// **'Try searching for another keyword'**
  String get trySearchingAnother;

  /// No description provided for @findMoreAccurateMatch.
  ///
  /// In en, this message translates to:
  /// **'Find more accurate match with premium'**
  String get findMoreAccurateMatch;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'per month'**
  String get perMonth;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @blockedProfilesDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage profiles you have blocked from contacting you'**
  String get blockedProfilesDesc;

  /// No description provided for @noBlockedProfiles.
  ///
  /// In en, this message translates to:
  /// **'No Blocked Profiles'**
  String get noBlockedProfiles;

  /// No description provided for @noBlockedProfilesDesc.
  ///
  /// In en, this message translates to:
  /// **'Profiles you block will appear here.'**
  String get noBlockedProfilesDesc;

  /// No description provided for @unblockedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{name} unblocked successfully'**
  String unblockedSuccess(String name);

  /// No description provided for @failedToUnblock.
  ///
  /// In en, this message translates to:
  /// **'Failed to unblock {name}'**
  String failedToUnblock(String name);

  /// No description provided for @privacySettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Control who can view your personal information'**
  String get privacySettingsDesc;

  /// No description provided for @hidePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Hide Phone Number'**
  String get hidePhoneNumber;

  /// No description provided for @hidePhoneNumberDesc.
  ///
  /// In en, this message translates to:
  /// **'Only accepted matches can see your phone number'**
  String get hidePhoneNumberDesc;

  /// No description provided for @hideEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Hide Email Address'**
  String get hideEmailAddress;

  /// No description provided for @hideEmailAddressDesc.
  ///
  /// In en, this message translates to:
  /// **'Keep your email address private on your profile'**
  String get hideEmailAddressDesc;

  /// No description provided for @hidePhotos.
  ///
  /// In en, this message translates to:
  /// **'Hide Photos'**
  String get hidePhotos;

  /// No description provided for @hidePhotosDesc.
  ///
  /// In en, this message translates to:
  /// **'Only premium or accepted matches can see your photos'**
  String get hidePhotosDesc;

  /// No description provided for @hideAnnualIncome.
  ///
  /// In en, this message translates to:
  /// **'Hide Annual Income'**
  String get hideAnnualIncome;

  /// No description provided for @hideAnnualIncomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Keep your annual income hidden from other users'**
  String get hideAnnualIncomeDesc;

  /// No description provided for @hideLastSeen.
  ///
  /// In en, this message translates to:
  /// **'Hide Last Seen'**
  String get hideLastSeen;

  /// No description provided for @hideLastSeenDesc.
  ///
  /// In en, this message translates to:
  /// **'Do not show your last active timestamp'**
  String get hideLastSeenDesc;

  /// No description provided for @hideOnlineStatus.
  ///
  /// In en, this message translates to:
  /// **'Hide Online Status'**
  String get hideOnlineStatus;

  /// No description provided for @hideOnlineStatusDesc.
  ///
  /// In en, this message translates to:
  /// **'Do not show when you are currently online'**
  String get hideOnlineStatusDesc;

  /// No description provided for @hideProfileCompletely.
  ///
  /// In en, this message translates to:
  /// **'Hide Profile completely'**
  String get hideProfileCompletely;

  /// No description provided for @hideProfileCompletelyDesc.
  ///
  /// In en, this message translates to:
  /// **'Temporarily hide your profile from search results'**
  String get hideProfileCompletelyDesc;

  /// No description provided for @privacySaved.
  ///
  /// In en, this message translates to:
  /// **'Privacy settings saved successfully'**
  String get privacySaved;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @organizer.
  ///
  /// In en, this message translates to:
  /// **'Organizer'**
  String get organizer;
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
