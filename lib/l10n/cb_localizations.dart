import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'cb_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of CbLocale
/// returned by `CbLocale.of(context)`.
///
/// Applications need to include `CbLocale.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/cb_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: CbLocale.localizationsDelegates,
///   supportedLocales: CbLocale.supportedLocales,
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
/// be consistent with the languages listed in the CbLocale.supportedLocales
/// property.
abstract class CbLocale {
  CbLocale(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static CbLocale? of(BuildContext context) {
    return Localizations.of<CbLocale>(context, CbLocale);
  }

  static const LocalizationsDelegate<CbLocale> delegate = _CbLocaleDelegate();

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
    Locale('en')
  ];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Family AI'**
  String get app_name;

  /// No description provided for @sign_in_with_google.
  ///
  /// In en, this message translates to:
  /// **'Sign In with Google'**
  String get sign_in_with_google;

  /// No description provided for @continue_with_email.
  ///
  /// In en, this message translates to:
  /// **'Or continue with email'**
  String get continue_with_email;

  /// No description provided for @email_hint.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get email_hint;

  /// No description provided for @password_hint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password_hint;

  /// No description provided for @confirm_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirm_password_hint;

  /// No description provided for @label_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get label_continue;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get create_account;

  /// No description provided for @dont_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account?'**
  String get dont_have_an_account;

  /// No description provided for @already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get already_have_account;

  /// No description provided for @unexpected_error.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error'**
  String get unexpected_error;

  /// No description provided for @sign_up_with_google.
  ///
  /// In en, this message translates to:
  /// **'Sign Up with Google'**
  String get sign_up_with_google;

  /// No description provided for @first_name_hint_required.
  ///
  /// In en, this message translates to:
  /// **'First name*'**
  String get first_name_hint_required;

  /// No description provided for @last_name_hint_required.
  ///
  /// In en, this message translates to:
  /// **'Secondary name*'**
  String get last_name_hint_required;

  /// No description provided for @email_hint_required.
  ///
  /// In en, this message translates to:
  /// **'Email*'**
  String get email_hint_required;

  /// No description provided for @save_and_continue.
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get save_and_continue;

  /// No description provided for @add_member.
  ///
  /// In en, this message translates to:
  /// **'Add member'**
  String get add_member;

  /// No description provided for @topic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get topic;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @invite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;
}

class _CbLocaleDelegate extends LocalizationsDelegate<CbLocale> {
  const _CbLocaleDelegate();

  @override
  Future<CbLocale> load(Locale locale) {
    return SynchronousFuture<CbLocale>(lookupCbLocale(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_CbLocaleDelegate old) => false;
}

CbLocale lookupCbLocale(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return CbLocaleEn();
  }

  throw FlutterError(
    'CbLocale.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
