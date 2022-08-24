import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stars_live/providers/auth_provider.dart';
import 'package:stars_live/providers/broadcast_audience_provider.dart';
import 'package:stars_live/providers/gifts_provider.dart';
import 'package:stars_live/providers/lives_provider.dart';
import 'package:stars_live/global/translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/utils/Cache_Helper.dart';
import 'package:stars_live/global/routers.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:stars_live/screens/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init firebase
  await Firebase.initializeApp();

  // set device orientation to portrait only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // make our app full screen
  //await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // init git storage
  await GetStorage.init();

  // init cache helper
  await Cache_Helper.init();

  runApp(MyApp());
  //runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: () => MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
          ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
          ChangeNotifierProvider<LivesProvider>(create: (_) => LivesProvider()),
          ChangeNotifierProvider<GiftsProvider>(create: (_) => GiftsProvider()),
          ChangeNotifierProvider<BroadCastAudienceProvider>(
            create: (_) => BroadCastAudienceProvider(),
          )
        ],
        child: GetMaterialApp(
          translations: Translation(),
          locale: Cache_Helper.getData('lang') == null ||
                  Cache_Helper.getData('lang') == 'ar'
              ? Locale('ar')
              : Locale('en'),
          fallbackLocale: Locale('ar'),
          showSemanticsDebugger: false,
          debugShowCheckedModeBanner: false,
          routes: Routes.router,
          builder: (context, widget) {
            ScreenUtil.setContext(context);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
          initialRoute: SplashScreen.id,
          theme: ThemeData(
            appBarTheme:
                AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle()),
            textTheme: GoogleFonts.cairoTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
        ),
      ),
    );
  }
}
