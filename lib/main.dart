import 'package:flutter/material.dart';
import 'pages/courses_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SuDERS',
      theme: ThemeData.dark(),
      home: const CoursesPage(), // uygulama açılınca gözükecek ekran
    );
  }
}
