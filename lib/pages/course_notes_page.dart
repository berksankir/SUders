import 'package:flutter/material.dart';
import 'package:suders/utils/app_colors.dart';
import 'package:suders/utils/app_text_styles.dart';
import 'package:suders/utils/app_paddings.dart';

class CourseNotesPage extends StatefulWidget {
  final String courseCode;
  final String courseName;

  const CourseNotesPage({
    super.key,
    required this.courseCode,
    required this.courseName,
  });

  @override
  State<CourseNotesPage> createState() => _CourseNotesPageState();
}

class _CourseNotesPageState extends State<CourseNotesPage> {
  String selectedYear = '2024-2025';
  String selectedTerm = 'Fall';

  final List<_Note> notes = [
    _Note(
      termLabel: '2025 Spring',
      title: 'Midterm 1 Review Sheet',
      uploader: 'Anonymous',
      upVotes: 12,
      downVotes: 1,
    ),
    _Note(
      termLabel: '2024 Fall',
      title: 'Finals Cheat Sheet',
      uploader: 'Jane Doe',
      upVotes: 8,
      downVotes: 0,
    ),
    _Note(
      termLabel: '2024 Fall',
      title: 'Lecture 5 Notes - Big O',
      uploader: 'John Appleseed',
      upVotes: 5,
      downVotes: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          '${widget.courseCode} - ${widget.courseName}',
          style: AppTextStyles.sectionTitle,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _DropdownBox<String>(
                          value: selectedYear,
                          items: const ['2024-2025', '2023-2024', '2022-2023'],
                          labelBuilder: (v) => 'Year: $v',
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() => selectedYear = v);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DropdownBox<String>(
                          value: selectedTerm,
                          items: const ['Fall', 'Spring', 'Summer'],
                          labelBuilder: (v) => 'Term: $v',
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() => selectedTerm = v);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Course Notes',
                    style: AppTextStyles.title,
                  ),
                  const SizedBox(height: 12),

                  Column(
                    children: [
                      for (final note in notes)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _NoteCard(
                            note: note,
                            onDownload: () {},
                            onUpvote: () {
                              setState(() {
                                note.upVotes++;
                              });
                            },
                            onDownvote: () {
                              setState(() {
                                note.downVotes++;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ✅ NAMED ROUTE İLE UPLOAD'A GİDİYOR
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background.withOpacity(0.9),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/uploadNotes');
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text(
                      'Upload New Note',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
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

// ----------------- Model -----------------

class _Note {
  final String termLabel;
  final String title;
  final String uploader;
  int upVotes;
  int downVotes;

  _Note({
    required this.termLabel,
    required this.title,
    required this.uploader,
    required this.upVotes,
    required this.downVotes,
  });
}

// ----------------- Note Card -----------------

class _NoteCard extends StatelessWidget {
  final _Note note;
  final VoidCallback onDownload;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;

  const _NoteCard({
    required this.note,
    required this.onDownload,
    required this.onUpvote,
    required this.onDownvote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(blurRadius: 8, offset: Offset(0, 4), color: Colors.black26),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.termLabel,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            note.title,
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: 2),
          Text(
            'Uploaded by ${note.uploader}',
            style: AppTextStyles.small,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: onUpvote,
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          note.upVotes.toString(),
                          style: AppTextStyles.small,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: onDownvote,
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_downward,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          note.downVotes.toString(),
                          style: AppTextStyles.small,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.cardAlt,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onDownload,
                icon: const Icon(Icons.download, color: AppColors.textMain, size: 18),
                label: Text(
                  'Download',
                  style: AppTextStyles.small.copyWith(color: AppColors.textMain),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ----------------- Dropdown -----------------

class _DropdownBox<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T?> onChanged;

  const _DropdownBox({
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.card,
          icon: const Icon(Icons.expand_more, color: AppColors.textSecondary),
          style: TextStyle(color: AppColors.textMain),
          items: items
              .map(
                (e) =>
                    DropdownMenuItem<T>(value: e, child: Text(labelBuilder(e))),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
