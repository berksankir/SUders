import 'package:flutter/material.dart';

// pubspec.yaml'daki name ile aynı olmalı!
import 'package:suders/pages/login_page.dart';
import 'package:suders/pages/verification_page.dart';
import 'package:suders/pages/welcome_back_page.dart';
import 'package:suders/pages/courses_page.dart';
import 'package:suders/pages/course_notes_page.dart';
import 'package:suders/pages/upload_notes_page.dart';

void main() {
  runApp(const SUDersApp());
}

class SUDersApp extends StatelessWidget {
  const SUDersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SUDers',
      theme: ThemeData.dark(),

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginPage(),
        '/verification': (context) => const VerificationPage(),
        '/welcomeBack': (context) => const WelcomeBackPage(),
        '/courses': (context) => const CoursesPage(),

        // Sabit sayfa (parametre almayan)
        '/uploadNotes': (context) => const UploadNotesPage(),
      },

      // PARAMETRE ALAN SAYFALAR → onGenerateRoute
      onGenerateRoute: (settings) {
        // COURSE NOTES PAGE → parametre alıyor
        if (settings.name == '/courseNotes') {
          final args = settings.arguments as Map<String, dynamic>;

          return MaterialPageRoute(
            builder: (context) => CourseNotesPage(
              courseCode: args['courseCode'],
              courseName: args['courseName'],
            ),
          );
        }

        return null;
      },
    );
  }
}
