// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:friendly_card_web/utils/inital_binding.dart';
import 'package:friendly_card_web/views/admin/admin_page.dart';
import 'package:friendly_card_web/views/login_page.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyChRlFdEsMK3Ns-UPvB9XlO3WKsJeX60fA",
        authDomain: "friendly-card.firebaseapp.com",
        projectId: "friendly-card",
        storageBucket: "friendly-card.firebasestorage.app",
        messagingSenderId: "496923338414",
        appId: "1:496923338414:web:5f7661463632815501af3f"),
  );

  Get.config(
    enableLog: false,
    defaultTransition: Transition.native,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        // SfGlobalLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('vi'),
        Locale('en'),
        Locale('fr'),
      ],
      locale: const Locale('vi'),
      initialRoute: "/",
      initialBinding: InitalBinding(),
      getPages: [
        GetPage(
          name: '/',
          page: () => const LoginPage(),
          // binding:
        ),
        GetPage(
          name: '/admin',
          page: () => const AdminPage(),
          // binding: CheckLoginBingding(),
        ),
      ],
    );
  }
}
