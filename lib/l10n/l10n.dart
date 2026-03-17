import 'package:flutter/widgets.dart';
import 'app_de.dart';
import 'app_en.dart';

class S {
  final Map<String, String> _strings;

  S._(this._strings);

  static S of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return S._(locale.languageCode == 'de' ? de : en);
  }

  static String locale(BuildContext context) {
    final loc = Localizations.localeOf(context);
    return loc.languageCode == 'de' ? 'de_DE' : 'en_US';
  }

  String get welcomeBack => _strings['welcomeBack']!;
  String get createAccount => _strings['createAccount']!;
  String get email => _strings['email']!;
  String get password => _strings['password']!;
  String get confirmPassword => _strings['confirmPassword']!;
  String get login => _strings['login']!;
  String get register => _strings['register']!;
  String get noAccount => _strings['noAccount']!;
  String get hasAccount => _strings['hasAccount']!;
  String get invalidEmail => _strings['invalidEmail']!;
  String get passwordTooShort => _strings['passwordTooShort']!;
  String get passwordsMismatch => _strings['passwordsMismatch']!;
  String get loginError => _strings['loginError']!;
  String get registerError => _strings['registerError']!;

  String get whatDoYouDo => _strings['whatDoYouDo']!;
  String get occupationHint => _strings['occupationHint']!;
  String get whatAreYourHobbies => _strings['whatAreYourHobbies']!;
  String get whenDoYouWork => _strings['whenDoYouWork']!;
  String get workHoursHint => _strings['workHoursHint']!;
  String get whereDoYouLive => _strings['whereDoYouLive']!;
  String get locationHint => _strings['locationHint']!;
  String get skip => _strings['skip']!;
  String get next => _strings['next']!;
  String get done => _strings['done']!;
  String get onboardingError => _strings['onboardingError']!;

  String get today => _strings['today']!;
  String get noEventsToday => _strings['noEventsToday']!;
  String get addFirstTask => _strings['addFirstTask']!;
  String get addTask => _strings['addTask']!;

  String get whatToSchedule => _strings['whatToSchedule']!;
  String get describeTask => _strings['describeTask']!;
  String get taskExamples => _strings['taskExamples']!;
  String get schedule => _strings['schedule']!;
  String get taskAdded => _strings['taskAdded']!;

  String get conflictResolved => _strings['conflictResolved']!;

  String get weekView => _strings['weekView']!;
  String get noEventsOnDay => _strings['noEventsOnDay']!;

  String get importSchedule => _strings['importSchedule']!;
  String get importDescription => _strings['importDescription']!;
  String get takePhoto => _strings['takePhoto']!;
  String get fromGallery => _strings['fromGallery']!;
  String get importNow => _strings['importNow']!;
  String get importSuccess => _strings['importSuccess']!;
  String get aiAnalyzing => _strings['aiAnalyzing']!;

  String get suggestions => _strings['suggestions']!;
  String get scheduleSuggestion => _strings['scheduleSuggestion']!;
  String get dismiss => _strings['dismiss']!;
  String get noSuggestions => _strings['noSuggestions']!;
  String get noSuggestionsHint => _strings['noSuggestionsHint']!;

  String get profile => _strings['profile']!;
  String get occupation => _strings['occupation']!;
  String get workHours => _strings['workHours']!;
  String get location => _strings['location']!;
  String get logout => _strings['logout']!;
}
