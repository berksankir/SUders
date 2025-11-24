import 'package:flutter/material.dart';
import 'course_notes_page.dart';
import 'upload_notes_page.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundDark = Color(0xFF101622);
    const surfaceDark = Color(0xFF182131);
    const primary = Color(0xFF135BEC);
    const sabanciBlue = Color(0xFF004B8D);

    final courses = [
      _Course(
        code: 'CS 310',
        title: 'Data Structures and Algorithms',
        faculty: 'FENS',
        color: sabanciBlue,
        icon: Icons.code,
      ),
      _Course(
        code: 'CS 300',
        title: 'Programming Paradigms',
        faculty: 'FENS',
        color: sabanciBlue,
        icon: Icons.terminal,
      ),
      _Course(
        code: 'IE 311',
        title: 'Manufacturing and Service Systems',
        faculty: 'FENS',
        color: sabanciBlue,
        icon: Icons.factory,
      ),
      _Course(
        code: 'SPS 101',
        title: 'Humanity and Society I',
        faculty: 'FASS',
        color: Colors.purple,
        icon: Icons.groups,
      ),
      _Course(
        code: 'MGMT 203',
        title: 'Introduction to Financial Accounting',
        faculty: 'SBS',
        color: Colors.green,
        icon: Icons.account_balance,
      ),
    ];

    return Scaffold(
      backgroundColor: backgroundDark,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UploadNotesPage(), // const YOK
            ),
          );
        },
        child: const Icon(Icons.add, size: 30),
      ),
      bottomNavigationBar: BottomAppBar(
        color: surfaceDark.withOpacity(0.9),
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _NavItem(icon: Icons.school, label: 'Courses', isActive: true),
              _NavItem(icon: Icons.person_search, label: 'Instructors'),
              SizedBox(width: 40),
              _NavItem(icon: Icons.edit_calendar, label: 'Planner'),
              _NavItem(icon: Icons.person, label: 'Profile'),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // üst title bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Courses',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: surfaceDark.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: surfaceDark,
                  hintText: 'Search by course code or name',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: sabanciBlue,
                      width: 1.5,
                    ),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),

            // course list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: courses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return _CourseCard(course: course);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Course {
  final String code;
  final String title;
  final String faculty;
  final Color color;
  final IconData icon;

  const _Course({
    required this.code,
    required this.title,
    required this.faculty,
    required this.color,
    required this.icon,
  });
}

class _CourseCard extends StatelessWidget {
  final _Course course;

  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF182131);
    const accent = Color(0xFFFDB813);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseNotesPage(
              courseCode: course.code,
              courseName: course.title,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade800),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              offset: Offset(0, 2),
              color: Colors.black26,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: course.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(course.icon, color: course.color, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.code,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    course.title,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color:
                    (course.faculty == 'FENS'
                            ? accent
                            : course.faculty == 'FASS'
                            ? Colors.purple
                            : Colors.green)
                        .withOpacity(0.2),
                borderRadius: BorderRadius.circular(999),
              ),
              alignment: Alignment.center,
              child: Text(
                course.faculty,
                style: TextStyle(
                  color: course.faculty == 'FENS'
                      ? accent
                      : course.faculty == 'FASS'
                      ? Colors.purple
                      : Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF135BEC) : Colors.grey.shade400;

    return Expanded(
      child: InkWell(
        onTap: () {
          // şimdilik sadece UI, navigation yok
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
