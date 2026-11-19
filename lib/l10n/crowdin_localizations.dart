// ignore_for_file: unused_import, use_super_parameters
import 'dart:convert';

import 'app_localizations.dart';

import 'package:crowdin_sdk/crowdin_sdk.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class CrowdinLocalization extends AppLocalizations {
  final AppLocalizations _fallbackTexts;
  
  CrowdinLocalization(String locale, AppLocalizations fallbackTexts) : _fallbackTexts = fallbackTexts, super(locale);

  static const LocalizationsDelegate<AppLocalizations> delegate = _CrowdinLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <
      LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = AppLocalizations.supportedLocales;
 
	@override
  String get appTitle => Crowdin.getText(localeName, 'appTitle') ?? _fallbackTexts.appTitle;

	@override
  String get home => Crowdin.getText(localeName, 'home') ?? _fallbackTexts.home;

	@override
  String get likes => Crowdin.getText(localeName, 'likes') ?? _fallbackTexts.likes;

	@override
  String get messages => Crowdin.getText(localeName, 'messages') ?? _fallbackTexts.messages;

	@override
  String get profile => Crowdin.getText(localeName, 'profile') ?? _fallbackTexts.profile;

	@override
  String get search => Crowdin.getText(localeName, 'search') ?? _fallbackTexts.search;

	@override
  String get searchPlaceholder => Crowdin.getText(localeName, 'searchPlaceholder') ?? _fallbackTexts.searchPlaceholder;

	@override
  String get cancel => Crowdin.getText(localeName, 'cancel') ?? _fallbackTexts.cancel;

	@override
  String get save => Crowdin.getText(localeName, 'save') ?? _fallbackTexts.save;

	@override
  String get edit => Crowdin.getText(localeName, 'edit') ?? _fallbackTexts.edit;

	@override
  String get delete => Crowdin.getText(localeName, 'delete') ?? _fallbackTexts.delete;

	@override
  String get submit => Crowdin.getText(localeName, 'submit') ?? _fallbackTexts.submit;

	@override
  String get next => Crowdin.getText(localeName, 'next') ?? _fallbackTexts.next;

	@override
  String get skip => Crowdin.getText(localeName, 'skip') ?? _fallbackTexts.skip;

	@override
  String get back => Crowdin.getText(localeName, 'back') ?? _fallbackTexts.back;

	@override
  String get done => Crowdin.getText(localeName, 'done') ?? _fallbackTexts.done;

	@override
  String get confirm => Crowdin.getText(localeName, 'confirm') ?? _fallbackTexts.confirm;

	@override
  String get yes => Crowdin.getText(localeName, 'yes') ?? _fallbackTexts.yes;

	@override
  String get no => Crowdin.getText(localeName, 'no') ?? _fallbackTexts.no;

	@override
  String get apply => Crowdin.getText(localeName, 'apply') ?? _fallbackTexts.apply;

	@override
  String get clearAll => Crowdin.getText(localeName, 'clearAll') ?? _fallbackTexts.clearAll;

	@override
  String get applyFilters => Crowdin.getText(localeName, 'applyFilters') ?? _fallbackTexts.applyFilters;

	@override
  String get filters => Crowdin.getText(localeName, 'filters') ?? _fallbackTexts.filters;

	@override
  String get retry => Crowdin.getText(localeName, 'retry') ?? _fallbackTexts.retry;

	@override
  String get exitAppTitle => Crowdin.getText(localeName, 'exitAppTitle') ?? _fallbackTexts.exitAppTitle;

	@override
  String get exitAppConfirm => Crowdin.getText(localeName, 'exitAppConfirm') ?? _fallbackTexts.exitAppConfirm;

	@override
  String get exit => Crowdin.getText(localeName, 'exit') ?? _fallbackTexts.exit;

	@override
  String get loading => Crowdin.getText(localeName, 'loading') ?? _fallbackTexts.loading;

	@override
  String get error => Crowdin.getText(localeName, 'error') ?? _fallbackTexts.error;

	@override
  String get success => Crowdin.getText(localeName, 'success') ?? _fallbackTexts.success;

	@override
  String get noInternetConnection => Crowdin.getText(localeName, 'noInternetConnection') ?? _fallbackTexts.noInternetConnection;

	@override
  String get onboardingTitle1 => Crowdin.getText(localeName, 'onboardingTitle1') ?? _fallbackTexts.onboardingTitle1;

	@override
  String get onboardingDesc1 => Crowdin.getText(localeName, 'onboardingDesc1') ?? _fallbackTexts.onboardingDesc1;

	@override
  String get onboardingTitle2 => Crowdin.getText(localeName, 'onboardingTitle2') ?? _fallbackTexts.onboardingTitle2;

	@override
  String get onboardingDesc2 => Crowdin.getText(localeName, 'onboardingDesc2') ?? _fallbackTexts.onboardingDesc2;

	@override
  String get onboardingTitle3 => Crowdin.getText(localeName, 'onboardingTitle3') ?? _fallbackTexts.onboardingTitle3;

	@override
  String get onboardingDesc3 => Crowdin.getText(localeName, 'onboardingDesc3') ?? _fallbackTexts.onboardingDesc3;

	@override
  String get login => Crowdin.getText(localeName, 'login') ?? _fallbackTexts.login;

	@override
  String get emailAddress => Crowdin.getText(localeName, 'emailAddress') ?? _fallbackTexts.emailAddress;

	@override
  String get enterEmailAddress => Crowdin.getText(localeName, 'enterEmailAddress') ?? _fallbackTexts.enterEmailAddress;

	@override
  String get pleaseEnterEmail => Crowdin.getText(localeName, 'pleaseEnterEmail') ?? _fallbackTexts.pleaseEnterEmail;

	@override
  String get emailMustContainAt => Crowdin.getText(localeName, 'emailMustContainAt') ?? _fallbackTexts.emailMustContainAt;

	@override
  String get validEmailEndingCom => Crowdin.getText(localeName, 'validEmailEndingCom') ?? _fallbackTexts.validEmailEndingCom;

	@override
  String get password => Crowdin.getText(localeName, 'password') ?? _fallbackTexts.password;

	@override
  String get enterPassword => Crowdin.getText(localeName, 'enterPassword') ?? _fallbackTexts.enterPassword;

	@override
  String get pleaseEnterPassword => Crowdin.getText(localeName, 'pleaseEnterPassword') ?? _fallbackTexts.pleaseEnterPassword;

	@override
  String get passwordMin8 => Crowdin.getText(localeName, 'passwordMin8') ?? _fallbackTexts.passwordMin8;

	@override
  String get passwordUppercase => Crowdin.getText(localeName, 'passwordUppercase') ?? _fallbackTexts.passwordUppercase;

	@override
  String get passwordLowercase => Crowdin.getText(localeName, 'passwordLowercase') ?? _fallbackTexts.passwordLowercase;

	@override
  String get forgotPasswordQuestion => Crowdin.getText(localeName, 'forgotPasswordQuestion') ?? _fallbackTexts.forgotPasswordQuestion;

	@override
  String get byContinuingAgree => Crowdin.getText(localeName, 'byContinuingAgree') ?? _fallbackTexts.byContinuingAgree;

	@override
  String get termsAndConditions => Crowdin.getText(localeName, 'termsAndConditions') ?? _fallbackTexts.termsAndConditions;

	@override
  String get andWord => Crowdin.getText(localeName, 'andWord') ?? _fallbackTexts.andWord;

	@override
  String get privacyPolicy => Crowdin.getText(localeName, 'privacyPolicy') ?? _fallbackTexts.privacyPolicy;

	@override
  String get dontHaveAccount => Crowdin.getText(localeName, 'dontHaveAccount') ?? _fallbackTexts.dontHaveAccount;

	@override
  String get register => Crowdin.getText(localeName, 'register') ?? _fallbackTexts.register;

	@override
  String get alreadyHaveAccount => Crowdin.getText(localeName, 'alreadyHaveAccount') ?? _fallbackTexts.alreadyHaveAccount;

	@override
  String get forgotYourPassword => Crowdin.getText(localeName, 'forgotYourPassword') ?? _fallbackTexts.forgotYourPassword;

	@override
  String get pleaseEnterEmailOrPhone => Crowdin.getText(localeName, 'pleaseEnterEmailOrPhone') ?? _fallbackTexts.pleaseEnterEmailOrPhone;

	@override
  String get byPhoneNumber => Crowdin.getText(localeName, 'byPhoneNumber') ?? _fallbackTexts.byPhoneNumber;

	@override
  String get byEmail => Crowdin.getText(localeName, 'byEmail') ?? _fallbackTexts.byEmail;

	@override
  String get phoneNumber => Crowdin.getText(localeName, 'phoneNumber') ?? _fallbackTexts.phoneNumber;

	@override
  String get enterPhoneNumber => Crowdin.getText(localeName, 'enterPhoneNumber') ?? _fallbackTexts.enterPhoneNumber;

	@override
  String get email => Crowdin.getText(localeName, 'email') ?? _fallbackTexts.email;

	@override
  String get enterEmail => Crowdin.getText(localeName, 'enterEmail') ?? _fallbackTexts.enterEmail;

	@override
  String get sendCode => Crowdin.getText(localeName, 'sendCode') ?? _fallbackTexts.sendCode;

	@override
  String get otpVerification => Crowdin.getText(localeName, 'otpVerification') ?? _fallbackTexts.otpVerification;

	@override
  String get verificationCodeSentTo => Crowdin.getText(localeName, 'verificationCodeSentTo') ?? _fallbackTexts.verificationCodeSentTo;

	@override
  String get enterCode => Crowdin.getText(localeName, 'enterCode') ?? _fallbackTexts.enterCode;

	@override
  String get enterOtp => Crowdin.getText(localeName, 'enterOtp') ?? _fallbackTexts.enterOtp;

	@override
  String get resendCodeIn => Crowdin.getText(localeName, 'resendCodeIn') ?? _fallbackTexts.resendCodeIn;

	@override
  String get seconds => Crowdin.getText(localeName, 'seconds') ?? _fallbackTexts.seconds;

	@override
  String get resendCode => Crowdin.getText(localeName, 'resendCode') ?? _fallbackTexts.resendCode;

	@override
  String get resendOtp => Crowdin.getText(localeName, 'resendOtp') ?? _fallbackTexts.resendOtp;

	@override
  String get didntReceiveCode => Crowdin.getText(localeName, 'didntReceiveCode') ?? _fallbackTexts.didntReceiveCode;

	@override
  String get invalidOtpMessage => Crowdin.getText(localeName, 'invalidOtpMessage') ?? _fallbackTexts.invalidOtpMessage;

	@override
  String get otpSentSuccessfully => Crowdin.getText(localeName, 'otpSentSuccessfully') ?? _fallbackTexts.otpSentSuccessfully;

	@override
  String get otpResentSuccessfully => Crowdin.getText(localeName, 'otpResentSuccessfully') ?? _fallbackTexts.otpResentSuccessfully;

	@override
  String get pleaseEnterAllDigits => Crowdin.getText(localeName, 'pleaseEnterAllDigits') ?? _fallbackTexts.pleaseEnterAllDigits;

	@override
  String get createNewPassword => Crowdin.getText(localeName, 'createNewPassword') ?? _fallbackTexts.createNewPassword;

	@override
  String get updatePasswordSubtitle => Crowdin.getText(localeName, 'updatePasswordSubtitle') ?? _fallbackTexts.updatePasswordSubtitle;

	@override
  String get confirmNewPassword => Crowdin.getText(localeName, 'confirmNewPassword') ?? _fallbackTexts.confirmNewPassword;

	@override
  String get applyChanges => Crowdin.getText(localeName, 'applyChanges') ?? _fallbackTexts.applyChanges;

	@override
  String get atLeastOneUppercase => Crowdin.getText(localeName, 'atLeastOneUppercase') ?? _fallbackTexts.atLeastOneUppercase;

	@override
  String get atLeastOneLowercase => Crowdin.getText(localeName, 'atLeastOneLowercase') ?? _fallbackTexts.atLeastOneLowercase;

	@override
  String get atLeast8Characters => Crowdin.getText(localeName, 'atLeast8Characters') ?? _fallbackTexts.atLeast8Characters;

	@override
  String get atLeastOneNumber => Crowdin.getText(localeName, 'atLeastOneNumber') ?? _fallbackTexts.atLeastOneNumber;

	@override
  String get atLeastOneSpecialChar => Crowdin.getText(localeName, 'atLeastOneSpecialChar') ?? _fallbackTexts.atLeastOneSpecialChar;

	@override
  String get weakPassword => Crowdin.getText(localeName, 'weakPassword') ?? _fallbackTexts.weakPassword;

	@override
  String get mediumPassword => Crowdin.getText(localeName, 'mediumPassword') ?? _fallbackTexts.mediumPassword;

	@override
  String get strongPassword => Crowdin.getText(localeName, 'strongPassword') ?? _fallbackTexts.strongPassword;

	@override
  String get passwordUpdatedSuccessfully => Crowdin.getText(localeName, 'passwordUpdatedSuccessfully') ?? _fallbackTexts.passwordUpdatedSuccessfully;

	@override
  String get logIn => Crowdin.getText(localeName, 'logIn') ?? _fallbackTexts.logIn;

	@override
  String get registration => Crowdin.getText(localeName, 'registration') ?? _fallbackTexts.registration;

	@override
  String get step1Title => Crowdin.getText(localeName, 'step1Title') ?? _fallbackTexts.step1Title;

	@override
  String get step2Title => Crowdin.getText(localeName, 'step2Title') ?? _fallbackTexts.step2Title;

	@override
  String get step3Title => Crowdin.getText(localeName, 'step3Title') ?? _fallbackTexts.step3Title;

	@override
  String get step4Title => Crowdin.getText(localeName, 'step4Title') ?? _fallbackTexts.step4Title;

	@override
  String get step5Title => Crowdin.getText(localeName, 'step5Title') ?? _fallbackTexts.step5Title;

	@override
  String get reviewRegistration => Crowdin.getText(localeName, 'reviewRegistration') ?? _fallbackTexts.reviewRegistration;

	@override
  String get fullName => Crowdin.getText(localeName, 'fullName') ?? _fallbackTexts.fullName;

	@override
  String get enterFullName => Crowdin.getText(localeName, 'enterFullName') ?? _fallbackTexts.enterFullName;

	@override
  String get profileCreatedFor => Crowdin.getText(localeName, 'profileCreatedFor') ?? _fallbackTexts.profileCreatedFor;

	@override
  String get selectProfileCreatedFor => Crowdin.getText(localeName, 'selectProfileCreatedFor') ?? _fallbackTexts.selectProfileCreatedFor;

	@override
  String get dateOfBirth => Crowdin.getText(localeName, 'dateOfBirth') ?? _fallbackTexts.dateOfBirth;

	@override
  String get selectDateOfBirth => Crowdin.getText(localeName, 'selectDateOfBirth') ?? _fallbackTexts.selectDateOfBirth;

	@override
  String get day => Crowdin.getText(localeName, 'day') ?? _fallbackTexts.day;

	@override
  String get month => Crowdin.getText(localeName, 'month') ?? _fallbackTexts.month;

	@override
  String get year => Crowdin.getText(localeName, 'year') ?? _fallbackTexts.year;

	@override
  String get gender => Crowdin.getText(localeName, 'gender') ?? _fallbackTexts.gender;

	@override
  String get selectGender => Crowdin.getText(localeName, 'selectGender') ?? _fallbackTexts.selectGender;

	@override
  String get maritalStatus => Crowdin.getText(localeName, 'maritalStatus') ?? _fallbackTexts.maritalStatus;

	@override
  String get selectMaritalStatus => Crowdin.getText(localeName, 'selectMaritalStatus') ?? _fallbackTexts.selectMaritalStatus;

	@override
  String get height => Crowdin.getText(localeName, 'height') ?? _fallbackTexts.height;

	@override
  String get selectHeight => Crowdin.getText(localeName, 'selectHeight') ?? _fallbackTexts.selectHeight;

	@override
  String get weight => Crowdin.getText(localeName, 'weight') ?? _fallbackTexts.weight;

	@override
  String get enterWeight => Crowdin.getText(localeName, 'enterWeight') ?? _fallbackTexts.enterWeight;

	@override
  String get diet => Crowdin.getText(localeName, 'diet') ?? _fallbackTexts.diet;

	@override
  String get selectDiet => Crowdin.getText(localeName, 'selectDiet') ?? _fallbackTexts.selectDiet;

	@override
  String get bloodGroup => Crowdin.getText(localeName, 'bloodGroup') ?? _fallbackTexts.bloodGroup;

	@override
  String get selectBloodGroup => Crowdin.getText(localeName, 'selectBloodGroup') ?? _fallbackTexts.selectBloodGroup;

	@override
  String get physicalStatus => Crowdin.getText(localeName, 'physicalStatus') ?? _fallbackTexts.physicalStatus;

	@override
  String get selectPhysicalStatus => Crowdin.getText(localeName, 'selectPhysicalStatus') ?? _fallbackTexts.selectPhysicalStatus;

	@override
  String get motherTongue => Crowdin.getText(localeName, 'motherTongue') ?? _fallbackTexts.motherTongue;

	@override
  String get selectMotherTongue => Crowdin.getText(localeName, 'selectMotherTongue') ?? _fallbackTexts.selectMotherTongue;

	@override
  String get highestEducation => Crowdin.getText(localeName, 'highestEducation') ?? _fallbackTexts.highestEducation;

	@override
  String get selectHighestEducation => Crowdin.getText(localeName, 'selectHighestEducation') ?? _fallbackTexts.selectHighestEducation;

	@override
  String get employedIn => Crowdin.getText(localeName, 'employedIn') ?? _fallbackTexts.employedIn;

	@override
  String get selectEmployedIn => Crowdin.getText(localeName, 'selectEmployedIn') ?? _fallbackTexts.selectEmployedIn;

	@override
  String get occupation => Crowdin.getText(localeName, 'occupation') ?? _fallbackTexts.occupation;

	@override
  String get enterOccupation => Crowdin.getText(localeName, 'enterOccupation') ?? _fallbackTexts.enterOccupation;

	@override
  String get companyName => Crowdin.getText(localeName, 'companyName') ?? _fallbackTexts.companyName;

	@override
  String get enterCompanyName => Crowdin.getText(localeName, 'enterCompanyName') ?? _fallbackTexts.enterCompanyName;

	@override
  String get annualIncome => Crowdin.getText(localeName, 'annualIncome') ?? _fallbackTexts.annualIncome;

	@override
  String get selectAnnualIncome => Crowdin.getText(localeName, 'selectAnnualIncome') ?? _fallbackTexts.selectAnnualIncome;

	@override
  String get jobLocation => Crowdin.getText(localeName, 'jobLocation') ?? _fallbackTexts.jobLocation;

	@override
  String get enterJobLocation => Crowdin.getText(localeName, 'enterJobLocation') ?? _fallbackTexts.enterJobLocation;

	@override
  String get country => Crowdin.getText(localeName, 'country') ?? _fallbackTexts.country;

	@override
  String get state => Crowdin.getText(localeName, 'state') ?? _fallbackTexts.state;

	@override
  String get selectState => Crowdin.getText(localeName, 'selectState') ?? _fallbackTexts.selectState;

	@override
  String get city => Crowdin.getText(localeName, 'city') ?? _fallbackTexts.city;

	@override
  String get enterCity => Crowdin.getText(localeName, 'enterCity') ?? _fallbackTexts.enterCity;

	@override
  String get religion => Crowdin.getText(localeName, 'religion') ?? _fallbackTexts.religion;

	@override
  String get selectReligion => Crowdin.getText(localeName, 'selectReligion') ?? _fallbackTexts.selectReligion;

	@override
  String get caste => Crowdin.getText(localeName, 'caste') ?? _fallbackTexts.caste;

	@override
  String get selectCaste => Crowdin.getText(localeName, 'selectCaste') ?? _fallbackTexts.selectCaste;

	@override
  String get subCaste => Crowdin.getText(localeName, 'subCaste') ?? _fallbackTexts.subCaste;

	@override
  String get enterSubCaste => Crowdin.getText(localeName, 'enterSubCaste') ?? _fallbackTexts.enterSubCaste;

	@override
  String get gothram => Crowdin.getText(localeName, 'gothram') ?? _fallbackTexts.gothram;

	@override
  String get enterGothram => Crowdin.getText(localeName, 'enterGothram') ?? _fallbackTexts.enterGothram;

	@override
  String get fatherStatus => Crowdin.getText(localeName, 'fatherStatus') ?? _fallbackTexts.fatherStatus;

	@override
  String get enterFatherStatus => Crowdin.getText(localeName, 'enterFatherStatus') ?? _fallbackTexts.enterFatherStatus;

	@override
  String get motherStatus => Crowdin.getText(localeName, 'motherStatus') ?? _fallbackTexts.motherStatus;

	@override
  String get enterMotherStatus => Crowdin.getText(localeName, 'enterMotherStatus') ?? _fallbackTexts.enterMotherStatus;

	@override
  String get numberOfBrothers => Crowdin.getText(localeName, 'numberOfBrothers') ?? _fallbackTexts.numberOfBrothers;

	@override
  String get numberOfSisters => Crowdin.getText(localeName, 'numberOfSisters') ?? _fallbackTexts.numberOfSisters;

	@override
  String get familyType => Crowdin.getText(localeName, 'familyType') ?? _fallbackTexts.familyType;

	@override
  String get selectFamilyType => Crowdin.getText(localeName, 'selectFamilyType') ?? _fallbackTexts.selectFamilyType;

	@override
  String get familyValues => Crowdin.getText(localeName, 'familyValues') ?? _fallbackTexts.familyValues;

	@override
  String get familyStatus => Crowdin.getText(localeName, 'familyStatus') ?? _fallbackTexts.familyStatus;

	@override
  String get maternalUncles => Crowdin.getText(localeName, 'maternalUncles') ?? _fallbackTexts.maternalUncles;

	@override
  String get paternalUncles => Crowdin.getText(localeName, 'paternalUncles') ?? _fallbackTexts.paternalUncles;

	@override
  String get addUncle => Crowdin.getText(localeName, 'addUncle') ?? _fallbackTexts.addUncle;

	@override
  String get uncleName => Crowdin.getText(localeName, 'uncleName') ?? _fallbackTexts.uncleName;

	@override
  String get enterUncleName => Crowdin.getText(localeName, 'enterUncleName') ?? _fallbackTexts.enterUncleName;

	@override
  String get uncleOccupation => Crowdin.getText(localeName, 'uncleOccupation') ?? _fallbackTexts.uncleOccupation;

	@override
  String get enterUncleOccupation => Crowdin.getText(localeName, 'enterUncleOccupation') ?? _fallbackTexts.enterUncleOccupation;

	@override
  String get uncleCity => Crowdin.getText(localeName, 'uncleCity') ?? _fallbackTexts.uncleCity;

	@override
  String get enterUncleCity => Crowdin.getText(localeName, 'enterUncleCity') ?? _fallbackTexts.enterUncleCity;

	@override
  String get idProofType => Crowdin.getText(localeName, 'idProofType') ?? _fallbackTexts.idProofType;

	@override
  String get selectIdProofType => Crowdin.getText(localeName, 'selectIdProofType') ?? _fallbackTexts.selectIdProofType;

	@override
  String get idProofNumber => Crowdin.getText(localeName, 'idProofNumber') ?? _fallbackTexts.idProofNumber;

	@override
  String get enterIdProofNumber => Crowdin.getText(localeName, 'enterIdProofNumber') ?? _fallbackTexts.enterIdProofNumber;

	@override
  String get uploadPhotos => Crowdin.getText(localeName, 'uploadPhotos') ?? _fallbackTexts.uploadPhotos;

	@override
  String get uploadPhotosDesc => Crowdin.getText(localeName, 'uploadPhotosDesc') ?? _fallbackTexts.uploadPhotosDesc;

	@override
  String get addPhoto => Crowdin.getText(localeName, 'addPhoto') ?? _fallbackTexts.addPhoto;

	@override
  String get uploadHoroscope => Crowdin.getText(localeName, 'uploadHoroscope') ?? _fallbackTexts.uploadHoroscope;

	@override
  String get aboutMe => Crowdin.getText(localeName, 'aboutMe') ?? _fallbackTexts.aboutMe;

	@override
  String get enterAboutMe => Crowdin.getText(localeName, 'enterAboutMe') ?? _fallbackTexts.enterAboutMe;

	@override
  String get pleaseAgreeTerms => Crowdin.getText(localeName, 'pleaseAgreeTerms') ?? _fallbackTexts.pleaseAgreeTerms;

	@override
  String get finalSubmit => Crowdin.getText(localeName, 'finalSubmit') ?? _fallbackTexts.finalSubmit;

	@override
  String get registrationSuccess => Crowdin.getText(localeName, 'registrationSuccess') ?? _fallbackTexts.registrationSuccess;

	@override
  String get pleaseFillRequiredFields => Crowdin.getText(localeName, 'pleaseFillRequiredFields') ?? _fallbackTexts.pleaseFillRequiredFields;

	@override
  String get welcomeBack => Crowdin.getText(localeName, 'welcomeBack') ?? _fallbackTexts.welcomeBack;

	@override
  String get matchmakingEvents => Crowdin.getText(localeName, 'matchmakingEvents') ?? _fallbackTexts.matchmakingEvents;

	@override
  String get viewAllEvents => Crowdin.getText(localeName, 'viewAllEvents') ?? _fallbackTexts.viewAllEvents;

	@override
  String get profileViews => Crowdin.getText(localeName, 'profileViews') ?? _fallbackTexts.profileViews;

	@override
  String get whoViewedYourProfile => Crowdin.getText(localeName, 'whoViewedYourProfile') ?? _fallbackTexts.whoViewedYourProfile;

	@override
  String get nearMe => Crowdin.getText(localeName, 'nearMe') ?? _fallbackTexts.nearMe;

	@override
  String get newMatches => Crowdin.getText(localeName, 'newMatches') ?? _fallbackTexts.newMatches;

	@override
  String get recommendations => Crowdin.getText(localeName, 'recommendations') ?? _fallbackTexts.recommendations;

	@override
  String get dailyRecommendations => Crowdin.getText(localeName, 'dailyRecommendations') ?? _fallbackTexts.dailyRecommendations;

	@override
  String get noProfilesFound => Crowdin.getText(localeName, 'noProfilesFound') ?? _fallbackTexts.noProfilesFound;

	@override
  String get tryAdjustingFilters => Crowdin.getText(localeName, 'tryAdjustingFilters') ?? _fallbackTexts.tryAdjustingFilters;

	@override
  String get clearFilters => Crowdin.getText(localeName, 'clearFilters') ?? _fallbackTexts.clearFilters;

	@override
  String get connectNow => Crowdin.getText(localeName, 'connectNow') ?? _fallbackTexts.connectNow;

	@override
  String get connected => Crowdin.getText(localeName, 'connected') ?? _fallbackTexts.connected;

	@override
  String get viewProfile => Crowdin.getText(localeName, 'viewProfile') ?? _fallbackTexts.viewProfile;

	@override
  String get compatibility => Crowdin.getText(localeName, 'compatibility') ?? _fallbackTexts.compatibility;

	@override
  String get favorites => Crowdin.getText(localeName, 'favorites') ?? _fallbackTexts.favorites;

	@override
  String get favoritesTitle => Crowdin.getText(localeName, 'favoritesTitle') ?? _fallbackTexts.favoritesTitle;

	@override
  String get searchFavorites => Crowdin.getText(localeName, 'searchFavorites') ?? _fallbackTexts.searchFavorites;

	@override
  String get noFavoritesYet => Crowdin.getText(localeName, 'noFavoritesYet') ?? _fallbackTexts.noFavoritesYet;

	@override
  String get noFavoritesDesc => Crowdin.getText(localeName, 'noFavoritesDesc') ?? _fallbackTexts.noFavoritesDesc;

	@override
  String get removeFavorite => Crowdin.getText(localeName, 'removeFavorite') ?? _fallbackTexts.removeFavorite;

	@override
  String get removeFavoriteConfirm => Crowdin.getText(localeName, 'removeFavoriteConfirm') ?? _fallbackTexts.removeFavoriteConfirm;

	@override
  String get remove => Crowdin.getText(localeName, 'remove') ?? _fallbackTexts.remove;

	@override
  String get chats => Crowdin.getText(localeName, 'chats') ?? _fallbackTexts.chats;

	@override
  String get searchChats => Crowdin.getText(localeName, 'searchChats') ?? _fallbackTexts.searchChats;

	@override
  String get noMessagesYet => Crowdin.getText(localeName, 'noMessagesYet') ?? _fallbackTexts.noMessagesYet;

	@override
  String get noMessagesDesc => Crowdin.getText(localeName, 'noMessagesDesc') ?? _fallbackTexts.noMessagesDesc;

	@override
  String get typeAMessage => Crowdin.getText(localeName, 'typeAMessage') ?? _fallbackTexts.typeAMessage;

	@override
  String get send => Crowdin.getText(localeName, 'send') ?? _fallbackTexts.send;

	@override
  String get online => Crowdin.getText(localeName, 'online') ?? _fallbackTexts.online;

	@override
  String get offline => Crowdin.getText(localeName, 'offline') ?? _fallbackTexts.offline;

	@override
  String get blockUser => Crowdin.getText(localeName, 'blockUser') ?? _fallbackTexts.blockUser;

	@override
  String get unblockUser => Crowdin.getText(localeName, 'unblockUser') ?? _fallbackTexts.unblockUser;

	@override
  String get reportUser => Crowdin.getText(localeName, 'reportUser') ?? _fallbackTexts.reportUser;

	@override
  String get filterBy => Crowdin.getText(localeName, 'filterBy') ?? _fallbackTexts.filterBy;

	@override
  String get ageRange => Crowdin.getText(localeName, 'ageRange') ?? _fallbackTexts.ageRange;

	@override
  String get heightRange => Crowdin.getText(localeName, 'heightRange') ?? _fallbackTexts.heightRange;

	@override
  String get selectMaritalStatusFilter => Crowdin.getText(localeName, 'selectMaritalStatusFilter') ?? _fallbackTexts.selectMaritalStatusFilter;

	@override
  String get selectReligionFilter => Crowdin.getText(localeName, 'selectReligionFilter') ?? _fallbackTexts.selectReligionFilter;

	@override
  String get selectCasteFilter => Crowdin.getText(localeName, 'selectCasteFilter') ?? _fallbackTexts.selectCasteFilter;

	@override
  String get selectMotherTongueFilter => Crowdin.getText(localeName, 'selectMotherTongueFilter') ?? _fallbackTexts.selectMotherTongueFilter;

	@override
  String get selectEducationFilter => Crowdin.getText(localeName, 'selectEducationFilter') ?? _fallbackTexts.selectEducationFilter;

	@override
  String get selectProfessionFilter => Crowdin.getText(localeName, 'selectProfessionFilter') ?? _fallbackTexts.selectProfessionFilter;

	@override
  String get selectIncomeFilter => Crowdin.getText(localeName, 'selectIncomeFilter') ?? _fallbackTexts.selectIncomeFilter;

	@override
  String get selectLocationFilter => Crowdin.getText(localeName, 'selectLocationFilter') ?? _fallbackTexts.selectLocationFilter;

	@override
  String get selectDietFilter => Crowdin.getText(localeName, 'selectDietFilter') ?? _fallbackTexts.selectDietFilter;

	@override
  String get selectFamilyTypeFilter => Crowdin.getText(localeName, 'selectFamilyTypeFilter') ?? _fallbackTexts.selectFamilyTypeFilter;

	@override
  String get all => Crowdin.getText(localeName, 'all') ?? _fallbackTexts.all;

	@override
  String get any => Crowdin.getText(localeName, 'any') ?? _fallbackTexts.any;

	@override
  String get partnerPreferences => Crowdin.getText(localeName, 'partnerPreferences') ?? _fallbackTexts.partnerPreferences;

	@override
  String get savePreferences => Crowdin.getText(localeName, 'savePreferences') ?? _fallbackTexts.savePreferences;

	@override
  String get preferencesSaved => Crowdin.getText(localeName, 'preferencesSaved') ?? _fallbackTexts.preferencesSaved;

	@override
  String get preferredAge => Crowdin.getText(localeName, 'preferredAge') ?? _fallbackTexts.preferredAge;

	@override
  String get preferredHeight => Crowdin.getText(localeName, 'preferredHeight') ?? _fallbackTexts.preferredHeight;

	@override
  String get preferredMaritalStatus => Crowdin.getText(localeName, 'preferredMaritalStatus') ?? _fallbackTexts.preferredMaritalStatus;

	@override
  String get preferredReligion => Crowdin.getText(localeName, 'preferredReligion') ?? _fallbackTexts.preferredReligion;

	@override
  String get preferredCaste => Crowdin.getText(localeName, 'preferredCaste') ?? _fallbackTexts.preferredCaste;

	@override
  String get preferredMotherTongue => Crowdin.getText(localeName, 'preferredMotherTongue') ?? _fallbackTexts.preferredMotherTongue;

	@override
  String get preferredEducation => Crowdin.getText(localeName, 'preferredEducation') ?? _fallbackTexts.preferredEducation;

	@override
  String get preferredProfession => Crowdin.getText(localeName, 'preferredProfession') ?? _fallbackTexts.preferredProfession;

	@override
  String get preferredIncome => Crowdin.getText(localeName, 'preferredIncome') ?? _fallbackTexts.preferredIncome;

	@override
  String get preferredLocation => Crowdin.getText(localeName, 'preferredLocation') ?? _fallbackTexts.preferredLocation;

	@override
  String get preferredDiet => Crowdin.getText(localeName, 'preferredDiet') ?? _fallbackTexts.preferredDiet;

	@override
  String get myProfile => Crowdin.getText(localeName, 'myProfile') ?? _fallbackTexts.myProfile;

	@override
  String get profileCompletion => Crowdin.getText(localeName, 'profileCompletion') ?? _fallbackTexts.profileCompletion;

	@override
  String get completeYourProfile => Crowdin.getText(localeName, 'completeYourProfile') ?? _fallbackTexts.completeYourProfile;

	@override
  String get editProfile => Crowdin.getText(localeName, 'editProfile') ?? _fallbackTexts.editProfile;

	@override
  String get personalDetails => Crowdin.getText(localeName, 'personalDetails') ?? _fallbackTexts.personalDetails;

	@override
  String get familyDetails => Crowdin.getText(localeName, 'familyDetails') ?? _fallbackTexts.familyDetails;

	@override
  String get educationCareer => Crowdin.getText(localeName, 'educationCareer') ?? _fallbackTexts.educationCareer;

	@override
  String get locationDetails => Crowdin.getText(localeName, 'locationDetails') ?? _fallbackTexts.locationDetails;

	@override
  String get contactDetails => Crowdin.getText(localeName, 'contactDetails') ?? _fallbackTexts.contactDetails;

	@override
  String get photosAndHoroscope => Crowdin.getText(localeName, 'photosAndHoroscope') ?? _fallbackTexts.photosAndHoroscope;

	@override
  String get managePhotos => Crowdin.getText(localeName, 'managePhotos') ?? _fallbackTexts.managePhotos;

	@override
  String get settings => Crowdin.getText(localeName, 'settings') ?? _fallbackTexts.settings;

	@override
  String get language => Crowdin.getText(localeName, 'language') ?? _fallbackTexts.language;

	@override
  String get selectLanguage => Crowdin.getText(localeName, 'selectLanguage') ?? _fallbackTexts.selectLanguage;

	@override
  String get english => Crowdin.getText(localeName, 'english') ?? _fallbackTexts.english;

	@override
  String get marathi => Crowdin.getText(localeName, 'marathi') ?? _fallbackTexts.marathi;

	@override
  String get languageScreenSubtitle => Crowdin.getText(localeName, 'languageScreenSubtitle') ?? _fallbackTexts.languageScreenSubtitle;

	@override
  String get notifications => Crowdin.getText(localeName, 'notifications') ?? _fallbackTexts.notifications;

	@override
  String get notificationPreferences => Crowdin.getText(localeName, 'notificationPreferences') ?? _fallbackTexts.notificationPreferences;

	@override
  String get privacySettings => Crowdin.getText(localeName, 'privacySettings') ?? _fallbackTexts.privacySettings;

	@override
  String get blockedProfiles => Crowdin.getText(localeName, 'blockedProfiles') ?? _fallbackTexts.blockedProfiles;

	@override
  String get changePassword => Crowdin.getText(localeName, 'changePassword') ?? _fallbackTexts.changePassword;

	@override
  String get helpAndSupport => Crowdin.getText(localeName, 'helpAndSupport') ?? _fallbackTexts.helpAndSupport;

	@override
  String get termsOfService => Crowdin.getText(localeName, 'termsOfService') ?? _fallbackTexts.termsOfService;

	@override
  String get testimonials => Crowdin.getText(localeName, 'testimonials') ?? _fallbackTexts.testimonials;

	@override
  String get logout => Crowdin.getText(localeName, 'logout') ?? _fallbackTexts.logout;

	@override
  String get logoutConfirm => Crowdin.getText(localeName, 'logoutConfirm') ?? _fallbackTexts.logoutConfirm;

	@override
  String get deleteAccount => Crowdin.getText(localeName, 'deleteAccount') ?? _fallbackTexts.deleteAccount;

	@override
  String get services => Crowdin.getText(localeName, 'services') ?? _fallbackTexts.services;

	@override
  String get weddingServices => Crowdin.getText(localeName, 'weddingServices') ?? _fallbackTexts.weddingServices;

	@override
  String get events => Crowdin.getText(localeName, 'events') ?? _fallbackTexts.events;

	@override
  String get upcomingEvents => Crowdin.getText(localeName, 'upcomingEvents') ?? _fallbackTexts.upcomingEvents;

	@override
  String get registerForEvent => Crowdin.getText(localeName, 'registerForEvent') ?? _fallbackTexts.registerForEvent;

	@override
  String get eventRegistered => Crowdin.getText(localeName, 'eventRegistered') ?? _fallbackTexts.eventRegistered;

	@override
  String get premiumPlans => Crowdin.getText(localeName, 'premiumPlans') ?? _fallbackTexts.premiumPlans;

	@override
  String get upgradeToPremium => Crowdin.getText(localeName, 'upgradeToPremium') ?? _fallbackTexts.upgradeToPremium;

	@override
  String get markAllAsRead => Crowdin.getText(localeName, 'markAllAsRead') ?? _fallbackTexts.markAllAsRead;

	@override
  String get clearAllNotifications => Crowdin.getText(localeName, 'clearAllNotifications') ?? _fallbackTexts.clearAllNotifications;

	@override
  String get noNotifications => Crowdin.getText(localeName, 'noNotifications') ?? _fallbackTexts.noNotifications;

	@override
  String get optMale => Crowdin.getText(localeName, 'optMale') ?? _fallbackTexts.optMale;

	@override
  String get optFemale => Crowdin.getText(localeName, 'optFemale') ?? _fallbackTexts.optFemale;

	@override
  String get optOther => Crowdin.getText(localeName, 'optOther') ?? _fallbackTexts.optOther;

	@override
  String get optNeverMarried => Crowdin.getText(localeName, 'optNeverMarried') ?? _fallbackTexts.optNeverMarried;

	@override
  String get optDivorced => Crowdin.getText(localeName, 'optDivorced') ?? _fallbackTexts.optDivorced;

	@override
  String get optWidowed => Crowdin.getText(localeName, 'optWidowed') ?? _fallbackTexts.optWidowed;

	@override
  String get optAwaitingDivorce => Crowdin.getText(localeName, 'optAwaitingDivorce') ?? _fallbackTexts.optAwaitingDivorce;

	@override
  String get optVegetarian => Crowdin.getText(localeName, 'optVegetarian') ?? _fallbackTexts.optVegetarian;

	@override
  String get optNonVegetarian => Crowdin.getText(localeName, 'optNonVegetarian') ?? _fallbackTexts.optNonVegetarian;

	@override
  String get optEggetarian => Crowdin.getText(localeName, 'optEggetarian') ?? _fallbackTexts.optEggetarian;

	@override
  String get optVegan => Crowdin.getText(localeName, 'optVegan') ?? _fallbackTexts.optVegan;

	@override
  String get optJain => Crowdin.getText(localeName, 'optJain') ?? _fallbackTexts.optJain;

	@override
  String get optNormal => Crowdin.getText(localeName, 'optNormal') ?? _fallbackTexts.optNormal;

	@override
  String get optPhysicallyChallenged => Crowdin.getText(localeName, 'optPhysicallyChallenged') ?? _fallbackTexts.optPhysicallyChallenged;

	@override
  String get optVisuallyImpaired => Crowdin.getText(localeName, 'optVisuallyImpaired') ?? _fallbackTexts.optVisuallyImpaired;

	@override
  String get optHearingImpaired => Crowdin.getText(localeName, 'optHearingImpaired') ?? _fallbackTexts.optHearingImpaired;

	@override
  String get optJoint => Crowdin.getText(localeName, 'optJoint') ?? _fallbackTexts.optJoint;

	@override
  String get optNuclear => Crowdin.getText(localeName, 'optNuclear') ?? _fallbackTexts.optNuclear;

	@override
  String get optYourself => Crowdin.getText(localeName, 'optYourself') ?? _fallbackTexts.optYourself;

	@override
  String get optSon => Crowdin.getText(localeName, 'optSon') ?? _fallbackTexts.optSon;

	@override
  String get optDaughter => Crowdin.getText(localeName, 'optDaughter') ?? _fallbackTexts.optDaughter;

	@override
  String get optBrother => Crowdin.getText(localeName, 'optBrother') ?? _fallbackTexts.optBrother;

	@override
  String get optSister => Crowdin.getText(localeName, 'optSister') ?? _fallbackTexts.optSister;

	@override
  String get optFriend => Crowdin.getText(localeName, 'optFriend') ?? _fallbackTexts.optFriend;

	@override
  String get optRelative => Crowdin.getText(localeName, 'optRelative') ?? _fallbackTexts.optRelative;

	@override
  String get optHindu => Crowdin.getText(localeName, 'optHindu') ?? _fallbackTexts.optHindu;

	@override
  String get optMuslim => Crowdin.getText(localeName, 'optMuslim') ?? _fallbackTexts.optMuslim;

	@override
  String get optChristian => Crowdin.getText(localeName, 'optChristian') ?? _fallbackTexts.optChristian;

	@override
  String get optSikh => Crowdin.getText(localeName, 'optSikh') ?? _fallbackTexts.optSikh;

	@override
  String get optBuddhist => Crowdin.getText(localeName, 'optBuddhist') ?? _fallbackTexts.optBuddhist;

	@override
  String get optParsi => Crowdin.getText(localeName, 'optParsi') ?? _fallbackTexts.optParsi;

	@override
  String get optJewish => Crowdin.getText(localeName, 'optJewish') ?? _fallbackTexts.optJewish;

	@override
  String get optKunbi => Crowdin.getText(localeName, 'optKunbi') ?? _fallbackTexts.optKunbi;

	@override
  String get optMaratha => Crowdin.getText(localeName, 'optMaratha') ?? _fallbackTexts.optMaratha;

	@override
  String get optBrahmin => Crowdin.getText(localeName, 'optBrahmin') ?? _fallbackTexts.optBrahmin;

	@override
  String get optVaishya => Crowdin.getText(localeName, 'optVaishya') ?? _fallbackTexts.optVaishya;

	@override
  String get optKshatriya => Crowdin.getText(localeName, 'optKshatriya') ?? _fallbackTexts.optKshatriya;

	@override
  String get optNair => Crowdin.getText(localeName, 'optNair') ?? _fallbackTexts.optNair;

	@override
  String get optEzhava => Crowdin.getText(localeName, 'optEzhava') ?? _fallbackTexts.optEzhava;

	@override
  String get optLingayat => Crowdin.getText(localeName, 'optLingayat') ?? _fallbackTexts.optLingayat;

	@override
  String get optRajput => Crowdin.getText(localeName, 'optRajput') ?? _fallbackTexts.optRajput;

	@override
  String get optSoftwareIT => Crowdin.getText(localeName, 'optSoftwareIT') ?? _fallbackTexts.optSoftwareIT;

	@override
  String get optHardware => Crowdin.getText(localeName, 'optHardware') ?? _fallbackTexts.optHardware;

	@override
  String get optGovt => Crowdin.getText(localeName, 'optGovt') ?? _fallbackTexts.optGovt;

	@override
  String get optPrivate => Crowdin.getText(localeName, 'optPrivate') ?? _fallbackTexts.optPrivate;

	@override
  String get optBanking => Crowdin.getText(localeName, 'optBanking') ?? _fallbackTexts.optBanking;

	@override
  String get optDoctor => Crowdin.getText(localeName, 'optDoctor') ?? _fallbackTexts.optDoctor;

	@override
  String get optTeacher => Crowdin.getText(localeName, 'optTeacher') ?? _fallbackTexts.optTeacher;

	@override
  String get optBusiness => Crowdin.getText(localeName, 'optBusiness') ?? _fallbackTexts.optBusiness;

	@override
  String get optEngineer => Crowdin.getText(localeName, 'optEngineer') ?? _fallbackTexts.optEngineer;

	@override
  String get optLawyer => Crowdin.getText(localeName, 'optLawyer') ?? _fallbackTexts.optLawyer;

	@override
  String get optDefence => Crowdin.getText(localeName, 'optDefence') ?? _fallbackTexts.optDefence;

	@override
  String get optAgriculture => Crowdin.getText(localeName, 'optAgriculture') ?? _fallbackTexts.optAgriculture;

	@override
  String get optSelfEmployed => Crowdin.getText(localeName, 'optSelfEmployed') ?? _fallbackTexts.optSelfEmployed;

	@override
  String get optNotWorking => Crowdin.getText(localeName, 'optNotWorking') ?? _fallbackTexts.optNotWorking;

	@override
  String get optNoIncome => Crowdin.getText(localeName, 'optNoIncome') ?? _fallbackTexts.optNoIncome;

	@override
  String get optBelow2Lakh => Crowdin.getText(localeName, 'optBelow2Lakh') ?? _fallbackTexts.optBelow2Lakh;

	@override
  String get opt2To4Lakh => Crowdin.getText(localeName, 'opt2To4Lakh') ?? _fallbackTexts.opt2To4Lakh;

	@override
  String get opt4To7Lakh => Crowdin.getText(localeName, 'opt4To7Lakh') ?? _fallbackTexts.opt4To7Lakh;

	@override
  String get opt7To10Lakh => Crowdin.getText(localeName, 'opt7To10Lakh') ?? _fallbackTexts.opt7To10Lakh;

	@override
  String get opt10To15Lakh => Crowdin.getText(localeName, 'opt10To15Lakh') ?? _fallbackTexts.opt10To15Lakh;

	@override
  String get opt15To20Lakh => Crowdin.getText(localeName, 'opt15To20Lakh') ?? _fallbackTexts.opt15To20Lakh;

	@override
  String get opt20To30Lakh => Crowdin.getText(localeName, 'opt20To30Lakh') ?? _fallbackTexts.opt20To30Lakh;

	@override
  String get opt30To50Lakh => Crowdin.getText(localeName, 'opt30To50Lakh') ?? _fallbackTexts.opt30To50Lakh;

	@override
  String get opt50LakhTo1Cr => Crowdin.getText(localeName, 'opt50LakhTo1Cr') ?? _fallbackTexts.opt50LakhTo1Cr;

	@override
  String get optAbove1Cr => Crowdin.getText(localeName, 'optAbove1Cr') ?? _fallbackTexts.optAbove1Cr;

	@override
  String get expressInterest => Crowdin.getText(localeName, 'expressInterest') ?? _fallbackTexts.expressInterest;

	@override
  String get interestSent => Crowdin.getText(localeName, 'interestSent') ?? _fallbackTexts.interestSent;

	@override
  String get religiousAndHoroscope => Crowdin.getText(localeName, 'religiousAndHoroscope') ?? _fallbackTexts.religiousAndHoroscope;

	@override
  String get lifestyleAndHabits => Crowdin.getText(localeName, 'lifestyleAndHabits') ?? _fallbackTexts.lifestyleAndHabits;

	@override
  String get partnerPriority => Crowdin.getText(localeName, 'partnerPriority') ?? _fallbackTexts.partnerPriority;

	@override
  String get expectedMaritalStatus => Crowdin.getText(localeName, 'expectedMaritalStatus') ?? _fallbackTexts.expectedMaritalStatus;

	@override
  String get workingPartner => Crowdin.getText(localeName, 'workingPartner') ?? _fallbackTexts.workingPartner;

	@override
  String get preferred => Crowdin.getText(localeName, 'preferred') ?? _fallbackTexts.preferred;

	@override
  String get noPreference => Crowdin.getText(localeName, 'noPreference') ?? _fallbackTexts.noPreference;

	@override
	String newNotificationsCount(int count) => Crowdin.getText(localeName, 'newNotificationsCount', {'count':count}) ?? _fallbackTexts.newNotificationsCount(count);

	@override
  String get profileActivity => Crowdin.getText(localeName, 'profileActivity') ?? _fallbackTexts.profileActivity;

	@override
  String get matchAlerts => Crowdin.getText(localeName, 'matchAlerts') ?? _fallbackTexts.matchAlerts;

	@override
  String get interestAlerts => Crowdin.getText(localeName, 'interestAlerts') ?? _fallbackTexts.interestAlerts;

	@override
  String get otherNotifications => Crowdin.getText(localeName, 'otherNotifications') ?? _fallbackTexts.otherNotifications;

	@override
  String get noNotificationsDesc => Crowdin.getText(localeName, 'noNotificationsDesc') ?? _fallbackTexts.noNotificationsDesc;

	@override
  String get unableToDeleteNotification => Crowdin.getText(localeName, 'unableToDeleteNotification') ?? _fallbackTexts.unableToDeleteNotification;

	@override
  String get changeNotificationSettings => Crowdin.getText(localeName, 'changeNotificationSettings') ?? _fallbackTexts.changeNotificationSettings;

	@override
  String get pushNotification => Crowdin.getText(localeName, 'pushNotification') ?? _fallbackTexts.pushNotification;

	@override
  String get emailNotification => Crowdin.getText(localeName, 'emailNotification') ?? _fallbackTexts.emailNotification;

	@override
  String get whatsappNotification => Crowdin.getText(localeName, 'whatsappNotification') ?? _fallbackTexts.whatsappNotification;

	@override
  String get saveChanges => Crowdin.getText(localeName, 'saveChanges') ?? _fallbackTexts.saveChanges;

	@override
  String get preferencesUpdated => Crowdin.getText(localeName, 'preferencesUpdated') ?? _fallbackTexts.preferencesUpdated;

	@override
  String get lastSeen => Crowdin.getText(localeName, 'lastSeen') ?? _fallbackTexts.lastSeen;

	@override
  String get whereHeartsMeet => Crowdin.getText(localeName, 'whereHeartsMeet') ?? _fallbackTexts.whereHeartsMeet;

	@override
  String get noUpcomingEvents => Crowdin.getText(localeName, 'noUpcomingEvents') ?? _fallbackTexts.noUpcomingEvents;

	@override
  String get noUpcomingEventsDesc => Crowdin.getText(localeName, 'noUpcomingEventsDesc') ?? _fallbackTexts.noUpcomingEventsDesc;

	@override
  String get registerForNextEvent => Crowdin.getText(localeName, 'registerForNextEvent') ?? _fallbackTexts.registerForNextEvent;

	@override
  String get contactUs => Crowdin.getText(localeName, 'contactUs') ?? _fallbackTexts.contactUs;

	@override
  String get registerInterest => Crowdin.getText(localeName, 'registerInterest') ?? _fallbackTexts.registerInterest;

	@override
  String get soon => Crowdin.getText(localeName, 'soon') ?? _fallbackTexts.soon;

	@override
  String get registerViaWhatsApp => Crowdin.getText(localeName, 'registerViaWhatsApp') ?? _fallbackTexts.registerViaWhatsApp;

	@override
  String get eventDetailsNotFound => Crowdin.getText(localeName, 'eventDetailsNotFound') ?? _fallbackTexts.eventDetailsNotFound;

	@override
  String get photography => Crowdin.getText(localeName, 'photography') ?? _fallbackTexts.photography;

	@override
  String get photographyDesc => Crowdin.getText(localeName, 'photographyDesc') ?? _fallbackTexts.photographyDesc;

	@override
  String get mehendi => Crowdin.getText(localeName, 'mehendi') ?? _fallbackTexts.mehendi;

	@override
  String get mehendiDesc => Crowdin.getText(localeName, 'mehendiDesc') ?? _fallbackTexts.mehendiDesc;

	@override
  String get decoration => Crowdin.getText(localeName, 'decoration') ?? _fallbackTexts.decoration;

	@override
  String get decorationDesc => Crowdin.getText(localeName, 'decorationDesc') ?? _fallbackTexts.decorationDesc;

	@override
  String get vendors => Crowdin.getText(localeName, 'vendors') ?? _fallbackTexts.vendors;

	@override
  String get vendorDetailsNotFound => Crowdin.getText(localeName, 'vendorDetailsNotFound') ?? _fallbackTexts.vendorDetailsNotFound;

	@override
	String connectWithVendor(String name) => Crowdin.getText(localeName, 'connectWithVendor', {'name':name}) ?? _fallbackTexts.connectWithVendor(name);

	@override
  String get reviews => Crowdin.getText(localeName, 'reviews') ?? _fallbackTexts.reviews;

	@override
  String get specializations => Crowdin.getText(localeName, 'specializations') ?? _fallbackTexts.specializations;

	@override
  String get pricingPackages => Crowdin.getText(localeName, 'pricingPackages') ?? _fallbackTexts.pricingPackages;

	@override
  String get projects => Crowdin.getText(localeName, 'projects') ?? _fallbackTexts.projects;

	@override
  String get studio => Crowdin.getText(localeName, 'studio') ?? _fallbackTexts.studio;

	@override
  String get phone => Crowdin.getText(localeName, 'phone') ?? _fallbackTexts.phone;

	@override
  String get changePasswordSubtitle => Crowdin.getText(localeName, 'changePasswordSubtitle') ?? _fallbackTexts.changePasswordSubtitle;

	@override
  String get currentPassword => Crowdin.getText(localeName, 'currentPassword') ?? _fallbackTexts.currentPassword;

	@override
  String get enterCurrentPassword => Crowdin.getText(localeName, 'enterCurrentPassword') ?? _fallbackTexts.enterCurrentPassword;

	@override
  String get clickHere => Crowdin.getText(localeName, 'clickHere') ?? _fallbackTexts.clickHere;

	@override
  String get faqs => Crowdin.getText(localeName, 'faqs') ?? _fallbackTexts.faqs;

	@override
  String get reset => Crowdin.getText(localeName, 'reset') ?? _fallbackTexts.reset;

	@override
  String get noResultsFound => Crowdin.getText(localeName, 'noResultsFound') ?? _fallbackTexts.noResultsFound;

	@override
  String get trySearchingAnother => Crowdin.getText(localeName, 'trySearchingAnother') ?? _fallbackTexts.trySearchingAnother;

	@override
  String get findMoreAccurateMatch => Crowdin.getText(localeName, 'findMoreAccurateMatch') ?? _fallbackTexts.findMoreAccurateMatch;

	@override
  String get perMonth => Crowdin.getText(localeName, 'perMonth') ?? _fallbackTexts.perMonth;

	@override
  String get continueButton => Crowdin.getText(localeName, 'continueButton') ?? _fallbackTexts.continueButton;

	@override
  String get blockedProfilesDesc => Crowdin.getText(localeName, 'blockedProfilesDesc') ?? _fallbackTexts.blockedProfilesDesc;

	@override
  String get noBlockedProfiles => Crowdin.getText(localeName, 'noBlockedProfiles') ?? _fallbackTexts.noBlockedProfiles;

	@override
  String get noBlockedProfilesDesc => Crowdin.getText(localeName, 'noBlockedProfilesDesc') ?? _fallbackTexts.noBlockedProfilesDesc;

	@override
	String unblockedSuccess(String name) => Crowdin.getText(localeName, 'unblockedSuccess', {'name':name}) ?? _fallbackTexts.unblockedSuccess(name);

	@override
	String failedToUnblock(String name) => Crowdin.getText(localeName, 'failedToUnblock', {'name':name}) ?? _fallbackTexts.failedToUnblock(name);

	@override
  String get privacySettingsDesc => Crowdin.getText(localeName, 'privacySettingsDesc') ?? _fallbackTexts.privacySettingsDesc;

	@override
  String get hidePhoneNumber => Crowdin.getText(localeName, 'hidePhoneNumber') ?? _fallbackTexts.hidePhoneNumber;

	@override
  String get hidePhoneNumberDesc => Crowdin.getText(localeName, 'hidePhoneNumberDesc') ?? _fallbackTexts.hidePhoneNumberDesc;

	@override
  String get hideEmailAddress => Crowdin.getText(localeName, 'hideEmailAddress') ?? _fallbackTexts.hideEmailAddress;

	@override
  String get hideEmailAddressDesc => Crowdin.getText(localeName, 'hideEmailAddressDesc') ?? _fallbackTexts.hideEmailAddressDesc;

	@override
  String get hidePhotos => Crowdin.getText(localeName, 'hidePhotos') ?? _fallbackTexts.hidePhotos;

	@override
  String get hidePhotosDesc => Crowdin.getText(localeName, 'hidePhotosDesc') ?? _fallbackTexts.hidePhotosDesc;

	@override
  String get hideAnnualIncome => Crowdin.getText(localeName, 'hideAnnualIncome') ?? _fallbackTexts.hideAnnualIncome;

	@override
  String get hideAnnualIncomeDesc => Crowdin.getText(localeName, 'hideAnnualIncomeDesc') ?? _fallbackTexts.hideAnnualIncomeDesc;

	@override
  String get hideLastSeen => Crowdin.getText(localeName, 'hideLastSeen') ?? _fallbackTexts.hideLastSeen;

	@override
  String get hideLastSeenDesc => Crowdin.getText(localeName, 'hideLastSeenDesc') ?? _fallbackTexts.hideLastSeenDesc;

	@override
  String get hideOnlineStatus => Crowdin.getText(localeName, 'hideOnlineStatus') ?? _fallbackTexts.hideOnlineStatus;

	@override
  String get hideOnlineStatusDesc => Crowdin.getText(localeName, 'hideOnlineStatusDesc') ?? _fallbackTexts.hideOnlineStatusDesc;

	@override
  String get hideProfileCompletely => Crowdin.getText(localeName, 'hideProfileCompletely') ?? _fallbackTexts.hideProfileCompletely;

	@override
  String get hideProfileCompletelyDesc => Crowdin.getText(localeName, 'hideProfileCompletelyDesc') ?? _fallbackTexts.hideProfileCompletelyDesc;

	@override
  String get privacySaved => Crowdin.getText(localeName, 'privacySaved') ?? _fallbackTexts.privacySaved;

	@override
  String get date => Crowdin.getText(localeName, 'date') ?? _fallbackTexts.date;

	@override
  String get location => Crowdin.getText(localeName, 'location') ?? _fallbackTexts.location;

	@override
  String get time => Crowdin.getText(localeName, 'time') ?? _fallbackTexts.time;

	@override
  String get organizer => Crowdin.getText(localeName, 'organizer') ?? _fallbackTexts.organizer;

}

class _CrowdinLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _CrowdinLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) =>
      AppLocalizations.delegate.load(locale)
          .then((fallback) => CrowdinLocalization(locale.toString(), fallback));

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.contains(locale);

  @override
  bool shouldReload(_CrowdinLocalizationsDelegate old) => false;
}
