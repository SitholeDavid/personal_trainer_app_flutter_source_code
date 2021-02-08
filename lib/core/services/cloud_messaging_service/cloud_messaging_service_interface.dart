abstract class CloudMessagingServiceInterface {
  Future<String> getFCMToken();

  Future trainerCancelBookingAlert(
      {String clientToken, String day, String time});
}
