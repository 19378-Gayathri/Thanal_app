import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


import 'screens/donation_ledger_screen.dart';
import 'screens/voice_assist_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/location_permission.dart';
import 'screens/startscreen.dart';
import 'screens/loginscreen.dart';
import 'screens/registerscreen.dart';
import 'screens/home_screen.dart';
import 'screens/alert_screen.dart';
import 'screens/checklist_screen.dart';
import 'screens/guide_screen.dart';
import 'screens/volunteerregister_screen.dart';
import 'screens/volunteerdashboard_screen.dart';
import 'screens/adminpanel_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/first_aid_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/report_incident_screen.dart';
import 'screens/chatbotscreen.dart';
import 'screens/donation_form_screen.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web, 
  );

  // Initialize Easy Localization
  await EasyLocalization.ensureInitialized();

  // Run the app with Easy Localization
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('hi'), Locale('ml')],
      path: 'assets/translations', // Path to localization files
      fallbackLocale: const Locale('en'),
      child: const ThanalApp(),
    ),
  );
}

class ThanalApp extends StatelessWidget {
  const ThanalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thanal App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale, // Use the current locale
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/location': (context) => LocationPermissionScreen(),
        '/start': (context) => StartScreen(),
        '/signup': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/donation-form': (context) => DonationScreen(),
        '/donation-ledger': (context) => DonationLedgerScreen(),
        '/alert': (context) => const AlertsScreen(),
        '/checklist': (context) => const ChecklistScreen(),
        '/guide': (context) => const GuideScreen(),
        '/volunteer': (context) => const VolunteerRegisterScreen(),
        '/volunteer_dashboard': (context) => const VolunteerDashboardScreen(),
        '/admin': (context) => const AdminPanelScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/first-aid': (context) => const FirstAidScreen(),
        '/emergency_contacts': (context) => const ContactScreen(),
        '/report': (context) => const ReportIncidentScreen(),
        '/chatbot': (context) => ChatbotScreen(),
        '/voice': (context) => const VoiceAssistScreen(),
      },
    );
  }
}