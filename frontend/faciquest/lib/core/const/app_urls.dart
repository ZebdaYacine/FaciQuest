class AppUrls {
  static const useLocalhost = true;
  static const baseUrl =
      useLocalhost ? 'http://localhost:9000' : 'http://105.109.18.143:9000';

  /// Auth Urls
  static const authLoginUrl = '$baseUrl/login';
  static const authSignUpUrl = '$baseUrl/sign-up';
  static const authForgotPasswordUrl = '$baseUrl/forget-pwd';
  static const authLogoutUrl = '$baseUrl/profile/logout';
  static const authSetNewPasswordUrl = '$baseUrl/profile/set-new-pwd';
  static const authVerifyOtpUrl = '$baseUrl/confirm-account';

  /// survey
  static const createSurvey = '$baseUrl/profile/create-survey';
  static const updateSurvey = '$baseUrl/profile/update-survey';
  static const deleteSurvey = '$baseUrl/profile/delete-survey';
  static const getSurvey = '$baseUrl/profile/get-survey';
  static const getSurveys = '$baseUrl/profile/get-surveys';
  static const submitAnswers = '$baseUrl/profile/submit-answers';
  static const getMySurveys = '$baseUrl/profile/get-my-surveys';
}
