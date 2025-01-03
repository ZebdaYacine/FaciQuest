class AppUrls {
  static const useLocalhost = false;
  static const baseUrl = useLocalhost
      ? 'http://localhost:9000'
      : 'https://faciquest-2.onrender.com';

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
  static const getSurveys = '$baseUrl/profile/get-all-surveys';
  static const submitAnswers = '$baseUrl/profile/submit-answer';
  static const getMySurveys = '$baseUrl/profile/get-my-surveys';
  static const getSurveyCollectors = '$baseUrl/profile/get-survey-collectors';
  static const getTargetingCriteria = '$baseUrl/profile/get-criterias';
  static const confirmPayment = '$baseUrl/profile/confirm-payment';
  static const estimatePrice = '$baseUrl/profile/estimate-price';
  static const createCollector = '$baseUrl/profile/create-collector';
  static const deleteCollector = '$baseUrl/profile/delete-collector';
  static const getSubmissions = '$baseUrl/profile/get-answers';
}
