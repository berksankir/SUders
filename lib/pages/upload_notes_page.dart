import 'package:flutter/material.dart';
import 'package:suders/utils/app_colors.dart';
import 'package:suders/utils/app_text_styles.dart';
import 'package:suders/utils/app_paddings.dart';

class UploadNotesPage extends StatefulWidget {
  const UploadNotesPage({super.key});

  @override
  State<UploadNotesPage> createState() => _UploadNotesPageState();
}

class _UploadNotesPageState extends State<UploadNotesPage> {
  String? selectedCourse;
  String? selectedTerm;
  bool isAnonymous = false;

  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const sabanciBlue = Color(0xFF004B8D);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardAlt,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // ✔️ Named uyumlu
        ),
        centerTitle: true,
        title: Text(
          'Upload Notes',
          style: AppTextStyles.sectionTitle,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Upload Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cardAlt,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: sabanciBlue.withOpacity(0.15),
                          ),
                          child: const Icon(
                            Icons.cloud_upload_outlined,
                            size: 36,
                            color: sabanciBlue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Drag your file here',
                          style: AppTextStyles.sectionTitle,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Supports PDF, DOCX, PPTX, JPG. Max 25MB.',
                          style: AppTextStyles.body,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: sabanciBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Select File',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // COURSE DROPDOWN
                  Text(
                    'Course',
                    style: AppTextStyles.sectionTitle,
                  ),
                  const SizedBox(height: 6),
                  _DropdownField<String>(
                    value: selectedCourse,
                    hintText: 'Select course (e.g., CS 307)',
                    items: const [
                      'CS 307 - Software Engineering',
                      'ECON 204 - Microeconomics',
                      'SPS 303 - Political Philosophy',
                    ],
                    onChanged: (value) {
                      setState(() => selectedCourse = value);
                    },
                  ),

                  const SizedBox(height: 16),

                  // TERM
                  Text(
                    'Term',
                    style: AppTextStyles.sectionTitle,
                  ),
                  const SizedBox(height: 6),
                  _DropdownField<String>(
                    value: selectedTerm,
                    hintText: 'Select term (e.g., Fall 2023)',
                    items: const ['Fall 2023', 'Spring 2024', 'Fall 2024'],
                    onChanged: (value) {
                      setState(() => selectedTerm = value);
                    },
                  ),

                  const SizedBox(height: 16),

                  // DESCRIPTION
                  Text(
                    'Description',
                    style: AppTextStyles.sectionTitle,
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText:
                          'Add a helpful description, e.g., Midterm 1 notes, key concepts...',
                      hintStyle: AppTextStyles.body,
                      filled: true,
                      fillColor: AppColors.cardAlt,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: sabanciBlue,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    style: TextStyle(color: AppColors.textMain),
                  ),

                  const SizedBox(height: 18),

                  // Anonymous Switch
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cardAlt,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Post Anonymously',
                                style: AppTextStyles.sectionTitle,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Your name will be hidden from this post.',
                                style: AppTextStyles.small,
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: isAnonymous,
                          onChanged: (val) {
                            setState(() => isAnonymous = val);
                          },
                          activeThumbColor: AppColors.textMain,
                          activeTrackColor: sabanciBlue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardAlt,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: sabanciBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                    ),
                    child: Text(
                      'Upload Notes',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  final T? value;
  final String hintText;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  const _DropdownField({
    required this.value,
    required this.hintText,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.cardAlt,
          icon: const Icon(Icons.expand_more, color: AppColors.textSecondary),
          style: TextStyle(color: AppColors.textMain, fontSize: 14),
          hint: Text(
            hintText,
            style: AppTextStyles.body,
          ),
          items: items
              .map((e) =>
                  DropdownMenuItem<T>(value: e, child: Text(e.toString())))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
