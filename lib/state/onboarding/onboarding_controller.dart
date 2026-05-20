import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../repositories/user/user_repository.dart';
import '../../services/analytics/analytics_service.dart';
import '../../types/domain_models.dart';

enum OpposeLanguage { english, indonesia }

enum UsernameAvailability { empty, invalid, checking, available, unavailable }

class OnboardingController extends ChangeNotifier {
  OnboardingController({
    required this.analytics,
    required this.userRepository,
    this.onCurrentUserChanged,
  });

  final AnalyticsService analytics;
  final UserRepository userRepository;
  final ValueChanged<OpposeUser>? onCurrentUserChanged;

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
  bool isSavingInterests = false;
  bool isSavingAIConsent = false;
  bool aiConsentAccepted = false;
  String? errorMessage;
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
    errorMessage = null;
    if (signUpSubmitted) notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    errorMessage = null;
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
    errorMessage = null;
    if (usernameSubmitted) notifyListeners();
  }

  void setUsername(String value) {
    username = value.trim().replaceFirst(RegExp(r'^@'), '').toLowerCase();
    errorMessage = null;
    _usernameDebounce?.cancel();

    if (username.isEmpty) {
      usernameAvailability = UsernameAvailability.empty;
      notifyListeners();
      return;
    }

    final isValid = RegExp(r'^[a-z0-9_]{3,24}$').hasMatch(username);
    if (!isValid) {
      usernameAvailability = UsernameAvailability.invalid;
      notifyListeners();
      return;
    }

    usernameAvailability = UsernameAvailability.checking;
    notifyListeners();
    final checkedUsername = username;
    _usernameDebounce = Timer(const Duration(milliseconds: 450), () async {
      try {
        final available = await userRepository.checkUsernameAvailability(
          checkedUsername,
        );
        if (username != checkedUsername) return;
        usernameAvailability = available
            ? UsernameAvailability.available
            : UsernameAvailability.unavailable;
      } catch (_) {
        if (username != checkedUsername) return;
        usernameAvailability = UsernameAvailability.unavailable;
        errorMessage = 'Could not check username. Try again.';
      }

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
    errorMessage = null;
    unawaited(
      analytics.track('username_submitted', {
        'username_length': username.length,
      }),
    );
    notifyListeners();
    if (!canContinueProfile) return false;

    isSavingUsername = true;
    notifyListeners();
    try {
      final user = await userRepository.updateProfile(
        displayName: displayName.trim(),
        username: username,
        language: isEnglish ? 'en' : 'id',
      );
      onCurrentUserChanged?.call(user);
      unawaited(analytics.track('profile_completed', {'has_avatar': false}));
      return true;
    } catch (_) {
      errorMessage = 'Could not save profile. Try again.';
      return false;
    } finally {
      isSavingUsername = false;
      notifyListeners();
    }
  }

  void toggleInterest(String interest) {
    errorMessage = null;
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
    notifyListeners();
  }

  Future<bool> continueInterests({required bool skipped}) async {
    isSavingInterests = true;
    errorMessage = null;
    notifyListeners();
    try {
      final interests = skipped ? <String>[] : selectedInterests.toList();
      final user = await userRepository.updateInterests(interests);
      onCurrentUserChanged?.call(user);
      unawaited(
        analytics.track('interests_selected', {
          'count': interests.length,
          'skipped': skipped,
        }),
      );
      return true;
    } catch (_) {
      errorMessage = 'Could not save interests. Try again.';
      return false;
    } finally {
      isSavingInterests = false;
      notifyListeners();
    }
  }

  Future<void> viewAIConsent() async {
    await analytics.track('ai_consent_viewed', {'source': 'onboarding'});
  }

  Future<bool> acceptAIConsent() async {
    isSavingAIConsent = true;
    errorMessage = null;
    notifyListeners();
    try {
      await userRepository.acceptAIConsent(version: '2026-05-20-dev');
      aiConsentAccepted = true;
      await analytics.track('ai_consent_accepted', {'memory_enabled': false});
      await analytics.track('onboarding_completed', {
        'interests_count': selectedInterests.length,
        'language': language.name,
      });
      return true;
    } catch (_) {
      errorMessage = 'Could not save AI consent. Try again.';
      return false;
    } finally {
      isSavingAIConsent = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _usernameDebounce?.cancel();
    super.dispose();
  }
}
