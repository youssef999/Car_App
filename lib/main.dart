
// ignore_for_file: unused_local_variable, avoid_print
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_project/helper/firebaseApi.dart';
import 'package:first_project/theme/app_theme.dart';
import 'package:first_project/translations/app_translations.dart';
import 'package:first_project/views/home_view.dart';
import 'package:first_project/views/login_view.dart';
import 'package:first_project/views/otp_view.dart';
import 'package:first_project/views/provider%20views/provider_dashboard.dart';
import 'package:first_project/views/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

  void main() async {
    
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(); // Initialize Firebase Messaging
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  await FirebaseApi().initNotifications();
  initializeNotificationChannel();
  configureFirebaseMessaging();
  // Request permission for notifications (iOS only)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  // Get the FCM token
  String? token = await messaging.getToken();
  // ignore: duplicate_ignore
  // ignore: avoid_print
  print('FCM Token: $token');
  deleteCheckAtFirstOnly();
  // Listen for incoming messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // ignore: duplicate_ignore
    // ignore: avoid_print
    print(
        'Received a message while in the foreground: ${message.notification?.title}');
    // Show a local notification or update the UI
  });
  // Set the background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  checkLocationPermission();
  runApp(const MyApp());
 }

void initializeNotificationChannel() {
  AwesomeNotifications().initialize(
    null, // Use null for default app icon
    [
      NotificationChannel(
        channelKey:
            'basic-channel2', // Match this key with the one used in createNotification
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic messages',
        importance: NotificationImportance.High,
        defaultColor: Colors.blue,
        ledColor: Colors.white,
        playSound: true,
        enableVibration: true,
      ),
    ],
  );
}


deleteCheckAtFirstOnly(){
  //await box.write('providerReqId', providerIds);
  final box=GetStorage();
 // List providerIds = box.read('providerReqId') ?? [];
  bool checkIds = box.read('checkIds') ??false;

  if(checkIds==false){
    box.remove('providerReqId');
    box.write('checkIds', true);
  }else{
    print("empty ids");
  }

}


Future<bool> requestLocationPermission() async {
  // First, check if location services are enabled.
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled, request the user to enable them.
    return false;
  }

  // Check for location permission
  PermissionStatus permission = await Permission.location.status;

  if (permission.isGranted) {
    return true;
  } else if (permission.isDenied) {
    // Request permission
    PermissionStatus result = await Permission.location.request();
    return result.isGranted;
  } else if (permission.isPermanentlyDenied) {
    // Open app settings so the user can manually enable permission
    await openAppSettings();
    return false;
  }

  return false;
}

void checkLocationPermission() async {
  bool hasPermission = await requestLocationPermission();
  if (hasPermission) {
    // Access location now
    Position position = await Geolocator.getCurrentPosition();
    print('User location: ${position.latitude}, ${position.longitude}');
  } else {
    print('Location permission not granted');
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: redTheme,
      title: "Car Fix App",
      locale: const Locale('ar'),
      translations: AppTranslations(),
      home: SplashView(),

      //LoginPage(),
      //NearestProvidersPage(),
      //endRequestsPage(),
      getPages:[
        GetPage(name: '/HomeView', page: () => const HomeView()),
        GetPage(name: '/OtpView', page: () => OtpView(otp: '',)),
        GetPage(name: '/ProviderDashboard', page: () => ProviderDashboard())
      ],
    );
   }
}

Future<void> configureFirebaseMessaging() async {
  // ignore: duplicate_ignore
  // ignore: avoid_print
  print("NOTIF");
  FirebaseMessaging.instance
      .getInitialMessage()
      .then((RemoteMessage? message) async {
    if (message != null) {
      _handleNotification(message);
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print("Foreground message: ${message.notification?.title}");
    triggerNotification(message.notification!.title.toString());
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print("Opened app message: ${message.notification?.title}");
    _handleNotification(message);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

void _handleNotification(RemoteMessage message) {
  final String? route = message.data['route'];
  // ignore: duplicate_ignore
  // ignore: avoid_print
  print("ROUTE===$route");
  // Pass route from the notification payload
  if (route != null) {
    // navigatorKey.currentState?.push(MaterialPageRoute(
    //   builder: (context) => const AllChatsView(),
    // ));
    // Get.to(const AllChatsView()); // Assuming you're using GetX for navigation
  } else {
    print('NO ROUTE....');
    //Get.to(ChatView()); // Default navigation
  }
}

triggerNotification(String msg) {
  print("Trigger Notification with msg: $msg");
  return AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'basic-channel2',
      title: 'New Message',
      body: msg,
      payload: {'route': '/chatView'}, // Example payload with route
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.notification?.title}');
  // Show a local notification or update the UI
}
