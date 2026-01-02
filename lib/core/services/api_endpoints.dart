abstract class ApiEndpoints {
  static const String login = '/auth/login';
  static const String socialLogin = '/auth/social-login';
  static const String signup = '/auth/signup';
  static const String verifyOtp = '/auth/verify-otp';
  static const String completeSignup = '/auth/complete-profile';
  static const String doshPricesCurrent = '/dosh/prices/current';
  static const String doshPricesHistory = '/dosh/prices/history';
  static const String doshTypesData = '/dosh/types';
  static const String getAllShipments = '/shipments';
  static const String getShipmentsHistory = '/shipments/history';
  static const String getShipmentById = '/shipments/{id}';
  static const String createShipment = '/shipments';
  static const String editShipment = '/shipments/{id}';
  static const String cancelShipment = '/shipments/{id}/cancel';
  static const String addNotes = '/shipments/{id}/notes';
  static const String getAllNotes = '/shipments/{id}/notes';
  static const String getProfileInfo = '/trader/me';
  static const String contactUs = '/contact';
  static const String getTraderEcoInfo = '/trader/eco/dashboard';
  static const String getTraderEcoRequests = '/trader/eco/redeem';
  static const String createTraderEcoRequest = '/trader/eco/redeem';
  static const String forgetPassword = '/auth/forgot-password';
  static const String verifyResetOtp = '/auth/verify-reset-otp';
  static const String resetPassword = '/auth/reset-password';

  // Representative
  static const String getRepShipments = '/representatives/shipments';
  static const String getRepShipmentById = '/shipments/{id}';
  static const String updateRepShipment =
      '/representatives/shipments/{id}/modify';
  static const String acceptRepShipment =
      '/representatives/shipments/{id}/accept';
  static const String rejectRepShipment =
      '/representatives/shipments/{id}/reject';
  static const String startShipmentSegment =
      '/representatives/shipments/{shipmentId}/segments/{segmentId}/start-pickup';
  static const String weighShipmentSegment =
      '/representatives/shipments/{shipmentId}/segments/{segmentId}/weigh';
  static const String deliverShipmentSegment =
      '/representatives/shipments/{shipmentId}/segments/{segmentId}/deliver';
  static const String failShipmentSegment =
      '/representatives/shipments/{shipmentId}/segments/{segmentId}/fail';
}
