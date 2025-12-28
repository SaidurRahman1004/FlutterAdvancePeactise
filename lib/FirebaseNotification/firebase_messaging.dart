import 'package:firebase_messaging/firebase_messaging.dart';
class NotificationService{
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  Future<void> initNotification() async{
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if(settings.announcement == AuthorizationStatus.authorized){
      print(" User granted permission for notifications");
    }
    String? tocken = await _fcm.getToken();//Tocken Use for sent notification on Specific Device
    print(" FCM Token: $tocken");

    //Handle Foreground Notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      print(" Got a message whilst in the foreground! ${message.notification?.title}");
    });

    //Handle Background/Terminated Notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      print(" Got a message whilst in the background!");
    });


  }







}