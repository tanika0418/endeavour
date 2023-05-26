import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/auth/auth_screen.dart';
import 'package:endeavour22/auth/profile_screen.dart';
import 'package:endeavour22/drawermain/glimpses_provider.dart';
import 'package:endeavour22/drawermain/mian_screen.dart';
import 'package:endeavour22/events/event_main_provider.dart';
import 'package:endeavour22/events/payment_provider.dart';
import 'package:endeavour22/schedule/schedule_provider.dart';
import 'package:endeavour22/speakers/speakers_provider.dart';
import 'package:endeavour22/sponsors/sponsors_provider.dart';
import 'package:endeavour22/widgets/spalsh_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  FlutterNativeSplash.removeAfter(initialization);

  runApp(
    const MyApp(),
  );
}

Future initialization(BuildContext? context) async {
  // DO SOME PROCESS
  await Future.delayed(const Duration(seconds: 1));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SponsorsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => EventMainProvider(),
        ),
        // ChangeNotifierProvider(
        //   create: (ctx) => TeamProvider(),
        // ),
        ChangeNotifierProvider(
          create: (ctx) => SpeakerProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ScheduleProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PaymentProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => GlimpsesProvider(),
        ),
        // ChangeNotifierProvider(
        //   create: (ctx) => MarketWatchProvider(),
        // ),
      ],
      child: ScreenUtilInit(
        builder: () =>
            // MaterialApp(debugShowCheckedModeBanner: false,
            //     title: 'Endeavour 22',
            //     theme: ThemeData(
            //       fontFamily: 'Nunito',
            //       primarySwatch: Colors.blue,
            //     ),
            //     initialRoute: '/',
            //     routes: {
            //       '/': (contextMain) => MainScreen(),
            //     },),
            Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Endeavour 23',
            theme: ThemeData(
              fontFamily: 'Nunito',
              primarySwatch: Colors.blue,
            ),
            initialRoute: '/',
            routes: {
              '/': (contextMain) => AuthWrapper(auth: auth),
            },
          ),
        ),
        designSize: const Size(360, 640),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  final Auth auth;
  AuthWrapper({Key? key, required this.auth}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.auth.isAuth
        ? widget.auth.userModel == null
            ? const SplashScreen()
            : widget.auth.userModel!.profile
                ? const MainScreen()
                : const ProfileScreen(isUpdate: false)
        //:AuthScreen();
        : FutureBuilder(
            future: widget.auth.tryAutoLogin(context),
            builder: (ctx, authResultSnapshot) =>
                authResultSnapshot.connectionState == ConnectionState.waiting
                    ? const SplashScreen()
                    : const AuthScreen(),
          );
  }
}
