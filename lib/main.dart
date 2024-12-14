import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical/pages/auth/SignUpScreen.dart';
import 'package:medical/pages/auth/loginScreen.dart';
import 'package:medical/pages/home/doctorhome.dart';
import 'package:medical/pages/test.dart';
import 'package:medical/provider/login_provider.dart';
import 'package:medical/services/authservice.dart';
import 'package:medical/utils/colors.dart';
import 'package:medical/wrapper.dart';
import 'package:medical/wrapper_builder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();

    Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
        Permission.camera.request();
        Permission.microphone.request();
      }
    });

  if (Platform.isAndroid) {
    await Firebase.initializeApp( options: const FirebaseOptions( apiKey: "AIzaSyDUZH5lX-b91LlK0LE-4hCXl0RzzHrzW2U", appId: "1:1067824770093:android:e3cdd07dbe49fe58699ca4", messagingSenderId: "610907626712", projectId:"medicalapp-1e076" ));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: AppColors.white, // Color you want for status bar
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (_) => AuthService(),
          ),
          ChangeNotifierProvider(create: (context) => LoginProvider())
        ],
        builder: (context, vm) {
          return WrapperBuilder(
              builder: (context) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Demo',
                  navigatorKey: navigatorKey,
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(
                        seedColor: Colors.deepPurple),
                    useMaterial3: true,
                  ),
                  home: MultiTouchScreen(),
                  onGenerateRoute: (RouteSettings settings) {
                    //Routing users to different pages (With Notification in our case)
                    switch (settings.name) {
                      case '/':
                        return MaterialPageRoute(
                            builder: (_) => Wrapper());

                      case '/call':
                        return MaterialPageRoute(
                            builder: (_) => DoctorHome());  // roomId: roomId
                    }
                    return null;
                  },
                );
              });
        }
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogInScreen(),
    );
  }
}
