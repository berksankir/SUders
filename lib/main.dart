import 'package:flutter/material.dart';

// pubspec.yaml'daki name ile aynı olmalı!
import 'package:suders/pages/login_page.dart';
import 'package:suders/pages/verification_page.dart';
import 'package:suders/pages/welcome_back_page.dart';
import 'package:suders/pages/courses_page.dart';
import 'package:suders/pages/course_notes_page.dart';
import 'package:suders/pages/upload_notes_page.dart';
import 'package:suders/pages/admin_dashboard_page.dart';
import 'package:suders/pages/admin_user_management.dart';
import 'package:suders/pages/admin_course_management.dart';
import 'package:suders/pages/admin_instructor_management.dart';
import 'package:suders/pages/flagged_content_page.dart';
import 'package:suders/pages/user_profile_screen.dart';
import 'package:suders/pages/Saved_Notes_Screen.dart';

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
        '/uploadNotes': (context) => const UploadNotesPage(),
        '/profile': (context) => const SavedNotesScreen(),
        '/savedNotes': (context) => const MyNotesPage(),
        
        // Admin routes
        '/admin/dashboard': (context) => const AdminDashboardScreen(),
        '/admin/users': (context) => const UserManagementPage(),
        '/admin/courses': (context) => const ManageCoursesScreen(),
        '/admin/instructors': (context) => const ManageInstructorsScreen(),
        '/flagged': (context) => const FlaggedContentScreen(),
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
