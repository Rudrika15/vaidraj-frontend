import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vaidraj/provider/add_new_patient_provider.dart';
import 'package:vaidraj/provider/all_disease_provider.dart';
import 'package:vaidraj/provider/appointment_provider.dart';
import 'package:vaidraj/provider/get_brach_provider.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/provider/medical_history_provider.dart';
import 'package:vaidraj/provider/mobile_verification_provider.dart';
import 'package:vaidraj/provider/my_patients_provider.dart';
import 'package:vaidraj/provider/prescription_provider.dart';
import 'package:vaidraj/screens/splash_screen/splash.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("settings");
  await dotenv.load(fileName: ".env");
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LocalizationProvider()),
      ChangeNotifierProvider(create: (_) => MobileVerificationProvider()),
      ChangeNotifierProvider(create: (_) => GetBrachProvider()),
      ChangeNotifierProvider(create: (_) => AddNewPatientProvider()),
      ChangeNotifierProvider(create: (_) => AllDiseaseProvider()),
      ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ChangeNotifierProvider(create: (_) => MedicalHistoryProvider()),
      ChangeNotifierProvider(create: (_) => PrescriptionStateProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, utils, child) => Sizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            title: 'Vaidraj App',
            debugShowCheckedModeBanner: false,
            locale: Locale(utils.currentLocale),
            localizationsDelegates: const [
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
