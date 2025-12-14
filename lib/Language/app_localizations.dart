import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'Language/app_localizations.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Vehicle App'**
  String get appTitle;

  /// No description provided for @noViolationsFound.
  ///
  /// In en, this message translates to:
  /// **'No violations found'**
  String get noViolationsFound;

  /// No description provided for @selectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Select Start Date'**
  String get selectStartDate;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @requestHold.
  ///
  /// In en, this message translates to:
  /// **'Request Hold'**
  String get requestHold;

  /// No description provided for @holdRequestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Hold request submitted'**
  String get holdRequestSubmitted;

  /// No description provided for @holdRequestUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Hold request is under review'**
  String get holdRequestUnderReview;

  /// No description provided for @holdRequestNotUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Hold request is not under review'**
  String get holdRequestNotUnderReview;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @welcomeHome.
  ///
  /// In en, this message translates to:
  /// **'Smart Vehicle Hold'**
  String get welcomeHome;

  /// No description provided for @label_desc_screen1.
  ///
  /// In en, this message translates to:
  /// **'Secure your vehicle at home instead of traditional impoundment.'**
  String get label_desc_screen1;

  /// No description provided for @label_Skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get label_Skip;

  /// No description provided for @label_title_screen2.
  ///
  /// In en, this message translates to:
  /// **'24/7 Vehicle Monitoring'**
  String get label_title_screen2;

  /// No description provided for @label_desc_screen2.
  ///
  /// In en, this message translates to:
  /// **'Track your vehicle\'s status and location anytime, anywhere.'**
  String get label_desc_screen2;

  /// No description provided for @label_title_screen3.
  ///
  /// In en, this message translates to:
  /// **'Instant Alerts'**
  String get label_title_screen3;

  /// No description provided for @label_desc_screen3.
  ///
  /// In en, this message translates to:
  /// **'Receive immediate notifications if any violation occurs during the hold period.'**
  String get label_desc_screen3;

  /// No description provided for @label_welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get label_welcome_back;

  /// No description provided for @label_Login.
  ///
  /// In en, this message translates to:
  /// **'Please login to continue'**
  String get label_Login;

  /// No description provided for @usernameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your UserName or Email'**
  String get usernameOrEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get password;

  /// No description provided for @button_Login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get button_Login;

  /// No description provided for @label_HaveNotAccout.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account'**
  String get label_HaveNotAccout;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @label_create_account.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get label_create_account;

  /// No description provided for @body_create_account.
  ///
  /// In en, this message translates to:
  /// **'Fill in the details to get started'**
  String get body_create_account;

  /// No description provided for @userName_textFields.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get userName_textFields;

  /// No description provided for @fullName_textFields.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullName_textFields;

  /// No description provided for @email_textFields.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get email_textFields;

  /// No description provided for @nationalId_textFields.
  ///
  /// In en, this message translates to:
  /// **'Enter your national ID'**
  String get nationalId_textFields;

  /// No description provided for @phoneNumber_textFields.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneNumber_textFields;

  /// No description provided for @password_textFields.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get password_textFields;

  /// No description provided for @confirmPassword_textFields.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPassword_textFields;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @header_vehicles.
  ///
  /// In en, this message translates to:
  /// **'My Vehicles'**
  String get header_vehicles;

  /// No description provided for @header_vehicles_Details.
  ///
  /// In en, this message translates to:
  /// **'Vehicles Details'**
  String get header_vehicles_Details;

  /// No description provided for @vehicles_Information.
  ///
  /// In en, this message translates to:
  /// **'Vehicles Information'**
  String get vehicles_Information;

  /// No description provided for @vehicles_Info_Model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get vehicles_Info_Model;

  /// No description provided for @vehicles_Info_PlatNumber.
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get vehicles_Info_PlatNumber;

  /// No description provided for @vehicles_Info_Color.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Color'**
  String get vehicles_Info_Color;

  /// No description provided for @vehicles_Info_RegistrationDate.
  ///
  /// In en, this message translates to:
  /// **'Registration Year'**
  String get vehicles_Info_RegistrationDate;

  /// No description provided for @owner_Information.
  ///
  /// In en, this message translates to:
  /// **'Owner Information'**
  String get owner_Information;

  /// No description provided for @nationalId_Info.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId_Info;

  /// No description provided for @button_check_VehicleHold.
  ///
  /// In en, this message translates to:
  /// **'Check Vehicle Hold'**
  String get button_check_VehicleHold;

  /// No description provided for @view_Violations.
  ///
  /// In en, this message translates to:
  /// **'View Violations'**
  String get view_Violations;

  /// No description provided for @new_ViolationsFound.
  ///
  /// In en, this message translates to:
  /// **'New violations found'**
  String get new_ViolationsFound;

  /// No description provided for @violation_found_message.
  ///
  /// In en, this message translates to:
  /// **'A violation related to you has been found. Would you like to link it to your vehicle?'**
  String get violation_found_message;

  /// No description provided for @reservation_message.
  ///
  /// In en, this message translates to:
  /// **'The car is under reservation.'**
  String get reservation_message;

  /// No description provided for @under_review.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get under_review;

  /// No description provided for @violationDate.
  ///
  /// In en, this message translates to:
  /// **'Violation date'**
  String get violationDate;

  /// No description provided for @holdDuration.
  ///
  /// In en, this message translates to:
  /// **'Hold Duration'**
  String get holdDuration;

  /// No description provided for @timeremaining.
  ///
  /// In en, this message translates to:
  /// **'Time remaining'**
  String get timeremaining;

  /// No description provided for @button_Request_Hold.
  ///
  /// In en, this message translates to:
  /// **'Request Hold'**
  String get button_Request_Hold;

  /// No description provided for @holdRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Hold Request Details'**
  String get holdRequestDetails;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @selectdateAndlocation.
  ///
  /// In en, this message translates to:
  /// **'Please select date and location'**
  String get selectdateAndlocation;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'no'**
  String get no;

  /// No description provided for @vehicleViolations.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Violations'**
  String get vehicleViolations;

  /// No description provided for @otpCode.
  ///
  /// In en, this message translates to:
  /// **'OTP Code'**
  String get otpCode;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @accountVerifiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account verified successfully!'**
  String get accountVerifiedSuccessfully;

  /// No description provided for @receivedOtp.
  ///
  /// In en, this message translates to:
  /// **'Received OTP:'**
  String get receivedOtp;

  /// No description provided for @registered.
  ///
  /// In en, this message translates to:
  /// **'Registered:'**
  String get registered;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color:'**
  String get color;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// No description provided for @logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout failed:'**
  String get logoutFailed;

  /// No description provided for @loadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Loading Profile...'**
  String get loadingProfile;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @profileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get profileNotFound;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @refresh_profile.
  ///
  /// In en, this message translates to:
  /// **'Refresh profile'**
  String get refresh_profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @tryagain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryagain;

  /// No description provided for @profile_not_found.
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get profile_not_found;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @noViolationsMessage.
  ///
  /// In en, this message translates to:
  /// **'No violations'**
  String get noViolationsMessage;

  /// No description provided for @violationFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'Violation found'**
  String get violationFoundMessage;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully'**
  String get settingsSaved;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
