
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


class FirebaseApi {

  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    //print("FCM Token: $fCMToken");
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await initPushNotifications();
    // Handle notification that opens the app when it was fully closed
    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        print("Initial message fully closed received: ${message.notification?.title}");
        handleMessage2(message);
      }
    });
  }
  void handleMessage2(RemoteMessage? message) {
    print(".......................HANDLE 2222222");
    if (message == null) return;
    final notificationTitle = message.notification?.title ?? '';
    //final notificationbody = message.notification?.title ?? '';
    print("Notification clicked11111: $notificationTitle");

    //تم اضافة مهام جديدة في تخصصك

    if (notificationTitle.contains("في تخصصك")) {
      print("..........xxx......order in your cat.....xxxxxx....");
      Future.delayed(const Duration(seconds: 5)).then((v){

      });
    }


    // Navigate to the correct page based on notification title
    if (notificationTitle.contains("قبول")) {
      print("..........xxx......ORDERS Accepted.....xxxxxx....");

      Future.delayed(const Duration(seconds: 6)).then((v){

      });
    }

    else if (notificationTitle.contains("2")) {
      print("..........222222222........");

      Future.delayed(const Duration(seconds: 6)).then((v){
        // navigatorKey.currentState?.push(MaterialPageRoute(
        //   builder: (context) => const AllChatsView(),
        // ));
      });

    }  else if (notificationTitle.contains("5")

    ){
      print("..........555555555....");

      Future.delayed(const Duration(seconds: 6)).then((v){
        // navigatorKey.currentState?.push(MaterialPageRoute(
        //     builder: (context) => const SettingsView()
        // ));
      });

    }
    else if (notificationTitle.contains("3")  ||
        notificationTitle.contains("4")) {

      final box=GetStorage();
      String roleId=box.read('roleId')??'0';
      print("..........xxx......444444&&333333.....xxxxxx....");

      if(roleId=='0'){
        Future.delayed(const Duration(seconds: 6)).then((v){
          // navigatorKey.currentState?.push(MaterialPageRoute(
          //   builder: (context) => const  UserStatics(),
          // ));
        });
      }else{
        Future.delayed(const Duration(seconds: 6)).then((v){
          // navigatorKey.currentState?.push(MaterialPageRoute(
          //   builder: (context) => const  WorkersHome(),
          // ));
        });
      }
    }



    else if (notificationTitle.contains("رفض")) {
      print("..........xxx......ORDERS REFUSED.....xxxxxx....");

      Future.delayed(const Duration(seconds: 6)).then((v){
        // navigatorKey.currentState?.push(MaterialPageRoute(
        //   builder: (context) => WorkerTasks2(statusType: 'مهام ملغاه',
        //     stTitle: 'مهام ملغاه',
        //   ),
        // ));
      });

    } else if (notificationTitle.contains("عرض جديد")) {
      print("..........xxx......new offer.....xxxxxx....");

      Future.delayed(const Duration(seconds: 6)).then((v){
        // navigatorKey.currentState?.push(MaterialPageRoute(
        //   builder: (context) => UserTasksView2(statusType: 'مهام مطروحة',
        //
        //     title: 'مهام مطروحة',
        //   ),
        // ));

      });


    } else if (notificationTitle.contains("تم شراء خدمتك الان")) {
      print("BUY.....");

      Future.delayed(const Duration(seconds: 6)).then((v){
        // navigatorKey.currentState?.push(MaterialPageRoute(
        //   builder: (context) => ServicesOrders(statusType: 'مهام مطروحة',
        //     stTitle: 'مهام مطروحة',
        //   ),
        // ));
      });

    } else if (notificationTitle.contains("رسالة")) {

      print("Chat222222");

      Future.delayed(const Duration(seconds: 6)).then((v){
        // navigatorKey.currentState?.push(MaterialPageRoute(
        //   builder: (context) => const AllChatsView(),
        // ));
      });

    } else {
      print("No.....1111...");
    }
  }
  void handleMessage(RemoteMessage? message) {


    if (message == null) return;
    final notificationTitle = message.notification?.title ?? '';
    print("Notification 444444444 clicked: $notificationTitle");

    //تم اضافة مهام جديدة في تخصصك

    if (notificationTitle.contains("في تخصصك")) {
      print("..........xxx......wwwwwORDERSwwwwwww Accepted.....xxxxxx....");
     // Get.to(const NewWorkView());
    }

    // Navigate to the correct page based on notification title
    else if (notificationTitle.contains("قبول")) {
      print("..........xxx......ORDERS Accepted.....xxxxxx....");
      // Get.to(WorkerTasks2(statusType: 'مهام قيد التنفيذ',
      //   stTitle: 'مهام قيد التنفيذ',
      // ));
    } else if (notificationTitle.contains("رفض")) {
      print("..........xxx......ORDERS REFUSED.....xxxxxx....");
      // Get.to(WorkerTasks2(statusType: 'مهام ملغاه',
      //   stTitle: 'مهام ملغاه',
      // ));
    } else if (notificationTitle.contains("عرض جديد")) {
      print("..........xxx......new offer.....xxxxxx....");
      // Get.to(UserTasksView2(statusType: 'مهام مطروحة',
      //
      //   title: 'مهام مطروحة',
     // ));
    } else if (notificationTitle.contains("تم شراء خدمتك الان")) {
      print("BUY.....");
      // Get.to(ServicesOrders(statusType: 'مهام مطروحة',
      //   stTitle: 'مهام مطروحة',
      // ));
    } else if (notificationTitle.contains("رسالة")) {
      print("Chat222222");
   //   Get.to(const AllChatsView());
    }

    else if (notificationTitle.contains("2")) {
      print("Chat222222");
    //  Get.to(const AllChatsView());
    }  else if (notificationTitle.contains("5")) {
      print("...............Settings................");
   //   Get.to(const SettingsView());
    }


    else if (notificationTitle.contains("3")||notificationTitle.contains("4")) {

      final box=GetStorage();
      String roleId=box.read('roleId')??'0';
      print("..........xxx......444444&&333333.....xxxxxx....");

      if(roleId=='0'){
       // Get.to(const UserStatics());

      }else{

//        Get.to(const WorkersHome());

      }
      print("Chat222222");

    }

    else {
      print("No...22222.....");
    }
  }
  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Foreground notification handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received: ${message.notification?.title}");
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'basic-channel',
          title: message.notification?.title ?? '',
          body: message.notification?.body ?? '',
        ),
      );
      AwesomeNotifications().setListeners(
        onActionReceivedMethod: (ReceivedAction receivedAction) async {


          //تم اضافة مهام جديدة في تخصصك

          if (receivedAction.body?.contains("في تخصصك") ?? false) {
        //    Get.to(const NewWorkView());
          }

          else if (receivedAction.title?.contains("في تخصصك") ?? false) {
          //  Get.to(const NewWorkView());
          }

          else if (receivedAction.body?.contains("قبول") ?? false) {
            // Get.to(WorkerTasks2(statusType: 'مهام قيد التنفيذ',
            //   stTitle: 'مهام قيد التنفيذ',
            // ));
          } else if (receivedAction.body?.contains("رفض") ?? false) {
            // Get.to(WorkerTasks2(statusType: 'مهام ملغاه',
            //   stTitle: 'مهام ملغاه',
            // ));
          } else if (receivedAction.body?.contains("عرض جديد") ?? false) {

            // Get.to(UserTasksView2(statusType: 'مهام مطروحة',
            //   title: 'مهام مطروحة',
            // ));

          } else if (receivedAction.body?.contains("تم شراء خدمتك الان") ?? false) {
            // Get.to(ServicesOrders(statusType: 'مهام مطروحة',
            //   stTitle: 'مهام مطروحة',
            //
            // ));
          } else if (receivedAction.body?.contains("رسالة") ?? false) {
          //  Get.to(const AllChatsView());
          }

          else if (receivedAction.body?.contains("2") ?? false) {
           // Get.to(const AllChatsView());
          }  else if (receivedAction.body?.contains("5") ?? false) {
          //  Get.to(const SettingsView());
          }
          else if (receivedAction.body?.contains("3") ?? false) {
           // Get.to( const UserStatics());
          }  else if (receivedAction.body?.contains("4") ?? false) {
         //   Get.to( const UserStatics());
          }

          else {
            print("......No action required.HERE........");
          }
        },
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("........xx............Background.....xx...message.....xx...received:........xx............. ${message.notification?.title}");
}

// class FirebaseApi {
//
//   final _firebaseMessaging = FirebaseMessaging.instance;
//
//   //
//   // Future<void> initNotifications() async {
//   //
//   //
//   //   await _firebaseMessaging.requestPermission();
//   //   final fCMToken = await _firebaseMessaging.getToken();
//   //   print("FCM Token: $fCMToken");
//   //
//   //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   //   await initPushNotifications();
//   //
//   //
//   //
//   //
//   // }
//
//   Future<void> initNotifications() async {
//     await _firebaseMessaging.requestPermission();
//     final fCMToken = await _firebaseMessaging.getToken();
//     print("FCM Token: $fCMToken");
//
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     await initPushNotifications();
//
//     // Handle notification that opens the app when it was fully closed
//     _firebaseMessaging.getInitialMessage().then((message) {
//       if (message != null) {
//         print("Initial message received: ${message.notification?.title}");
//         handleMessage(message);
//       }
//     });
//   }
//
//
//   void handleMessage(RemoteMessage? message) {
//     if (message == null) return;
//     final notificationTitle = message.notification?.title ?? '';
//     print("Notification clicked: $notificationTitle");
//
//     if(notificationTitle.contains("قبول") ){
//       print("..........xxx......ORDERS Accepted.....xxxxxx....");
//
//       Get.to(WorkerTasks2
//         (statusType: 'مهام قيد التنفيذ'));
//
//     }
//
//     else if(notificationTitle.contains("رفض") ){
//       print("..........xxx......ORDERS REFUSED.....xxxxxx....");
//       Get.to(WorkerTasks2
//         (statusType: 'مهام ملغاه')
//       );
//     }
//
//    else if(notificationTitle.contains("عرض جديد") ){
//       print("..........xxx......new offer.....xxxxxx....");
//       Get.to(UserTasksView2(
//           statusType: 'مهام مطروحة'
//       ));
//     }
//
//   else  if(notificationTitle.contains("تم شراء خدمتك الان") ){
//       print("BUY.....");
//       Get.to(ServicesOrders
//         (
//           statusType: 'مهام مطروحة'
//       ));
//
//     }
//     else  if (notificationTitle.contains("رسالة") ) {
//       print("Chat222222");
//       Get.to(const AllChatsView());
//       //  navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => const AllChatsView()));
//     } else {
//       print("No........");
//
//     }
//     // if (notificationTitle.contains("Chat")) {
//     //   print("Chat");
//     //   navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => const AllChatsView()));
//     // } else {
//     //   print("No");
//     // }
//   }
//
//   Future<void> initPushNotifications() async {
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     // Foreground notification handling
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("Foreground message received: ${message.notification?.title}");
//       AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id: 1,
//           channelKey: 'basic-channel',
//           title: message.notification?.title ?? '',
//           body: message.notification?.body ?? '',
//         ),
//       );
//
//       // Navigate to `AllChatsView` on tap from a custom notification dialog
//       AwesomeNotifications().setListeners(
//         onActionReceivedMethod: (ReceivedAction receivedAction) async {
//           print("====DATA==="+receivedAction.title.toString());
//           print("====DATA==="+receivedAction.body.toString());
//           print("====DATA==="+receivedAction.toString());
//
//
//           if(receivedAction.body?.contains("قبول")??false ){
//             print("..........xxx......ORDERS Accepted.....xxxxxx....");
//
//             Get.to(WorkerTasks2
//               (statusType: 'مهام قيد التنفيذ'));
//           }
//
//           else if(receivedAction.body?.contains("رفض")??false ){
//             print("..........xxx......ORDERS REFUSED.....xxxxxx....");
//             Get.to(WorkerTasks2
//               (statusType: 'مهام ملغاه')
//             );
//           }
//
//           else if(receivedAction.body?.contains("عرض جديد")??false ){
//             print("..........xxx......new offer.....xxxxxx....");
//             Get.to(UserTasksView2(
//                 statusType: 'مهام مطروحة'
//             ));
//           }
//
//           else  if(receivedAction.body?.contains("تم شراء خدمتك الان") ??false){
//             print("BUY.....");
//             Get.to(ServicesOrders
//               (
//                 statusType: 'مهام مطروحة'
//             ));
//             // Get.to( const WorkersHome());
//             //Get.to(MainHome(index: 1,));
//           }
//           else  if (receivedAction.body?.contains("رسالة")??false ) {
//             print("Chat222222");
//             Get.to(const AllChatsView());
//             //  navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => const AllChatsView()));
//           } else {
//             print("No........");
//             //  Get.to(const AllChatsView());
//             //navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => const AllChatsView()));
//           }
//
//
//
//
//
//
//         //    if(receivedAction.body?.contains("تم شراء خدمتك الان") ?? false){
//         //      Get.to( const WorkersHome());
//         //      //Get.to(MainHome(index: 1,));
//         //    }
//         // else  if (receivedAction.body?.contains("رسالة") ?? false) {
//         //     print("Chat");
//         //     Get.to(const AllChatsView());
//         //   //  navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => const AllChatsView()));
//         //   } else {
//         //     print("No");
//         //   //  Get.to(const AllChatsView());
//         //     //navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => const AllChatsView()));
//         //   }
//         },
//       );
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
//   }
// }
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Background message received: ${message.notification?.title}");
//
// }
