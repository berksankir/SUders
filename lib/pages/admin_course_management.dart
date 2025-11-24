import 'package:flutter/material.dart';
import 'package:suders/pages/admin_dashboard_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manage Courses',
      theme: ThemeData(
        primaryColor: const Color(0xFF005A9C),
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        fontFamily: 'Lexend',
      ),
      darkTheme: ThemeData(
        primaryColor: const Color(0xFF005A9C),
        scaffoldBackgroundColor: const Color(0xFF101622),
        brightness: Brightness.dark,
        fontFamily: 'Lexend',
      ),
      themeMode: ThemeMode.dark,
      home: const ManageCoursesScreen(),
    );
  }
}

class Course {
  final String code;
  final String name;
  final String status;
  final IconData icon;

  Course({
    required this.code,
    required this.name,
    required this.status,
    required this.icon,
  });
}

class ManageCoursesScreen extends StatefulWidget {
  const ManageCoursesScreen({Key? key}) : super(key: key);

  @override
  State<ManageCoursesScreen> createState() => _ManageCoursesScreenState();
}

class _ManageCoursesScreenState extends State<ManageCoursesScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Course> courses = [
    Course(
      code: 'CS201',
      name: 'Introduction to Computer Science',
      status: 'Published',
      icon: Icons.code,
    ),
    Course(
      code: 'SPS303',
      name: 'Law and Ethics',
      status: 'Draft',
      icon: Icons.menu_book,
    ),
    Course(
      code: 'CS310',
      name: 'Mobile Application Development',
      status: 'Published',
      icon: Icons.code,
    ),
  ];

  // ---------------- DELETE DIALOG ----------------

  void _showDeleteDialog(int index) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final course = courses[index];

    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor:
          isDark ? const Color(0xFF101622) : Colors.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Delete Course?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Are you sure you want to delete ${course.code}?",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: isDark ? Colors.grey[300] : Colors.black87,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );

    if (result == true) {
      setState(() {
        courses.removeAt(index);
      });
    }
  }

  // ---------------- ADD / EDIT BOTTOM SHEET ----------------

  void _openCourseSheet({bool isEdit = false, Course? existing}) {
    final TextEditingController codeCtrl =
    TextEditingController(text: existing?.code ?? '');
    final TextEditingController nameCtrl =
    TextEditingController(text: existing?.name ?? '');

    String selectedStatus = existing?.status ?? 'Published';
    IconData selectedIcon = existing?.icon ?? Icons.code;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEdit ? "Edit Course" : "Add Course",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Code
                  _inputField(
                    controller: codeCtrl,
                    label: "Course Code",
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),

                  // Name
                  _inputField(
                    controller: nameCtrl,
                    label: "Course Name",
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),

                  // Status chips
                  Text(
                    "Status",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _statusChip(
                        label: "Published",
                        selected: selectedStatus == "Published",
                        color: const Color(0xFF00A79D),
                        onTap: () =>
                            setModalState(() => selectedStatus = "Published"),
                      ),
                      const SizedBox(width: 10),
                      _statusChip(
                        label: "Draft",
                        selected: selectedStatus == "Draft",
                        color: const Color(0xFF666666),
                        onTap: () =>
                            setModalState(() => selectedStatus = "Draft"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Icon select
                  Text(
                    "Icon",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _iconOption(
                        icon: Icons.code,
                        selected: selectedIcon == Icons.code,
                        onTap: () =>
                            setModalState(() => selectedIcon = Icons.code),
                      ),
                      const SizedBox(width: 12),
                      _iconOption(
                        icon: Icons.menu_book,
                        selected: selectedIcon == Icons.menu_book,
                        onTap: () => setModalState(
                                () => selectedIcon = Icons.menu_book),
                      ),
                      const SizedBox(width: 12),
                      _iconOption(
                        icon: Icons.computer,
                        selected: selectedIcon == Icons.computer,
                        onTap: () => setModalState(
                                () => selectedIcon = Icons.computer),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (codeCtrl.text.trim().isEmpty ||
                            nameCtrl.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Please fill in course code and name."),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        if (isEdit && existing != null) {
                          final idx = courses.indexOf(existing);
                          setState(() {
                            courses[idx] = Course(
                              code: codeCtrl.text.trim(),
                              name: nameCtrl.text.trim(),
                              status: selectedStatus,
                              icon: selectedIcon,
                            );
                          });
                        } else {
                          setState(() {
                            courses.add(
                              Course(
                                code: codeCtrl.text.trim(),
                                name: nameCtrl.text.trim(),
                                status: selectedStatus,
                                icon: selectedIcon,
                              ),
                            );
                          });
                        }

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005A9C),
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        isEdit ? "Save Changes" : "Add Course",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF101622) : const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor:
        isDark ? const Color(0xFF101622) : const Color(0xFFF5F5F7),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF232f48).withOpacity(0.3)
                : const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark
                  ? const Color(0xFFEAEAEB)
                  : const Color(0xFF333333),
              size: 20,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminDashboardScreen(),
                ),
              );
            },
          ),
        ),
        title: Text(
          'Manage Courses',
          style: TextStyle(
            color: isDark
                ? const Color(0xFFEAEAEB)
                : const Color(0xFF333333),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color:
            isDark ? const Color(0xFF232f48) : const Color(0xFFE0E0E0),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar (şimdilik sadece UI; filtrelemek istersen ayrıca ekleriz)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF101622)
                    : const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF232f48)
                      : const Color(0xFFE0E0E0),
                ),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by course name or code...',
                  hintStyle: TextStyle(
                    color: isDark
                        ? const Color(0xFF92a4c9)
                        : const Color(0xFF666666),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark
                        ? const Color(0xFF92a4c9)
                        : const Color(0xFF666666),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                ),
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFFEAEAEB)
                      : const Color(0xFF333333),
                ),
              ),
            ),
          ),
          // Course List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: courses.length,
              separatorBuilder: (context, index) =>
              const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final course = courses[index];
                return CourseCard(
                  course: course,
                  isDark: isDark,
                  onEdit: () =>
                      _openCourseSheet(isEdit: true, existing: course),
                  onDelete: () => _showDeleteDialog(index),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 8, right: 8),
        child: FloatingActionButton(
          onPressed: () => _openCourseSheet(),
          backgroundColor: const Color(0xFF005A9C),
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
    );
  }

  // ---------------- HELPERS ----------------

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required bool isDark,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(
        color: isDark ? const Color(0xFFEAEAEB) : const Color(0xFF333333),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color:
          isDark ? const Color(0xFF92a4c9) : const Color(0xFF666666),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color:
            isDark ? const Color(0xFF232f48) : const Color(0xFFE0E0E0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF005A9C)),
        ),
      ),
    );
  }

  Widget _statusChip({
    required String label,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? color : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _iconOption({
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? const Color(0xFF005A9C) : Colors.grey,
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: selected ? const Color(0xFF005A9C) : Colors.grey,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class CourseCard extends StatelessWidget {
  final Course course;
  final bool isDark;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CourseCard({
    Key? key,
    required this.course,
    required this.isDark,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPublished = course.status == 'Published';

    return Container(
      decoration: BoxDecoration(
        color:
        isDark ? const Color(0xFF101622) : const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
          isDark ? const Color(0xFF232f48) : const Color(0xFFE0E0E0),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF005A9C).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              course.icon,
              color: const Color(0xFF005A9C),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          // Course Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.code,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? const Color(0xFFEAEAEB)
                        : const Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  course.name,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? const Color(0xFF92a4c9)
                        : const Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPublished
                        ? const Color(0xFF00A79D).withOpacity(0.2)
                        : (isDark
                        ? const Color(0xFF92a4c9).withOpacity(0.2)
                        : const Color(0xFF666666).withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    course.status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isPublished
                          ? const Color(0xFF00A79D)
                          : (isDark
                          ? const Color(0xFF92a4c9)
                          : const Color(0xFF666666)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: isDark
                      ? const Color(0xFFEAEAEB)
                      : const Color(0xFF333333),
                  size: 20,
                ),
                onPressed: onEdit,
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Color(0xFFD32F2F),
                  size: 20,
                ),
                onPressed: onDelete,
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
