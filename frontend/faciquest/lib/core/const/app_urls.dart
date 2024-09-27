class AppUrls {
  static const baseUrl = 'http://localhost:9000';

  /// Auth Urls
  static const authLoginUrl = '$baseUrl/login';
  static const authSignUpUrl = '$baseUrl/sign-up';
  static const authForgotPasswordUrl = '$baseUrl/forget-pwd';
  static const authLogoutUrl = '$baseUrl/profile/logout';
  static const authSetNewPasswordUrl = '$baseUrl/profile/set-new-pwd';
  static const authVerifyOtpUrl = '$baseUrl/confirm-account';

  /// survey
  static String getSurveyUrl(String surveyId) => '$baseUrl/survey/$surveyId';
}
