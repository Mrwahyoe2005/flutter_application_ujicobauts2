import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 🔹 Kumpulan pesan default (masih bisa digunakan untuk random reminder)
  static final List<String> _dailyMessages = [
    "💰 Catat pengeluaranmu hari ini biar keuangan tetap sehat!",
    "📊 Yuk pantau saldo dan transaksi kamu!",
    "💡 Simpan sedikit setiap hari, masa depanmu akan berterima kasih.",
    "🪙 Jangan lupa update transaksi hari ini!",
    "💵 Kelola keuangan dengan bijak, Made Radit!",
  ];

  // 🔹 Inisialisasi plugin notifikasi
  static Future<void> initialize(BuildContext context) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);

    // ✅ Izin notifikasi (khusus Android 13+)
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // 🔹 Menampilkan notifikasi dengan pesan random (masih digunakan di fitur lama)
  static Future<void> showDailyReminder() async {
    final random = Random();
    final message = _dailyMessages[random.nextInt(_dailyMessages.length)];

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'fintrack_channel',
      'FinTrack Notifications',
      channelDescription: 'Notifikasi harian FinTrack',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      1,
      'Pengingat Harian FinTrack',
      message,
      notificationDetails,
    );
  }

  // 🔹 Fungsi notifikasi custom (langsung muncul)
  static Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'fintrack_channel',
      'FinTrack Notifications',
      channelDescription: 'Notifikasi personal FinTrack',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique ID
      title,
      body,
      platformChannelSpecifics,
    );
  }

  // 🔹 Fungsi notifikasi yang muncul setelah delay tertentu
  static Future<void> showDelayedNotification({
    required String title,
    required String body,
    required Duration delay,
  }) async {
    await Future.delayed(delay);
    await showInstantNotification(title: title, body: body);
  }
}
