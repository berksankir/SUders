import 'package:flutter/material.dart';
import 'package:suders/utils/app_colors.dart';
import 'package:suders/utils/app_text_styles.dart';
import 'package:suders/utils/app_paddings.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: AppColors.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          // ✅ FAB → Upload Notes (NAMED NAVIGATION)
          Navigator.pushNamed(context, '/uploadNotes');
        },
        child: const Icon(Icons.add, size: 30, color: AppColors.textMain),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.card.withOpacity(0.9),
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const _NavItem(icon: Icons.school, label: 'Courses', isActive: true),
              _NavItem(
                icon: Icons.person_search,
                label: 'Instructors',
                onTap: () {
                  Navigator.pushNamed(context, '/instructors');
                },
              ),
              const SizedBox(width: 40),
              const _NavItem(icon: Icons.edit_calendar, label: 'Planner'),
              _NavItem(
                icon: Icons.person,
                label: 'Profile',
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Courses',
                      style: AppTextStyles.title,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.card.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: AppColors.textMain,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                style: TextStyle(color: AppColors.textMain),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.card,
                  hintText: 'Search by course code or name',
                  hintStyle: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: sabanciBlue,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            // Course Cards
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

// ----------------------------------
// COURSE CARD (NAMED ROUTE FIXED)
// ----------------------------------

class _CourseCard extends StatelessWidget {
  final _Course course;

  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFFDB813);

    return InkWell(
      onTap: () {
        // ✅ Course Card → Course Notes (NAMED + ARGUMENTS)
        Navigator.pushNamed(
          context,
          '/courseNotes',
          arguments: {
            'courseCode': course.code,    // Changed from 'code'
            'courseName': course.title,   // Changed from 'name'
          },
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
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
                    style: AppTextStyles.sectionTitle,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    course.title,
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: (course.faculty == 'FENS'
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
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.textSecondary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
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
