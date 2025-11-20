import 'package:delivery_app/src/environment/environment.dart';
import 'package:delivery_app/src/providers/pushNotificationProvider.dart';
import 'package:delivery_app/src/utils/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

PushNotificationProvider pushNotificationProvider = PushNotificationProvider();

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: FirebaseConfig.currentPlatform);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print(
    'Handling a background message, recibiendo en segundo plano ${message.messageId}',
  );
  // pushNotificationProvider.showNotification(message);
}

void main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseConfig.currentPlatform);
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  pushNotificationProvider.initPushNotification();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    pushNotificationProvider.onMessaginListener();
  }

  @override
  Widget build(BuildContext context) {
    print('USE API_URL: ${Environment.API_URL}');

    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(title: const Text('Material App Bar')),
        body: const Center(child: Text('Hello World')),
      ),
    );
  }
}
