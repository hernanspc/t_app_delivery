import 'dart:io';
import 'package:delivery_app/src/config/local_notifications/local_notifications.dart';
import 'package:delivery_app/src/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:delivery_app/src/config/app_router.dart';
import 'package:delivery_app/src/environment/environment.dart';
import 'package:delivery_app/src/providers/pushNotificationProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'src/blocs/notifications/notifications_bloc.dart';

PushNotificationProvider pushNotificationProvider = PushNotificationProvider();

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();

  // pushNotificationProvider.initPushNotification();

  if (Firebase.apps.isEmpty) {
    await NotificationsBloc.initializeFCM();
    //TODO: COMENTAR EN EMULADOR IOS
    if (Platform.isAndroid) {
      await LocalNotifications.initializeLocalNotifications();
    }
  }

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthService())],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NotificationsBloc(
              requestLocalNotificationPermissions:
                  LocalNotifications.requestPermissionLocalNotifications,
              showLocalNotification: LocalNotifications.showLocalNotification,
              authService: Provider.of<AuthService>(context, listen: false),
            ),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
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

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // Inglés
        const Locale('es', ''), // Español
      ],
      routerConfig: appRouter,
      // builder: (context, child) =>
      //     HandlenotificationInteractions(child: child!),
      builder: (context, child) {
        // Si GoRouter no encuentra la ruta (p.ej. myapp://auth/spotify)
        // devuelve un widget vacío en vez de mostrar "Not Found".
        if (child == null) return const SizedBox.shrink();

        // Aquí mantienes tu lógica de notificaciones
        return HandlenotificationInteractions(child: child);
      },
    );
  }
}

class HandlenotificationInteractions extends StatefulWidget {
  final Widget child;
  const HandlenotificationInteractions({super.key, required this.child});

  @override
  State<HandlenotificationInteractions> createState() =>
      _HandlenotificationInteractionsState();
}

class _HandlenotificationInteractionsState
    extends State<HandlenotificationInteractions> {
  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    context.read<NotificationsBloc>().handleRemoteMessage(message);

    final messageId = message.messageId
        ?.replaceAll(':', '')
        .replaceAll('%', '');
    print('messageId $message');
    // appRouter.push('/push-details/$messageId');
  }

  @override
  void initState() {
    super.initState();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
