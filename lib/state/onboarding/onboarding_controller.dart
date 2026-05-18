import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../services/analytics/analytics_service.dart';

enum OpposeLanguage { english, indonesia }

enum UsernameAvailability { empty, invalid, checking, available, unavailable }

class OnboardingController extends ChangeNotifier {
  OnboardingController({required this.analytics});

  final AnalyticsService analytics;

  Timer? _usernameDebounce;

  OpposeLanguage language = OpposeLanguage.english;
  String emailOrPhone = '';
  String password = '';
  String displayName = '';
  String username = '';
  bool passwordVisible = false;
  bool signUpSubmitted = false;
  bool usernameSubmitted = false;
  bool isSigningUp = false;
  bool isSavingUsername = false;
  bool aiConsentAccepted = false;
  UsernameAvailability usernameAvailability = UsernameAvailability.empty;
  final Set<String> selectedInterests = {'Technology', 'Friendship'};

  bool get isEnglish => language == OpposeLanguage.english;

  bool get isEmailOrPhoneValid {
    final value = emailOrPhone.trim();
    if (value.isEmpty) return false;
    if (value.contains('@')) {
      return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    }
    return RegExp(r'^[+\d][\d\s-]{6,}$').hasMatch(value);
  }

  bool get isPasswordValid => password.length >= 8;

  bool get canSubmitSignUp =>
      isEmailOrPhoneValid && isPasswordValid && !isSigningUp;

  bool get isDisplayNameValid => displayName.trim().length >= 2;

  bool get canContinueProfile =>
      isDisplayNameValid &&
      usernameAvailability == UsernameAvailability.available &&
      !isSavingUsername;

  String? get emailError {
    if (!signUpSubmitted || isEmailOrPhoneValid) return null;
    if (emailOrPhone.trim().isEmpty) return 'Enter your email or phone.';
    return 'Use a valid email or phone number.';
  }

  String? get passwordError {
    if (!signUpSubmitted || isPasswordValid) return null;
    if (password.isEmpty) return 'Enter a password.';
    return 'Use at least 8 characters.';
  }

  String? get displayNameError {
    if (!usernameSubmitted || isDisplayNameValid) return null;
    return 'Use at least 2 characters.';
  }

  void startSignUp() {
    unawaited(analytics.track('signup_started', {'source': 'welcome'}));
  }

  void setLanguage(OpposeLanguage value) {
    language = value;
    notifyListeners();
  }

  void setEmailOrPhone(String value) {
    emailOrPhone = value;
    if (signUpSubmitted) notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    if (signUpSubmitted) notifyListeners();
  }

  void togglePasswordVisible() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  Future<bool> submitSignUp() async {
    signUpSubmitted = true;
    notifyListeners();
    if (!canSubmitSignUp) return false;

    isSigningUp = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 350));
    isSigningUp = false;
    unawaited(
      analytics.track('signup_completed', {
        'method': emailOrPhone.contains('@') ? 'email' : 'phone',
      }),
    );
    notifyListeners();
    return true;
  }

  void setDisplayName(String value) {
    displayName = value;
    if (usernameSubmitted) notifyListeners();
  }

  void setUsername(String value) {
    username = value.trim().replaceFirst(RegExp(r'^@'), '').toLowerCase();
    _usernameDebounce?.cancel();

    if (username.isEmpty) {
      usernameAvailability = UsernameAvailability.empty;
      notifyListeners();
      return;
    }

    final isValid = RegExp(r'^[a-z0-9_]{3,20}$').hasMatch(username);
    if (!isValid) {
      usernameAvailability = UsernameAvailability.invalid;
      notifyListeners();
      return;
    }

    usernameAvailability = UsernameAvailability.checking;
    notifyListeners();
    _usernameDebounce = Timer(const Duration(milliseconds: 450), () {
      const unavailable = {'admin', 'opppose', 'oppose', 'maya', 'raka'};
      usernameAvailability = unavailable.contains(username)
          ? UsernameAvailability.unavailable
          : UsernameAvailability.available;
      if (usernameAvailability == UsernameAvailability.available) {
        unawaited(
          analytics.track('username_available', {
            'username_length': username.length,
          }),
        );
      }
      notifyListeners();
    });
  }

  Future<bool> submitUsername() async {
    usernameSubmitted = true;
    unawaited(
      analytics.track('username_submitted', {
        'username_length': username.length,
      }),
    );
    notifyListeners();
    if (!canContinueProfile) return false;

    isSavingUsername = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 250));
    isSavingUsername = false;
    unawaited(analytics.track('profile_completed', {'has_avatar': false}));
    notifyListeners();
    return true;
  }

  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
    notifyListeners();
  }

  Future<void> continueInterests({required bool skipped}) async {
    unawaited(
      analytics.track('interests_selected', {
        'count': selectedInterests.length,
        'skipped': skipped,
      }),
    );
  }

  Future<void> viewAIConsent() async {
    await analytics.track('ai_consent_viewed', {'source': 'onboarding'});
  }

  Future<void> acceptAIConsent() async {
    aiConsentAccepted = true;
    notifyListeners();
    await analytics.track('ai_consent_accepted', {'memory_enabled': false});
    await analytics.track('onboarding_completed', {
      'interests_count': selectedInterests.length,
      'language': language.name,
    });
  }

  @override
  void dispose() {
    _usernameDebounce?.cancel();
    super.dispose();
  }
}
