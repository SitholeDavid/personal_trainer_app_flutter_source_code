import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'cloud_messaging_service_interface.dart';

class CloudMessagingService extends CloudMessagingServiceInterface {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  HttpsCallable trainerCancelBooking = CloudFunctions.instance
      .getHttpsCallable(functionName: 'trainerCancelBooking');

  @override
  Future<String> getFCMToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      return '';
    }
  }

  @override
  Future trainerCancelBookingAlert(
      {String clientToken, String day, String time}) async {
    if (clientToken.isEmpty) return;

    try {
      await trainerCancelBooking.call(<String, dynamic>{
        'clientToken': clientToken,
        'day': day,
        'time': time
      });
    } catch (e) {}
  }
}
