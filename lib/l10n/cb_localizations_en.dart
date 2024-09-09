import 'cb_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class CbLocaleEn extends CbLocale {
  CbLocaleEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'Family AI';

  @override
  String get sign_in_with_google => 'Sign In with Google';

  @override
  String get continue_with_email => 'Or continue with email';

  @override
  String get email_hint => 'Email address';

  @override
  String get password_hint => 'Password';

  @override
  String get confirm_password_hint => 'Confirm password';

  @override
  String get label_continue => 'Continue';

  @override
  String get create_account => 'Create account';

  @override
  String get dont_have_an_account => 'Don’t have an account?';

  @override
  String get already_have_account => 'Already have an account?';

  @override
  String get unexpected_error => 'Unexpected error';

  @override
  String get sign_up_with_google => 'Sign Up with Google';

  @override
  String get first_name_hint_required => 'First name*';

  @override
  String get last_name_hint_required => 'Secondary name*';

  @override
  String get email_hint_required => 'Email*';

  @override
  String get save_and_continue => 'Save and continue';

  @override
  String get add_member => 'Add member';

  @override
  String get topic => 'Topic';

  @override
  String get role => 'Role';

  @override
  String get invite => 'Invite';

  @override
  String get members => 'Members';

  @override
  String get copied => 'Copied';

  @override
  String get member_invited => 'New member invited';
}
