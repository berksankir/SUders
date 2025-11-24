import 'package:flutter/material.dart';
import 'package:suders/pages/admin_dashboard_page.dart';
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manage Instructors',
      theme: ThemeData(
        primaryColor: const Color(0xFF0D47A1),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Lexend',
      ),
      darkTheme: ThemeData(
        primaryColor: const Color(0xFF0D47A1),
        scaffoldBackgroundColor: const Color(0xFF101622),
        brightness: Brightness.dark,
        fontFamily: 'Lexend',
      ),
      themeMode: ThemeMode.dark,
      home: const ManageInstructorsScreen(),
    );
  }
}

// --------------------------------------------
// MODEL
// --------------------------------------------

class Instructor {
  final String name;
  final String faculty;
  final String imageUrl;

  Instructor({
    required this.name,
    required this.faculty,
    required this.imageUrl,
  });
}

// --------------------------------------------
// MAIN SCREEN
// --------------------------------------------

class ManageInstructorsScreen extends StatefulWidget {
  const ManageInstructorsScreen({Key? key}) : super(key: key);

  @override
  State<ManageInstructorsScreen> createState() =>
      _ManageInstructorsScreenState();
}

class _ManageInstructorsScreenState extends State<ManageInstructorsScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Instructor> instructors = [
    Instructor(
      name: 'Albert Levi',
      faculty: 'Faculty of Engineering and Natural Sciences',
      imageUrl:
      'https://www.sabanciuniv.edu/en/academic-staff/albert-levi',
    ),
    Instructor(
      name: 'Atıl Utku Ay',
      faculty: 'Faculty of Engineering and Natural Sciences',
      imageUrl:
      'https://www.sabanciuniv.edu/rehber/fotograflar/other/3742.jpg',
    ),
    Instructor(
      name: 'Robert Booth',
      faculty: 'Faculty of Social Sciences',
      imageUrl:
      'https://miro.medium.com/v2/resize:fit:2400/1*NK3ES5E_CE1JJtHCjjj6kg.jpeg',
    ),
  ];

  // --------------------------------------------
  // DELETE DIALOG
  // --------------------------------------------

  void _showDeleteDialog(int index) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Delete Instructor?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "This action cannot be undone.",
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
                      child:
                      const Text("Delete", style: TextStyle(color: Colors.white)),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );

    if (result == true) {
      setState(() => instructors.removeAt(index));
    }
  }

  // --------------------------------------------
  // ADD INSTRUCTOR (BOTTOM SHEET)
  // --------------------------------------------

  void _showAddInstructorSheet() {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController facultyCtrl = TextEditingController();
    final TextEditingController urlCtrl = TextEditingController();

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
        child: StatefulBuilder(builder: (context, setModal) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Instructor",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // NAME
                _inputField(
                  controller: nameCtrl,
                  label: "Name",
                  isDark: isDark,
                ),
                const SizedBox(height: 12),

                // FACULTY
                _inputField(
                  controller: facultyCtrl,
                  label: "Faculty",
                  isDark: isDark,
                ),
                const SizedBox(height: 12),

                // IMAGE URL
                _inputField(
                  controller: urlCtrl,
                  label: "Image URL (optional)",
                  isDark: isDark,
                ),

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameCtrl.text.isEmpty ||
                          facultyCtrl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                              Text("Please fill in required fields")),
                        );
                        return;
                      }

                      setState(() {
                        instructors.add(
                          Instructor(
                            name: nameCtrl.text,
                            faculty: facultyCtrl.text,
                            imageUrl: urlCtrl.text.isEmpty
                                ? "https://via.placeholder.com/150"
                                : urlCtrl.text,
                          ),
                        );
                      });

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Add Instructor",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          );
        }),
      ),
    );
  }

  // --------------------------------------------
  // BUILD
  // --------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AdminDashboardScreen(),
              ),
            );
          },
        ),
        title: const Text(
          "Manage Instructors",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddInstructorSheet,
        backgroundColor: const Color(0xFF0D47A1),
        child: const Icon(Icons.add, size: 30),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // SEARCH BAR
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1F2937) : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search,
                      color: isDark ? Colors.grey[400] : Colors.grey[700]),
                  hintText: "Search instructors...",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // LIST
            Expanded(
              child: ListView.separated(
                itemBuilder: (_, i) {
                  return InstructorCard(
                    instructor: instructors[i],
                    isDark: isDark,
                    onDeletePressed: () => _showDeleteDialog(i),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemCount: instructors.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------
  // REUSABLE TEXT FIELD
  // --------------------------------------------

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required bool isDark,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
        TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[700]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: isDark ? Colors.grey[600]! : Colors.grey[300]!),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF0D47A1)),
        ),
      ),
    );
  }
}

// --------------------------------------------
// INSTRUCTOR CARD
// --------------------------------------------

class InstructorCard extends StatelessWidget {
  final Instructor instructor;
  final bool isDark;
  final VoidCallback onDeletePressed;

  const InstructorCard({
    Key? key,
    required this.instructor,
    required this.isDark,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFF0D47A1).withOpacity(0.25),
            child: ClipOval(
              child: Image.network(
                instructor.imageUrl,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Center(
                    child: Text(
                      instructor.name[0].toUpperCase(),
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D47A1)),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),

          // INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  instructor.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  instructor.faculty,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: onDeletePressed,
            icon: const Icon(Icons.delete, color: Colors.red),
          )
        ],
      ),
    );
  }
}
