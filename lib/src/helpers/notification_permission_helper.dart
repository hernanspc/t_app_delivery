import 'package:delivery_app/src/blocs/notifications/notifications_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationPermissionHelper {
  static Future<void> requestIfDisabled(BuildContext context) async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.denied ||
        settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      context.read<NotificationsBloc>().requestPermission();
    }
  }
}
